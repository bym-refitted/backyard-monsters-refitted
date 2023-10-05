package com.monsters.dealspot
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.Security;
   
   public class DealSpot extends MovieClip
   {
       
      
      public var _loader:Loader;
      
      public var _icon:MovieClip;
      
      public var _req:URLRequest;
      
      public var _reqURL:String = "http://assets.tp-cdn.com/static3/swf/dealspot.swf?";
      
      public var _reqAppID:String = "app_id=";
      
      public var _reqSID:String = "&mode=fbpayments&sid=";
      
      public var _reqCurrID:String = "&currency_url=";
      
      public var _tp2:String = "&touchpoint=2";
      
      public var _appIDVal:String;
      
      public var _sidVal:String;
      
      public var _currIDVal:String;
      
      public var _hasOffers:Boolean = true;
      
      public var _isClick:Boolean = false;
      
      public var _top:UI_TOP;
      
      public function DealSpot(param1:UI_TOP)
      {
         super();
         var _loc2_:LoaderContext = new LoaderContext();
         _loc2_.checkPolicyFile = true;
         Security.allowDomain("*");
         this._appIDVal = GLOBAL._appid;
         this._sidVal = GLOBAL._tpid;
         this._currIDVal = GLOBAL._currencyURL;
         this._top = param1;
         this._loader = new Loader();
         this._req = new URLRequest("" + this._reqURL + this._reqAppID + this._appIDVal + this._reqSID + this._sidVal + this._reqCurrID + this._currIDVal + this._tp2);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,GLOBAL.handleLoadError);
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderFinish);
         this._loader.addEventListener("trialpayClick",this.trialpayClick);
         this._loader.addEventListener("onOfferUnavailable",this.trialpayOfferUnavailable);
         if(ExternalInterface.available)
         {
            this._loader.load(this._req);
            addEventListener("trialpayClick",this.trialpayClick);
            addEventListener("trialpayOfferUnavailable",this.trialpayOfferUnavailable);
         }
      }
      
      public function onLoaderFinish(param1:Event) : void
      {
         addChild(this._loader.content);
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoaderFinish);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,GLOBAL.handleLoadError);
         addEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         this._loader.removeEventListener("trialpayClick",this.trialpayClick);
         this._loader.removeEventListener("onOfferUnavailable",this.trialpayOfferUnavailable);
      }
      
      public function onRollOver(param1:MouseEvent) : void
      {
         if(this._top._bubbleDo)
         {
            this._top.BubbleHide();
         }
         var _loc2_:String = KEYS.Get("popup_earnshiny");
         var _loc3_:int = this.parent.x + 80;
         var _loc4_:int = this.parent.y + 50;
         this._top.BubbleShow(_loc3_,_loc4_,_loc2_);
      }
      
      public function onRollOut(param1:MouseEvent) : void
      {
         this._top.BubbleHide();
      }
      
      public function trialpayClick(param1:Event) : void
      {
         this._isClick = true;
      }
      
      public function trialpayOfferUnavailable(param1:Event) : void
      {
         this.visible = false;
         this.enabled = false;
         removeEventListener("trialpayClick",this.trialpayClick);
         removeEventListener("trialpayOfferUnavailable",this.trialpayOfferUnavailable);
         removeEventListener(MouseEvent.MOUSE_OVER,this.onRollOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onRollOut);
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
