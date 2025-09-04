package
{
   import com.monsters.display.ImageCache;
   import com.monsters.managers.InstanceManager;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   
   public class WMIROUNDCOMPLETE extends ROUNDCOMPLETEPOPUP_CLIP
   {
      
      private static var _open:Boolean = false;
      
      private static var _wave:Number;
       
      
      private var bm:Bitmap;
      
      public function WMIROUNDCOMPLETE(param1:int = -1, param2:Boolean = false)
      {
         var buildingInstances:Vector.<Object> = null;
         var bannerComplete:Function = null;
         var imageComplete:Function = null;
         var numDamagedBuildings:int = 0;
         var b:BFOUNDATION = null;
         var wave:int = param1;
         var surrendered:Boolean = param2;
         bannerComplete = function(param1:String, param2:BitmapData):void
         {
            var _loc3_:Bitmap = new Bitmap(param2);
            mcBanner.addChild(_loc3_);
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
         ImageCache.GetImageWithCallBack(SPECIALEVENT.BANNERIMAGE,bannerComplete);
         if(wave == -1)
         {
            ImageCache.GetImageWithCallBack(GetImageName(SPECIALEVENT.wave,false),imageComplete);
         }
         else
         {
            ImageCache.GetImageWithCallBack(GetImageName(wave,true),imageComplete);
         }
         mcFrame.Setup(wave != 1);
         if(SPECIALEVENT.isMajorWave(wave))
         {
            mcTitle.htmlText = KEYS.Get("wmi_winwavetitle");
            mcText.htmlText = KEYS.Get("wmi_winwave" + wave);
            if(wave == SPECIALEVENT.BONUSWAVE)
            {
               mcStats.htmlText = KEYS.Get("wmi_completedwave31");
            }
            else if(wave == SPECIALEVENT.BONUSWAVE2)
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
               BTOTEM.TotemReward();
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
               mcTitle.htmlText = KEYS.Get("wmi2_surrendertitle");
               mcText.htmlText = KEYS.Get("wmi2_surrender");
            }
            else
            {
               mcTitle.htmlText = KEYS.Get("wmi_losewavetitle");
               mcText.htmlText = KEYS.Get("wmi2_losewave");
            }
            mcStats.htmlText = "";
            numDamagedBuildings = 0;
            buildingInstances = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(b in buildingInstances)
            {
               if(b.health < b.maxHealth)
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
         else if(wave == SPECIALEVENT.EVENTEND)
         {
            mcTitle.htmlText = "";
            mcText.htmlText = KEYS.Get("wmi2_eventover");
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
            buildingInstances = InstanceManager.getInstancesByClass(BFOUNDATION);
            for each(b in buildingInstances)
            {
               if(b.health < b.maxHealth)
               {
                  numDamagedBuildings++;
               }
            }
            if(numDamagedBuildings == 0)
            {
               if(SPECIALEVENT.GetTimeUntilEnd() < 0)
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
               if(SPECIALEVENT.GetTimeUntilEnd() < 0)
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
      
      private static function Brag(param1:MouseEvent) : void
      {
         switch(_wave)
         {
            case 1:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave1streamtitle"),KEYS.Get("wmi2_wave1streamdesc"),"wmitotemfeed2_1.png"]);
               break;
            case 10:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave10streamtitle"),KEYS.Get("wmi2_wave10streamdesc"),"wmitotemfeed2_2.png"]);
               break;
            case 20:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave20streamtitle"),KEYS.Get("wmi2_wave20streamdesc"),"wmitotemfeed2_3.png"]);
               break;
            case 30:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave30streamtitle"),KEYS.Get("wmi2_wave30streamdesc"),"wmitotemfeed2_4.png"]);
               break;
            case 31:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave31streamtitle"),KEYS.Get("wmi2_wave31streamdesc"),"wmitotemfeed2_5.png"]);
               break;
            case 32:
               GLOBAL.CallJS("sendFeed",["wmi2totem-construct",KEYS.Get("wmi2_wave32streamtitle"),KEYS.Get("wmi2_wave32streamdesc"),"wmitotemfeed2_6.png"]);
               break;
            case 33:
               GLOBAL.CallJS("sendFeed",["wmi2-eventover",KEYS.Get("wmi2_eventoverstreamtitle"),KEYS.Get("wmi2_eventoverstreamdesc",{"v1":SPECIALEVENT.GetStat("wmi_wave")}),"wmi2_aftermath.v2.png"]);
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
                  return "popups/building-wmi2totem1.png";
               case 10:
                  return "popups/building-wmi2totem2.png";
               case 20:
                  return "popups/building-wmi2totem3.png";
               case 30:
                  return "popups/building-wmi2totem4.png";
               case 31:
                  return "popups/building-wmi2totem5.png";
               case 32:
                  return "popups/building-wmi2totem6.png";
               case 33:
                  return "popups/wmi2eventend.jpg";
               default:
                  if(param1 < 10)
                  {
                     return "specialevent/wmi2_1.jpg";
                  }
                  if(param1 < 20)
                  {
                     return "specialevent/wmi2_2.jpg";
                  }
                  return "specialevent/wmi2_3.jpg";
            }
         }
         else
         {
            if(param1 < 10)
            {
               return "specialevent/wmi2_1.jpg";
            }
            if(param1 < 20)
            {
               return "specialevent/wmi2_2.jpg";
            }
            return "specialevent/wmi2_3.jpg";
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
         SPECIALEVENT.StartRound();
         this.Hide();
      }
      
      private function StartRepairsClicked(param1:MouseEvent) : void
      {
         var _loc3_:BFOUNDATION = null;
         var _loc2_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.health < _loc3_.maxHealth && _loc3_._repairing == 0)
            {
               _loc3_.Repair();
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
         BTOTEM.TotemPlace();
         this.Hide();
      }
   }
}
