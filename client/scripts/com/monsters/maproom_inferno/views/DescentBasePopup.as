package com.monsters.maproom_inferno.views
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import gs.TweenLite;
   import gs.easing.Elastic;
   
   public class DescentBasePopup extends DescentBasePopup_CLIP
   {
       
      
      public var maxDepth:int = 13; // Set this to 13, we are no longer using the ""new"" 7base
      // public var maxDepth:int = 7;
      
      public var _t:Timer;
      
      public var currLvl:int = 0;
      
      public var depthTxt:String;
      
      public var depthTxt2:String;
      
      public var depthFlip:Boolean = false;
      
      public function DescentBasePopup()
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
         /* We have to re-arrange the order of levels so the depth bar actually does something. */
         switch(this.currLvl)
         {
            case 9:
            case 10:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = KEYS.Get("descent_depthBarWarn1");
               break;
            case 11:
            case 12:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = KEYS.Get("descent_depthBarWarn2");
               break;
            case 13:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = KEYS.Get("descent_depthBarWarn3");
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            default:
               this.depthTxt = KEYS.Get("descent_depthBar");
               this.depthTxt2 = "";
         }
         var _loc2_:Number = 100 / this.maxDepth * param1;
         depthBar.mcBar.width = Math.max(_loc2_,1);
         this.DepthCheck();
      }

      // ----------- OLD IMPLEMENTATION ----------- //
      // Comment: March 2012 pre-patch 7 Descent base co-ordinates
      // public function setDepth(param1:int) : void
      // {
      //    this.currLvl = param1;
      //    switch(this.currLvl)
      //    {
      //       case 5:
      //          this.depthTxt = KEYS.Get("descent_depthBar");
      //          this.depthTxt2 = KEYS.Get("descent_depthBarWarn1");
      //          break;
      //       case 6:
      //          this.depthTxt = KEYS.Get("descent_depthBar");
      //          this.depthTxt2 = KEYS.Get("descent_depthBarWarn2");
      //          break;
      //       case 7:
      //          this.depthTxt = KEYS.Get("descent_depthBar");
      //          this.depthTxt2 = KEYS.Get("descent_depthBarWarn3");
      //          break;
      //       case 1:
      //       case 2:
      //       case 3:
      //       case 4:
      //       default:
      //          this.depthTxt = KEYS.Get("descent_depthBar");
      //          this.depthTxt2 = "";
      //    }
      //    var _loc2_:Number = 100 / this.maxDepth * param1;
      //    depthBar.mcBar.width = Math.max(_loc2_,1);
      //    this.DepthCheck();
      // }
      
      public function Show(param1:int = 0, param2:int = 0, param3:int = 0) : void
      {
         this.setDepth(param1);
         if(param2 != 0 || param3 != 0)
         {
            this.x = param2;
            this.y = param3;
         }
         var _loc4_:int = this.x;
         this.x -= 15;
         TweenLite.to(this,0.6,{
            "x":_loc4_,
            "ease":Elastic.easeOut
         });
         this._t = new Timer(1000);
         this._t.start();
         this._t.addEventListener(TimerEvent.TIMER,this.DepthCheck);
      }
      
      public function Hide() : void
      {
         this._t.stop();
         this._t.removeEventListener(TimerEvent.TIMER,this.DepthCheck);
         this._t = null;
      }
      
      public function DepthCheck(param1:TimerEvent = null) : void
      {
         this.depthFlip = !this.depthFlip;
         tDepth.htmlText = this.depthTxt;
         tDepth2.htmlText = this.depthTxt2;
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
   }
}
