//
//  BymNotif.m  —  native side of the com.bym.notif AIR Native Extension (iOS only).
//
//  A tiny local-notifications extension built on UNUserNotificationCenter (the modern
//  UserNotifications framework, iOS 10+; works on iOS 26 / iPhone 17 Pro). It exposes four
//  FRE functions to ActionScript:
//
//     requestPermission()                          -> prompts once; dispatches "NOTIF_PERMISSION"
//                                                     status ("granted"/"denied")
//     schedule(id, title, body, seconds:Number)    -> local notification firing `seconds` from now
//     cancel(id)                                    -> removes one pending notification by id
//     cancelAll()                                   -> removes all pending notifications
//
//  Local notifications need NO push entitlement / APNs / provisioning capability, so this works
//  with free-provisioning sideload and is 100% client-side (no server traffic -> no ban risk).
//
//  Built into a static lib by ios/ane/build-ane.sh and packaged into com.bym.notif.ane.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import "FlashRuntimeExtensions.h"

// --- helpers ---------------------------------------------------------------

static NSString* freToNSString(FREObject obj)
{
    if (obj == NULL) return @"";
    uint32_t len = 0;
    const uint8_t* val = NULL;
    if (FREGetObjectAsUTF8(obj, &len, &val) != FRE_OK || val == NULL) return @"";
    // FREGetObjectAsUTF8's length includes the null terminator; stringWithUTF8String stops at it.
    NSString* s = [NSString stringWithUTF8String:(const char*)val];
    return s ? s : @"";
}

// --- FRE functions ---------------------------------------------------------

static FREObject requestPermission(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions opts = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [center requestAuthorizationWithOptions:opts
                          completionHandler:^(BOOL granted, NSError* _Nullable error) {
        // FREDispatchStatusEventAsync is the thread-safe way to call back from another thread.
        FREDispatchStatusEventAsync(ctx,
            (const uint8_t*)"NOTIF_PERMISSION",
            (const uint8_t*)(granted ? "granted" : "denied"));
    }];
    return NULL;
}

static FREObject scheduleNotif(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    if (argc < 4) return NULL;

    NSString* nid   = freToNSString(argv[0]);
    NSString* title = freToNSString(argv[1]);
    NSString* body  = freToNSString(argv[2]);
    double seconds = 0.0;
    if (FREGetObjectAsDouble(argv[3], &seconds) != FRE_OK) return NULL;
    if (seconds < 1.0) seconds = 1.0;              // UNTimeIntervalNotificationTrigger requires > 0
    if ([nid length] == 0) return NULL;

    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body  = body;
    // Custom bundled sound (notif.caf = macOS "Glass", packaged at the .app root via adt).
    // soundNamed: looks it up in the main bundle; falls back to the default if it's ever missing.
    content.sound = [UNNotificationSound soundNamed:@"notif.caf"];

    UNTimeIntervalNotificationTrigger* trigger =
        [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:seconds repeats:NO];
    UNNotificationRequest* req =
        [UNNotificationRequest requestWithIdentifier:nid content:content trigger:trigger];

    [[UNUserNotificationCenter currentNotificationCenter]
        addNotificationRequest:req withCompletionHandler:nil];
    return NULL;
}

static FREObject cancelNotif(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    if (argc < 1) return NULL;
    NSString* nid = freToNSString(argv[0]);
    if ([nid length] == 0) return NULL;
    [[UNUserNotificationCenter currentNotificationCenter]
        removePendingNotificationRequestsWithIdentifiers:@[nid]];
    return NULL;
}

static FREObject cancelAllNotifs(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    return NULL;
}

// --- extension plumbing ----------------------------------------------------

static void contextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                               uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet)
{
    // static so it outlives this call — AIR keeps the pointer.
    static FRENamedFunction functions[] = {
        { (const uint8_t*)"requestPermission", NULL, &requestPermission  },
        { (const uint8_t*)"schedule",          NULL, &scheduleNotif      },
        { (const uint8_t*)"cancel",            NULL, &cancelNotif        },
        { (const uint8_t*)"cancelAll",         NULL, &cancelAllNotifs    },
    };
    *numFunctionsToSet = sizeof(functions) / sizeof(functions[0]);
    *functionsToSet = functions;
}

static void contextFinalizer(FREContext ctx)
{
}

// Names referenced by extension.xml's <initializer>/<finalizer>. .m => C linkage, no mangling.
void BymNotifExtInitializer(void** extDataToSet,
                            FREContextInitializer* ctxInitializerToSet,
                            FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &contextInitializer;
    *ctxFinalizerToSet = &contextFinalizer;
}

void BymNotifExtFinalizer(void* extData)
{
}
