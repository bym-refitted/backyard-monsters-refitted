package
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   
   public class SIGNS
   {
      
      public static var _mc:SIGNPOPUP;
      
      public static var _view:MovieClip;
       
      
      public function SIGNS()
      {
         super();
      }
      
      public static function CreateForBuilding(param1:BFOUNDATION) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(_mc == null)
         {
            SOUNDS.Play("click1");
            _mc = new SIGNPOPUP();
            GLOBAL._layerWindows.addChild(_mc);
            _mc._sign = param1;
            _mc._senderid = LOGIN._playerID;
            _mc._senderName = LOGIN._playerName;
            _mc._senderPic = LOGIN._playerPic;
            _mc._subject = "Sign";
            _mc._mode = "create";
            _mc.Setup();
         }
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            _loc2_ = param1._buildingProps.costs[0];
            _loc3_ = _loc2_.r5 != undefined ? int(_loc2_.r5) : 0;
            UPDATES.CreateB(["BE",BASE._loadedBaseID,_loc2_.r1.Get(),_loc2_.r2.Get(),_loc2_.r3.Get(),_loc2_.r4.Get(),_loc3_],0,-1);
         }
      }
      
      public static function ShowMessage(param1:BFOUNDATION) : void
      {
         SOUNDS.Play("click1");
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            MAILBOX.ShowWithThreadId(param1._threadid);
         }
         else
         {
            ViewForBuilding(param1);
         }
      }
      
      public static function ViewForBuilding(param1:BFOUNDATION) : void
      {
         var l:Loader = null;
         var onErr:Function = null;
         var onImageComplete:Function = null;
         var b:BFOUNDATION = param1;
         onErr = function(param1:IOErrorEvent):void
         {
         };
         onImageComplete = function(param1:Event):void
         {
            l.width = l.height = 50;
         };
         _view = new popup_sign_view();
         GLOBAL._layerWindows.addChild(_view);
         _view.subject_txt.text = b._subject;
         _view.name_txt.text = b._senderName;
         _view.closeBtn.addEventListener(MouseEvent.MOUSE_DOWN,Hide);
         l = new Loader();
         _view.placeholder.addChild(l);
         _view.x = GLOBAL._SCREENCENTER.x;
         _view.y = GLOBAL._SCREENCENTER.y;
         l.contentLoaderInfo.addEventListener(Event.COMPLETE,onImageComplete);
         l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onErr);
         try
         {
            l.load(new URLRequest(b._senderPic));
         }
         catch(e:*)
         {
         }
      }
      
      public static function EditForBuilding(param1:BFOUNDATION) : void
      {
         if(_mc == null)
         {
            _mc = new SIGNPOPUP();
            GLOBAL._layerWindows.addChild(_mc);
            _mc._sign = param1;
            _mc._senderid = LOGIN._playerID;
            _mc._subject = param1._subject;
            _mc._mode = "edit";
            _mc.Setup();
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_mc)
         {
            try
            {
               SOUNDS.Play("close");
               _mc.parent.removeChild(_mc);
            }
            catch(e:*)
            {
            }
            _mc = null;
         }
         if(_view)
         {
            try
            {
               SOUNDS.Play("close");
               _view.parent.removeChild(_view);
            }
            catch(e:*)
            {
            }
            _view = null;
         }
      }
   }
}