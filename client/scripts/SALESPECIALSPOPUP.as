package
{
   import com.monsters.display.BuildingAssetContainer;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import gs.TweenLite;
   import gs.easing.*;
   
   public class SALESPECIALSPOPUP extends SALESPECIALSPOPUP_CLIP
   {
      
      public static var imageContainer:BuildingAssetContainer;
      
      public static var _open:Boolean;
      
      public static var _do:DisplayObject;
      
      public static var _iconsDO:DisplayObject;
      
      public static var _saleDuration:Number = 60 * 10;
      
      public static var _saleEnd:Number;
      
      public static var _page:String;
      
      public static var _alreadyDone:Boolean = false;
      
      public static var _popup:SALESPECIALSPOPUP;
      
      private static var _props:Object;
       
      
      public var _numGifts:int = 5;
      
      public var _giftSpacing:Number = 5;
      
      private var _giftsArray:Array;
      
      private var _giftItem:String = "HOD2";
      
      private var _textProps:Object;
      
      private var _giftProps:Object;
      
      private var _giftConfirmProps:Object;
      
      private var _shinyDiscountProps:Object;
      
      private var _shinyBonusProps:Object;
      
      private var _sevenElevenBigGulpProps:Object;
      
      private var _sevenElevenBigGulpTutorialProps:Object;
      
      public function SALESPECIALSPOPUP(param1:String = "text")
      {
         this._textProps = {
            "tTitleX":-150,
            "tTitleY":-100,
            "tTitleW":300,
            "tTitleH":70,
            "tDescX":-150,
            "tDescY":-50,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-75,
            "bActionY":50,
            "bActionW":150,
            "bActionH":30,
            "bAction2X":-75,
            "bAction2Y":50,
            "bAction2W":150,
            "bAction2H":30,
            "mcIconsX":0,
            "mcIconsY":0,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-170,
            "mcFrameY":-130,
            "mcFrameW":340,
            "mcFrameH":220,
            "tTitleText":KEYS.Get("special_textprops_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br>",
            "tDescText3":KEYS.Get("special_textprops_desc3"),
            "bActionText":KEYS.Get("special_buyshiny")
         };
         this._giftProps = {
            "tTitleX":-150,
            "tTitleY":-100,
            "tTitleW":300,
            "tTitleH":70,
            "tDescX":-150,
            "tDescY":-70,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-75,
            "bActionY":110,
            "bActionW":150,
            "bActionH":30,
            "bAction2X":-75,
            "bAction2Y":50,
            "bAction2W":150,
            "bAction2H":30,
            "mcIconsX":-190,
            "mcIconsY":-25,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-210,
            "mcFrameY":-130,
            "mcFrameW":420,
            "mcFrameH":290,
            "tTitleText":KEYS.Get("special_giftprops_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br><br><br><br><br><br><br>",
            "tDescText3":KEYS.Get("special_giftprops_desc3"),
            "bActionText":KEYS.Get("special_buyshiny")
         };
         this._giftConfirmProps = {
            "tTitleX":-150,
            "tTitleY":-100,
            "tTitleW":300,
            "tTitleH":70,
            "tDescX":-150,
            "tDescY":-60,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-75,
            "bActionY":110,
            "bActionW":150,
            "bActionH":30,
            "bAction2X":-75,
            "bAction2Y":50,
            "bAction2W":150,
            "bAction2H":30,
            "mcIconsX":-190,
            "mcIconsY":-55,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-210,
            "mcFrameY":-130,
            "mcFrameW":420,
            "mcFrameH":290,
            "tTitleText":KEYS.Get("special_giftconfirmprops_title"),
            "tDescText1":"",
            "tDescText2":"<br><br><br><br><br><br>",
            "tDescText3":KEYS.Get("special_giftconfirmprops_desc3"),
            "bActionText":KEYS.Get("special_gotostore")
         };
         this._shinyDiscountProps = {
            "tTitleX":-150,
            "tTitleY":-100,
            "tTitleW":300,
            "tTitleH":70,
            "tDescX":-150,
            "tDescY":-70,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-75,
            "bActionY":30,
            "bActionW":150,
            "bActionH":30,
            "bAction2X":-75,
            "bAction2Y":50,
            "bAction2W":150,
            "bAction2H":30,
            "mcIconsX":0,
            "mcIconsY":0,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-170,
            "mcFrameY":-130,
            "mcFrameW":340,
            "mcFrameH":200,
            "tTitleText":KEYS.Get("special_shinydiscount_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br>",
            "tDescText3":KEYS.Get("special_shinydiscount_desc3"),
            "bActionText":KEYS.Get("special_buyshiny")
         };
         this._shinyBonusProps = {
            "tTitleX":-150,
            "tTitleY":-100,
            "tTitleW":300,
            "tTitleH":70,
            "tDescX":-150,
            "tDescY":-70,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-75,
            "bActionY":30,
            "bActionW":150,
            "bActionH":30,
            "bAction2X":-75,
            "bAction2Y":50,
            "bAction2W":150,
            "bAction2H":30,
            "mcIconsX":0,
            "mcIconsY":0,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-170,
            "mcFrameY":-130,
            "mcFrameW":340,
            "mcFrameH":200,
            "tTitleText":KEYS.Get("special_shinybonus_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br>",
            "tDescText3":KEYS.Get("special_shinybonus"),
            "bActionText":KEYS.Get("special_buyshiny")
         };
         this._sevenElevenBigGulpProps = {
            "tTitleX":-105,
            "tTitleY":108,
            "tTitleW":90,
            "tTitleH":35,
            "tDescX":-150,
            "tDescY":-70,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-110,
            "bActionY":105,
            "bActionW":100,
            "bActionH":45,
            "bAction2X":25,
            "bAction2Y":105,
            "bAction2W":100,
            "bAction2H":45,
            "mcIconsX":0,
            "mcIconsY":0,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-180,
            "mcFrameY":-175,
            "mcFrameW":360,
            "mcFrameH":350,
            "tTitleText":KEYS.Get("special_gbg_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br>",
            "tDescText3":KEYS.Get("special_shinybonus"),
            "bActionText":KEYS.Get("special_goldenbiggulp"),
            "bActionText2":KEYS.Get("special_hatcheryod")
         };
         this._sevenElevenBigGulpTutorialProps = {
            "tTitleX":-50,
            "tTitleY":108,
            "tTitleW":90,
            "tTitleH":35,
            "tDescX":-150,
            "tDescY":-70,
            "tDescW":300,
            "tDescH":100,
            "bActionX":-50,
            "bActionY":105,
            "bActionW":100,
            "bActionH":45,
            "bAction2X":25,
            "bAction2Y":105,
            "bAction2W":100,
            "bAction2H":45,
            "mcIconsX":0,
            "mcIconsY":0,
            "mcIconsW":0,
            "mcIconsH":0,
            "mcFrameX":-180,
            "mcFrameY":-175,
            "mcFrameW":360,
            "mcFrameH":350,
            "tTitleText":KEYS.Get("special_gbg_title"),
            "tDescText1":KEYS.Get("special_limitedtime"),
            "tDescText2":KEYS.Get("special_remaining") + "<br><br>",
            "tDescText3":KEYS.Get("special_shinybonus"),
            "bActionText":KEYS.Get("special_goldenbiggulp"),
            "bActionText2":KEYS.Get("special_hatcheryod")
         };
         super();
         _page = param1;
         this.Switch(_page);
      }
      
      public static function Check() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !GLOBAL._monetized && !SALESPECIALSPOPUP._open && BASE.BaseLevel().level >= 26 && !_alreadyDone)
         {
            _loc1_ = 0;
            _loc2_ = int(LOGIN._digits[LOGIN._digits.length - 1]);
            _loc3_ = int(LOGIN._digits[LOGIN._digits.length - 2]);
            _loc5_ = ((_loc4_ = int(LOGIN._digits[LOGIN._digits.length - 3])) + _loc2_) % 10;
            _loc6_ = (_loc3_ + _loc2_) % 10;
            if(_loc5_ <= 7)
            {
               _loc1_ = 0;
            }
            else if(_loc5_ == 8)
            {
               if(_loc6_ <= 4)
               {
                  _loc1_ = 1;
               }
               else
               {
                  _loc1_ = 2;
               }
            }
            else if(_loc5_ == 9)
            {
               if(_loc6_ <= 4)
               {
                  _loc1_ = 3;
               }
               else
               {
                  _loc1_ = 4;
               }
            }
            if(_loc1_ != 0)
            {
               SALESPECIALSPOPUP.CheckPromoTimer();
            }
            _alreadyDone = true;
         }
      }
      
      public static function Show(param1:String = "text") : void
      {
         if(!_open)
         {
            SOUNDS.Play("click1");
            BASE.BuildingDeselect();
            _open = true;
            _page = param1;
            _popup = new SALESPECIALSPOPUP(param1);
            if(param1 == "biggulp")
            {
               POPUPS.Push(_popup,BUY.logFB711RedeemShown,[param1],null,null,false);
            }
            else
            {
               CheckPromoTimer();
               POPUPS.Push(_popup,BUY.logPromoShown,[param1],null,null,false);
            }
            TweenLite.to(_do,0.2,{
               "scaleX":1,
               "scaleY":1,
               "ease":Quad.easeOut
            });
            if(!_saleEnd && param1 != "giftconfirm" && param1 != "biggulp")
            {
               SALESPECIALSPOPUP.StartSale();
            }
            _popup.Switch(_page);
            _popup.addEventListener(Event.ENTER_FRAME,SALESPECIALSPOPUP.Tick);
            if(_page == "biggulp")
            {
               _popup.gotoAndStop("redeem");
               _popup.bAction3.buttonMode = true;
               _popup.bAction3.useHandCursor = true;
               _popup.bAction3.mouseChildren = false;
               _popup.bAction3.addEventListener(MouseEvent.CLICK,SALESPECIALSPOPUP.OnActionClick);
               _popup.bAction4.buttonMode = true;
               _popup.bAction4.useHandCursor = true;
               _popup.bAction4.mouseChildren = false;
               _popup.bAction4.addEventListener(MouseEvent.CLICK,SALESPECIALSPOPUP.OnActionClick);
            }
            else
            {
               _popup.gotoAndStop(1);
               _popup.bAction.addEventListener(MouseEvent.CLICK,SALESPECIALSPOPUP.OnActionClick);
               _popup.bAction2.addEventListener(MouseEvent.CLICK,SALESPECIALSPOPUP.OnActionClick);
            }
         }
      }
      
      public static function Tick(param1:Event) : void
      {
         if(_open && Boolean(_popup))
         {
            _popup.Update(_page);
         }
         if(_saleEnd < GLOBAL.Timestamp())
         {
            SALESPECIALSPOPUP.EndSale();
         }
      }
      
      public static function CheckPromoTimer() : void
      {
         GLOBAL.CallJS("cc.startPromoTimer",[{"callback":"startPromoTimer"}]);
      }
      
      public static function StartSale(param1:int = 0) : void
      {
         if(param1 > 0 && param1 > GLOBAL.Timestamp())
         {
            _saleEnd = param1;
            if(GLOBAL._flags.midgameIncentive == 1)
            {
               SALESPECIALSPOPUP.Show("text");
            }
            else if(GLOBAL._flags.midgameIncentive == 2)
            {
               SALESPECIALSPOPUP.Show("gift");
            }
            else if(GLOBAL._flags.midgameIncentive == 3)
            {
               SALESPECIALSPOPUP.Show("shinydiscount");
            }
            else if(GLOBAL._flags.midgameIncentive == 4)
            {
               SALESPECIALSPOPUP.Show("shinybonus");
            }
            else if(GLOBAL._flags.midgameIncentive == 5)
            {
               SALESPECIALSPOPUP.Show("giftconfirm");
            }
         }
      }
      
      public static function EndSale() : void
      {
         _saleEnd = GLOBAL.Timestamp();
      }
      
      public static function OnActionClick(param1:MouseEvent = null) : void
      {
         if(_page == "giftconfirm")
         {
            POPUPS.Next();
            if(!BASE.isInfernoMainYardOrOutpost)
            {
               STORE.ShowB(3,1,["HOD","HOD2","HOD3"]);
            }
            else
            {
               STORE.ShowB(3,1,["HODI","HOD2I","HOD3I"]);
            }
         }
         else if(_page == "biggulp")
         {
            if(param1.currentTarget == _popup.bAction4)
            {
               if(TUTORIAL._stage < 200)
               {
                  POPUPS.Next();
               }
               else
               {
                  POPUPS.Next();
                  if(!BASE.isInfernoMainYardOrOutpost)
                  {
                     STORE.ShowB(3,1,["HOD","HOD2","HOD3"]);
                  }
                  else
                  {
                     STORE.ShowB(3,1,["HODI","HOD2I","HOD3I"]);
                  }
               }
            }
            else if(param1.currentTarget == _popup.bAction3)
            {
               if(TUTORIAL._stage < 200)
               {
                  POPUPS.Next();
               }
               else
               {
                  BUILDINGS._buildingID = 120;
                  BUILDINGS.Show();
                  BUILDINGS._mc.SwitchB(4,4,0);
                  POPUPS.Next();
               }
            }
         }
         else
         {
            BUY.MidGameOffers(_page);
         }
      }
      
      public static function Hide() : void
      {
         if(_open)
         {
            SOUNDS.Play("close");
            _open = false;
            _popup.removeEventListener(Event.ENTER_FRAME,SALESPECIALSPOPUP.Tick);
            if(_popup.bAction)
            {
               _popup.bAction.removeEventListener(MouseEvent.CLICK,OnActionClick);
            }
            if(_popup.bAction2)
            {
               _popup.bAction2.removeEventListener(MouseEvent.CLICK,OnActionClick);
            }
            if(_popup.bAction3)
            {
               _popup.bAction3.removeEventListener(MouseEvent.CLICK,OnActionClick);
            }
            if(_popup.bAction4)
            {
               _popup.bAction4.removeEventListener(MouseEvent.CLICK,OnActionClick);
            }
            POPUPS.Next();
         }
      }
      
      public function Switch(param1:String = "text") : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:store_icon_CLIP = null;
         this.gotoAndStop("redeem");
         switch(param1)
         {
            case "text":
               _props = this._textProps;
               break;
            case "gift":
               _props = this._giftProps;
               break;
            case "giftconfirm":
               _props = this._giftConfirmProps;
               break;
            case "shinydiscount":
               _props = this._shinyDiscountProps;
               break;
            case "shinybonus":
               _props = this._shinyBonusProps;
               break;
            case "biggulp":
               this.gotoAndStop("redeem");
               if(TUTORIAL._stage < 200)
               {
                  _props = this._sevenElevenBigGulpTutorialProps;
               }
               else
               {
                  _props = this._sevenElevenBigGulpProps;
               }
         }
         if(param1 == "biggulp")
         {
            this.gotoAndStop("redeem");
            if(this.bAction)
            {
               this.bAction.visible = false;
            }
            if(this.bAction2)
            {
               this.bAction2.visible = false;
            }
            this.bAction3.x = _props.bActionX;
            this.bAction3.y = _props.bActionY;
            this.bAction3.width = _props.bActionW;
            this.bAction3.height = _props.bActionH;
            this.bAction3.txt.htmlText = _props.bActionText;
            this.bAction3.visible = true;
            this.bAction4.x = _props.bAction2X;
            this.bAction4.y = _props.bAction2Y;
            this.bAction4.width = _props.bAction2W;
            this.bAction4.height = _props.bAction2H;
            this.bAction4.txt.htmlText = _props.bActionText2;
            if(TUTORIAL._stage < 200)
            {
               if(this.bAction3)
               {
                  this.bAction3.visible = true;
                  this.bAction3.txt.htmlText = KEYS.Get("tut_continue");
               }
               if(this.bAction4)
               {
                  this.bAction4.visible = false;
               }
            }
            else
            {
               if(this.bAction3)
               {
                  this.bAction3.visible = true;
               }
               if(this.bAction4)
               {
                  this.bAction4.visible = true;
               }
            }
         }
         else
         {
            this.tTitle.x = _props.tTitleX;
            this.tTitle.y = _props.tTitleY;
            this.tTitle.width = _props.tTitleW;
            this.tTitle.height = _props.tTitleH;
            this.tTitle.htmlText = _props.tTitleText;
            this.tDesc.x = _props.tDescX;
            this.tDesc.y = _props.tDescY;
            this.tDesc.width = _props.tDescW;
            this.tDesc.height = _props.tDescH;
            this.tDesc.htmlText = _props.tTitleText;
            this.bAction.x = _props.bActionX;
            this.bAction.y = _props.bActionY;
            this.bAction.width = _props.bActionW;
            this.bAction.height = _props.bActionH;
            this.bAction.Setup(_props.bActionText);
            this.bAction.visible = true;
            this.bAction2.x = _props.bAction2X;
            this.bAction2.y = _props.bAction2Y;
            this.bAction2.width = _props.bAction2W;
            this.bAction2.height = _props.bAction2H;
            this.bAction2.Setup(_props.bActionText2);
         }
         if(_page != "biggulp")
         {
            this.bAction2.visible = false;
         }
         this.mcFrame.x = _props.mcFrameX;
         this.mcFrame.y = _props.mcFrameY;
         this.mcFrame.width = _props.mcFrameW;
         this.mcFrame.height = _props.mcFrameH;
         if(_page == "gift" || _page == "giftconfirm")
         {
            if(Boolean(_iconsDO) && Boolean(_iconsDO.parent))
            {
               _iconsDO.parent.removeChild(_iconsDO);
               _iconsDO = null;
            }
            this._giftsArray = [];
            _loc2_ = Number(_props.mcIconsX);
            _loc3_ = Number(_props.mcIconsY);
            _loc4_ = new MovieClip();
            _loc5_ = 0;
            while(_loc5_ < this._numGifts)
            {
               (_loc6_ = new store_icon_CLIP()).gotoAndStop(this._giftItem);
               _loc6_.x = _loc2_;
               _loc6_.y = _loc3_;
               _loc2_ += this._giftSpacing + _loc6_.width;
               _loc4_.addChild(_loc6_);
               _loc5_++;
            }
            _iconsDO = this.addChild(_loc4_);
         }
         this.Update(_page);
      }
      
      public function Update(param1:String = "text") : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         if(_page != "biggulp")
         {
            _loc2_ = "";
            _loc4_ = _saleEnd - GLOBAL.Timestamp();
            _loc3_ = GLOBAL.ToTime(_loc4_);
            _loc2_ += _props.tDescText1;
            if(_page != "giftconfirm")
            {
               _loc2_ += "<b>" + _loc3_ + "</b>";
            }
            _loc2_ += _props.tDescText2;
            _loc2_ += _props.tDescText3;
            this.tDesc.htmlText = _loc2_;
            this.tDesc.autoSize = TextFieldAutoSize.CENTER;
         }
      }
      
      public function Hide(param1:MouseEvent = null) : void
      {
         SALESPECIALSPOPUP.Hide();
      }
   }
}
