package com.monsters.maproom_inferno.views
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class DescentDebuffPopup extends descentDebuff_info_CLIP
   {
       
      
      public var maxDepth:int = 7;
      
      public var _t:Timer;
      
      public var currLvl:int = 0;
      
      public var depthTxt:String;
      
      public var depthTxt2:String;
      
      public var depthFlip:Boolean = false;
      
      public var debuffTip:MovieClip;
      
      public var depthDesc:String;
      
      public var depthDesc2:String;
      
      public function DescentDebuffPopup()
      {
         super();
      }
      
      public function initWithTitleAndButtons(param1:String, param2:Array, param3:Array) : void
      {
      }
      
      public function setHeightForButtons(param1:int) : void
      {
      }
      
      public function setDepth(param1:int) : void
      {
         this.currLvl = param1;
         switch(this.currLvl)
         {
            case 7:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = KEYS.Get("descent_depthBarWarn1");
               this.depthDesc = KEYS.Get("inf_descent_toxicity_desc");
               this.depthDesc2 = KEYS.Get("inf_descent_toxicity_desc_low");
               break;
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 8:
            default:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = "";
               this.depthDesc = "";
               this.depthDesc2 = "";
         }
         var _loc2_:Number = 100 / this.maxDepth * param1;
         depthBar.mcBar.width = Math.max(_loc2_,1);
         this.DepthCheck();
      }
      
      public function Show(param1:int = 0) : void
      {
         this.setDepth(param1);
         this.Resize();
         this._t = new Timer(1000);
         this._t.start();
         this._t.addEventListener(TimerEvent.TIMER,this.DepthCheck);
         addEventListener(MouseEvent.ROLL_OVER,this.DescentDebuffInfoShow);
         addEventListener(MouseEvent.ROLL_OUT,this.DescentDebuffInfoHide);
         UI2._top.addChild(this);
      }
      
      public function Hide() : void
      {
         this._t.stop();
         this._t.removeEventListener(TimerEvent.TIMER,this.DepthCheck);
         this._t = null;
         if(this.debuffTip)
         {
            this.DescentDebuffInfoHide(null);
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
            UI2._top._descentDebuff = null;
         }
      }
      
      public function DescentDebuffInfoShow(param1:MouseEvent = null) : void
      {
         this.debuffTip = new bubblepopupUpBuff_CLIP();
         this.debuffTip.x = -10;
         this.debuffTip.y = this.debuffTip.height + 5;
         this.debuffTip.mcArrow.x = this.debuffTip.width / 2 - 20;
         this.debuffTip.mcText.htmlText = KEYS.Get("inf_descent_toxicity_help");
         this.debuffTip.mcTextDuration.htmlText = "";
         addChild(this.debuffTip);
      }
      
      public function DescentDebuffInfoHide(param1:MouseEvent = null) : void
      {
         if(Boolean(this.debuffTip) && Boolean(this.debuffTip.parent))
         {
            this.debuffTip.parent.removeChild(this.debuffTip);
            this.debuffTip = null;
         }
      }
      
      public function DepthCheck(param1:TimerEvent = null) : void
      {
         this.depthFlip = !this.depthFlip;
         tDepth.htmlText = this.depthTxt;
         tDepth2.htmlText = this.depthTxt2;
         tDesc.htmlText = "<b>" + this.depthDesc + "<br>" + this.depthDesc2 + "</b>";
         if(this.depthFlip)
         {
            tDepth.visible = true;
            tDepth2.visible = false;
            if(this.currLvl <= 8)
            {
               tDepth.visible = true;
               tDepth2.visible = true;
            }
         }
         else
         {
            tDepth.visible = false;
            tDepth2.visible = true;
            if(this.currLvl <= 8)
            {
               tDepth.visible = true;
               tDepth2.visible = true;
            }
         }
      }
      
      public function Resize() : void
      {
         this.x = GLOBAL._SCREEN.x + GLOBAL._SCREEN.width - 160;
         var _loc1_:int = 0;
         if(UI2._top && UI2._top.mcSound && UI2._top.mcSound.visible)
         {
            _loc1_ = UI2._top.mcSound.y + UI2._top.mcSound.height;
         }
         this.y = GLOBAL._SCREEN.y + _loc1_ + 20;
      }
   }
}
