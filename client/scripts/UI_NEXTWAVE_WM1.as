package
{
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
    /*
   * This is the original UI_NEXTWAVE.as class for Wild Monster Invasion 1.
   * The original developers rewrote this class when Wild Monster Invasion 2 was released
   * instead of creating a new class.
   * 
   * This file archives the original implementation for reference and renamed to UI_NEXTWAVE_WM1.
   */
   public class UI_NEXTWAVE_WM1 extends NEXTWAVEBAR_CLIP
   {
      
      private var _popupWaveInfo:*;
      
      public function UI_NEXTWAVE_WM1()
      {
         super();
      }
      
      public static function ShouldDisplay() : Boolean
      {
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(BASE.isOutpost || BASE.isInfernoMainYardOrOutpost)
         {
            return false;
         }
         if (GLOBAL._flags.invasionpop != 4 && GLOBAL._flags.invasionpop != 5) 
         {
            return false;
         }
         if(TUTORIAL._stage < TUTORIAL._endstage)
         {
            return false;
         }
         if(SPECIALEVENT_WM1.GetTimeUntilEnd() < 0)
         {
            return false;
         }
         if(SPECIALEVENT_WM1.wave > SPECIALEVENT_WM1.numWaves)
         {
            return false;
         }
         if(SPECIALEVENT_WM1.active)
         {
            return false;
         }
         return true;
      }
      
      private static function OnBarClicked(param1:MouseEvent) : void
      {
         SPECIALEVENT_WM1.StartRound();
      }
      
      public function Setup() : void
      {
         SPECIALEVENT_WM1.Setup();
         mcHit.addEventListener(MouseEvent.CLICK,OnBarClicked);
         mcHit.addEventListener(MouseEvent.ROLL_OVER,this.WaveShow);
         mcHit.addEventListener(MouseEvent.ROLL_OUT,this.WaveHide);
         mcHit.buttonMode = true;
         mcHit.mouseChildren = false;
         this.SetWave(SPECIALEVENT_WM1.wave);
         this.Resize();
      }
      
      public function Resize() : void
      {
         if(UI_BOTTOM._mc)
         {
            x = UI_BOTTOM._mc.x + UI_BOTTOM._mc.width - mcHit.width;
            y = UI_BOTTOM._mc.y - mcHit.height;
         }
      }
      
      public function WaveShow(param1:MouseEvent) : void
      {
         var _loc7_:bubblepopupDownBuff = null;
         if(SPECIALEVENT_WM1.wave >= SPECIALEVENT_WM1.BONUSWAVE2)
         {
            return;
         }
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:* = _loc2_.name + "_desc";
         _loc3_ = SPECIALEVENT_WM1.WAVES_DESC[SPECIALEVENT_WM1.wave - 1];
         _loc4_ = "";
         if(!this._popupWaveInfo)
         {
            _loc7_ = new bubblepopupDownBuff();
            this._popupWaveInfo = this.addChild(_loc7_);
            _loc7_.Setup(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height + 4,_loc3_,_loc4_);
            _loc7_.x = 20;
            _loc7_.y = -20;
            if(SPECIALEVENT_WM1.wave == 25)
            {
               _loc7_.mcBG.height += 55;
               _loc7_.mcArrow.y += 55;
               _loc7_.y -= 45;
            }
            _loc7_.mcArrow.x = 30;
         }
         else
         {
            bubblepopupDownBuff(this._popupWaveInfo).Update(_loc3_,_loc4_);
         }
      }
      
      public function WaveHide(param1:MouseEvent) : *
      {
         if(this._popupWaveInfo)
         {
            this.removeChild(this._popupWaveInfo);
            this._popupWaveInfo = null;
         }
      }
      
      public function SetWave(param1:int) : void
      {
         if(param1 > SPECIALEVENT_WM1.numWaves)
         {
            this.visible = false;
            return;
         }
         if(this.visible == false && ShouldDisplay())
         {
            this.visible = true;
         }
         if(param1 == 31)
         {
            tR.htmlText = KEYS.Get("wmi_bonuswave");
         }
         else if(param1 == 32)
         {
            tR.htmlText = KEYS.Get("wmi_bonuswave2");
         }
         else
         {
            tR.htmlText = KEYS.Get("wmi_nextwave",{"v1":param1});
         }
      }
   }
}

