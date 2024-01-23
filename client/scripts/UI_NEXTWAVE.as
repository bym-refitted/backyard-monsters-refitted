package
{
   import com.monsters.ui.UI_BOTTOM;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class UI_NEXTWAVE extends NEXTWAVEBAR_CLIP
   {
       
      
      private var _popupWaveInfo:bubblepopupDownBuff;
      
      public function UI_NEXTWAVE()
      {
         super();
      }
      
      public static function ShouldDisplay() : Boolean
      {
         if(GLOBAL.mode !== GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(!BASE.isMainYard)
         {
            return false;
         }
         if(TUTORIAL._stage < TUTORIAL._endstage)
         {
            return false;
         }
         if(!SPECIALEVENT.EventActive())
         {
            return false;
         }
         if(SPECIALEVENT.wave > SPECIALEVENT.numWaves)
         {
            return false;
         }
         if(SPECIALEVENT.active)
         {
            return false;
         }
         return true;
      }
      
      private static function OnBarClicked(param1:MouseEvent) : void
      {
         SPECIALEVENT.StartRound();
      }
      
      public function Setup() : void
      {
         SPECIALEVENT.Setup();
         mcHit.addEventListener(MouseEvent.CLICK,OnBarClicked);
         mcHit.addEventListener(MouseEvent.ROLL_OVER,this.WaveShow);
         mcHit.addEventListener(MouseEvent.ROLL_OUT,this.WaveHide);
         mcHit.buttonMode = true;
         mcHit.mouseChildren = false;
         this.SetWave(SPECIALEVENT.wave);
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
         if(SPECIALEVENT.wave >= SPECIALEVENT.EVENTEND)
         {
            return;
         }
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:* = _loc2_.name + "_desc";
         var _loc6_:String = "buff_duration";
         _loc3_ = String(SPECIALEVENT.WAVES_DESC[SPECIALEVENT.wave - 1]);
         _loc4_ = "";
         if(!this._popupWaveInfo)
         {
            _loc7_ = new bubblepopupDownBuff();
            this._popupWaveInfo = this.addChild(_loc7_) as bubblepopupDownBuff;
            _loc7_.Setup(_loc2_.x + _loc2_.width / 2,_loc2_.y + _loc2_.height + 4,_loc3_,_loc4_);
            _loc7_.x = 20;
            _loc7_.y = -20;
            _loc7_.mcArrow.x = 30;
         }
         else
         {
            bubblepopupDownBuff(this._popupWaveInfo).Update(_loc3_,_loc4_);
         }
      }
      
      public function WaveHide(param1:MouseEvent) : void
      {
         if(this._popupWaveInfo)
         {
            this.removeChild(this._popupWaveInfo);
            this._popupWaveInfo = null;
         }
      }
      
      public function SetWave(param1:int) : void
      {
         if(param1 > SPECIALEVENT.numWaves)
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
