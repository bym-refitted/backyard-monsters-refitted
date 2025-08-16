package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
      /*
   * This is the original WMIROUNDCOMPLETE.as class for Wild Monster Invasion 1.
   * The original developers rewrote this class when Wild Monster Invasion 2 was released
   * instead of creating a new class.
   * 
   * This file archives the original implementation for reference and renamed to WMIROUNDCOMPLETE_WM1.
   */
   public class WMIROUNDCOMPLETE_WM1 extends ROUNDCOMPLETEPOPUP_CLIP
   {
      
      private static var _wave:Number;
      
      private static var _open:Boolean = false;
      
      private var bm:Bitmap;
      
      public function WMIROUNDCOMPLETE_WM1(param1:int = -1, param2:Boolean = false)
      {
         var bannerComplete:Function = null;
         var imageComplete:Function = null;
         var numDamagedBuildings:int = 0;
         var b:* = undefined;
         var wave:int = param1;
         var surrendered:Boolean = param2;
         bannerComplete = function(param1:String, param2:BitmapData):*
         {
            bm = new Bitmap(param2);
            mcBanner.addChild(bm);
            mcBanner.width = 672;
            mcBanner.height = 82;
         };
         imageComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            _loc3_.smoothing = true;
            mcImage.addChild(_loc3_);
            mcImage.width = 200;
            mcImage.height = 200;
         };
         super();
         _wave = wave;
         ImageCache.GetImageWithCallBack("specialevent/monsterinvasionbannerred.jpg",bannerComplete);
         if(wave == -1)
         {
            ImageCache.GetImageWithCallBack(GetImageName(SPECIALEVENT_WM1.wave,false),imageComplete);
         }
         else
         {
            ImageCache.GetImageWithCallBack(GetImageName(wave,true),imageComplete);
         }
         mcFrame.Setup(wave != 1);
         if(isMajorWave(wave))
         {
            mcTitle.htmlText = KEYS.Get("wmi_winwavetitle");
            mcText.htmlText = KEYS.Get("wmi_winwave" + wave);
            if(wave == SPECIALEVENT_WM1.BONUSWAVE)
            {
               mcStats.htmlText = KEYS.Get("wmi_completedwave31");
            }
            else if(wave == SPECIALEVENT_WM1.BONUSWAVE2)
            {
               mcStats.htmlText = KEYS.Get("wmi_completedwave32");
            }
            else
            {
               mcStats.htmlText = KEYS.Get("wmi_completedwaves",{"v1":wave});
            }
            rBtn.Highlight = true;
            if(wave == 1)
            {
               SPECIALEVENT_WM1.TotemReward();
               this.ButtonsVisible(false,false,true,false);
               rBtn.SetupKey("wmi_placetotembtn");
               rBtn.addEventListener(MouseEvent.CLICK,this.PlaceTotem);
            }
            else
            {
               this.ButtonsVisible(false,false,false,true);
               bragBtn.SetupKey("btn_brag");
               bragBtn.Highlight = true;
               bragBtn.addEventListener(MouseEvent.CLICK,Brag);
            }
            lBtn.visible = false;
         }
         else if(wave == -1)
         {
            if(surrendered)
            {
               mcTitle.htmlText = KEYS.Get("wmi_surrendertitle");
               mcText.htmlText = KEYS.Get("wmi_surrender");
            }
            else
            {
               mcTitle.htmlText = KEYS.Get("wmi_losewavetitle");
               mcText.htmlText = KEYS.Get("wmi_losewave");
            }
            mcStats.htmlText = "";
            numDamagedBuildings = 0;
            for each(b in BASE._buildingsAll)
            {
               if(b._hp.Get() < b._hpMax.Get())
               {
                  numDamagedBuildings++;
               }
            }
            if(numDamagedBuildings > 0)
            {
               this.ButtonsVisible(false,true,true,false);
               mBtn.SetupKey("btn_startrepairs");
               mBtn.addEventListener(MouseEvent.CLICK,this.StartRepairsClicked);
               rBtn.SetupKey("btn_repairall");
               rBtn.Highlight = true;
               rBtn.addEventListener(MouseEvent.CLICK,this.RepairAllClicked);
            }
            else
            {
               this.ButtonsVisible(false,false,false,false);
            }
         }
         else if(wave == SPECIALEVENT_WM1.EVENTEND)
         {
            mcTitle.htmlText = "";
            mcText.htmlText = KEYS.Get("wmi_eventover");
            mcStats.htmlText = "";
            this.ButtonsVisible(false,false,false,true);
            bragBtn.SetupKey("btn_brag");
            bragBtn.Highlight = true;
            bragBtn.addEventListener(MouseEvent.CLICK,Brag);
         }
         else
         {
            mcTitle.htmlText = KEYS.Get("wmi_winwavetitle");
            mcText.htmlText = KEYS.Get("wmi_winwave");
            mcStats.htmlText = KEYS.Get("wmi_completedwaves",{"v1":wave});
            numDamagedBuildings = 0;
            for each(b in BASE._buildingsAll)
            {
               if(b._hp.Get() < b._hpMax.Get())
               {
                  numDamagedBuildings++;
               }
            }
            if(numDamagedBuildings == 0)
            {
               if(SPECIALEVENT_WM1.GetTimeUntilEnd() < 0)
               {
                  this.ButtonsVisible(false,false,false,false);
               }
               else
               {
                  this.ButtonsVisible(false,false,true,false);
                  rBtn.SetupKey("wmi_nextwavebtn");
                  rBtn.addEventListener(MouseEvent.CLICK,this.NextWaveClicked);
               }
            }
            else
            {
               if(SPECIALEVENT_WM1.GetTimeUntilEnd() < 0)
               {
                  this.ButtonsVisible(false,true,true,false);
               }
               else
               {
                  this.ButtonsVisible(true,true,true,false);
                  lBtn.SetupKey("wmi_nextwavebtn");
                  lBtn.addEventListener(MouseEvent.CLICK,this.NextWaveClicked);
               }
               mBtn.SetupKey("btn_startrepairs");
               mBtn.addEventListener(MouseEvent.CLICK,this.StartRepairsClicked);
               rBtn.SetupKey("btn_repairall");
               rBtn.Highlight = true;
               rBtn.addEventListener(MouseEvent.CLICK,this.RepairAllClicked);
            }
         }
         _open = true;
      }
      
      public static function get open() : Boolean
      {
         return _open;
      }
      
      private static function isMajorWave(param1:int) : Boolean
      {
         switch(param1)
         {
            case 1:
            case 10:
            case 20:
            case 30:
            case 31:
            case 32:
               return true;
            default:
               return false;
         }
      }
      
      private static function Brag(param1:MouseEvent) : void
      {
         switch(_wave)
         {
            case 1:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave1streamtitle"),KEYS.Get("wmi_wave1streamdesc"),"wmitotemfeed1.png"]);
               break;
            case 10:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave10streamtitle"),KEYS.Get("wmi_wave10streamdesc"),"wmitotemfeed2.png"]);
               break;
            case 20:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave20streamtitle"),KEYS.Get("wmi_wave20streamdesc"),"wmitotemfeed3.png"]);
               break;
            case 30:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave30streamtitle"),KEYS.Get("wmi_wave30streamdesc"),"wmitotemfeed4.png"]);
               break;
            case 31:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave31streamtitle"),KEYS.Get("wmi_wave31streamdesc"),"wmitotemfeed5.png"]);
               break;
            case 32:
               GLOBAL.CallJS("sendFeed",["wmitotem-construct",KEYS.Get("wmi_wave32streamtitle"),KEYS.Get("wmi_wave32streamdesc"),"wmitotemfeed6.png"]);
               break;
            case 33:
               GLOBAL.CallJS("sendFeed",["wmi-eventover",KEYS.Get("wmi_eventoverstreamtitle"),KEYS.Get("wmi_eventoverstreamdesc",{"v1":GLOBAL.StatGet("wmi_wave")}),"wmi_aftermath.png"]);
         }
         POPUPS.Next();
      }
      
      private static function GetImageName(param1:int, param2:Boolean) : String
      {
         if(param2)
         {
            switch(param1)
            {
               case 1:
                  return "popups/building-wmitotem1.png";
               case 10:
                  return "popups/building-wmitotem2.png";
               case 20:
                  return "popups/building-wmitotem3.png";
               case 30:
                  return "popups/building-wmitotem4.png";
               case 31:
                  return "popups/building-wmitotem5.png";
               case 32:
                  return "popups/building-wmitotem6.png";
               case 33:
                  return "popups/wmieventend.png";
               default:
                  if(param1 < 10)
                  {
                     return "specialevent/200x200_1.jpg";
                  }
                  if(param1 < 20)
                  {
                     return "specialevent/200x200_2.jpg";
                  }
                  return "specialevent/200x200_3.jpg";
            }
         }
         else
         {
            if(param1 < 10)
            {
               return "specialevent/200x200_1.jpg";
            }
            if(param1 < 20)
            {
               return "specialevent/200x200_2.jpg";
            }
            return "specialevent/200x200_3.jpg";
         }
      }
      
      public function Hide() : void
      {
         _open = false;
         POPUPS.Next();
      }
      
      private function ButtonsVisible(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean) : void
      {
         lBtn.visible = param1;
         mBtn.visible = param2;
         rBtn.visible = param3;
         bragBtn.visible = param4;
      }
      
      private function PlaceholderButtonClicked(param1:MouseEvent) : void
      {
         this.Hide();
      }
      
      private function NextWaveClicked(param1:MouseEvent) : void
      {
         SPECIALEVENT_WM1.StartRound();
         this.Hide();
      }
      
      private function StartRepairsClicked(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in BASE._buildingsAll)
         {
            if(_loc2_._hp.Get() < _loc2_._hpMax.Get() && _loc2_._repairing == 0)
            {
               _loc2_.Repair();
            }
         }
         SOUNDS.Play("repair1",0.25);
         this.Hide();
      }
      
      private function RepairAllClicked(param1:MouseEvent) : void
      {
         STORE.ShowB(3,1,["FIX"],true);
         this.Hide();
      }
      
      private function PlaceTotem(param1:MouseEvent) : void
      {
         SPECIALEVENT_WM1.TotemPlace();
         this.Hide();
      }
   }
}

