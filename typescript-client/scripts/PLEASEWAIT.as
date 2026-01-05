package
{
   import flash.display.MovieClip;
   import flash.utils.*;
   import gs.easing.*;
   
   public class PLEASEWAIT extends MovieClip
   {
      
      public static var _mc:PLEASEWAITMC;
      
      public static var _mcCount:int = 0;
      
      public static var _mcTips:MovieClip;
      
      public static var lastTipTime:Number = 0;
      
      public static var processDuration:int = 0;
      
      public static var processThreshold:int = 60 * 60 * 12;
      
      public static var tipsAvailable:int = 33;
      
      public static var tipIndex:int = 0;
      
      public static var tipDelay:int = 6;
      
      public static var tips:Array = [];
      
      public static var tipsInited:Boolean;
      
      public static var tipsLocalKey:String = "tips_hint";
       
      
      public function PLEASEWAIT()
      {
         super();
      }
      
      public static function Show(param1:String) : void
      {
         if(!_mc)
         {
            _mc = GLOBAL._layerTop.addChild(new PLEASEWAITMC()) as PLEASEWAITMC;
            _mc.tMessage.htmlText = "<b>" + param1 + "</b>";
            _mc.mcFrame.Setup(false);
            POPUPSETTINGS.AlignToCenter(_mc);
         }
      }
      
      public static function Update(param1:String = "Processing...") : void
      {
         if(_mc)
         {
            _mc.tMessage.htmlText = "<b>" + param1 + "</b>";
            AddTips();
         }
      }
      
      public static function Hide() : void
      {
         try
         {
            if(_mc)
            {
               GLOBAL._layerTop.removeChild(_mc);
               _mc.mcFrame = null;
               _mc = null;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public static function MessageChange(... rest) : void
      {
         _mc.tMessage.text = rest[0];
      }
      
      public static function AddTips() : void
      {
         if(GLOBAL._giveTips && KEYS._setup && HasTips())
         {
            if(BASE._catchupTime && BASE._catchupTime >= processThreshold && lastTipTime == 0 && GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard && GLOBAL._whatsnewid == GLOBAL._lastWhatsNew)
            {
               if(GLOBAL.StatGet("tipno"))
               {
                  tipIndex = GLOBAL.StatGet("tipno");
               }
               if(tipIndex < tips.length)
               {
                  ShowTips(tips[tipIndex]);
               }
               GLOBAL.StatSet("tipno",tipIndex + 1);
            }
         }
      }
      
      public static function HasTips() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc1_:Boolean = true;
         if(tipsInited)
         {
            return true;
         }
         tips = [];
         _loc2_ = 1;
         while(_loc2_ <= tipsAvailable)
         {
            _loc3_ = "" + tipsLocalKey + _loc2_;
            if((_loc4_ = KEYS.Get(_loc3_)) == "")
            {
               _loc1_ = false;
            }
            tips.push(_loc4_);
            _loc2_++;
         }
         if(_loc1_)
         {
            tipsInited = true;
         }
         return _loc1_;
      }
      
      public static function ShowTips(param1:String) : void
      {
         GLOBAL._proTip = new PROTIP_CLIP();
         GLOBAL._proTip.tTitle.htmlText = KEYS.Get("tips_title");
         GLOBAL._proTip.tDesc.htmlText = "<b>" + param1 + "</b>";
         GLOBAL._proTip.x = 390;
         GLOBAL._proTip.y = 240;
         POPUPS.Push(GLOBAL._proTip,null,null,null,null,true,"tip");
         POPUPS.Show("tip");
         lastTipTime = 1;
      }
      
      public static function HideTips() : void
      {
      }
   }
}
