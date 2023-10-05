package com.cc.screenshot
{
   import com.adobe.images.JPGEncoder;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   
   public class screenshot_ui extends screenshot_ui_CLIP
   {
       
      
      private var brightness:int = 0;
      
      private var contrast:int = 0;
      
      private var saturation:int = 0;
      
      private var tilt:int = 0;
      
      private var grain:int = 0;
      
      private var border:int = 0;
      
      private var dragPoint:Point;
      
      private var offsetPoint:Point;
      
      private var presets:Array;
      
      public function screenshot_ui()
      {
         this.offsetPoint = new Point(-20,-20);
         this.presets = [["Normal",0,0,0,0,0,0],["B&W",10,10,-100,0,0,1],["B&W 2",0,40,-100,0,0,1],["Toy",0,0,10,60,0,2],["Toy 2",10,30,20,60,0,2],["Old",10,40,-30,10,1,3]];
         super();
         mcImage.addEventListener(MouseEvent.MOUSE_DOWN,this.DragStart);
         mcImage.addEventListener(MouseEvent.MOUSE_UP,this.DragStop);
         bBrightnessDown.Setup("-");
         bBrightnessDown.addEventListener(MouseEvent.CLICK,this.BrightnessDown);
         bBrightnessUp.Setup("+");
         bBrightnessUp.addEventListener(MouseEvent.CLICK,this.BrightnessUp);
         bContrastDown.Setup("-");
         bContrastDown.addEventListener(MouseEvent.CLICK,this.ContrastDown);
         bContrastUp.Setup("+");
         bContrastUp.addEventListener(MouseEvent.CLICK,this.ContrastUp);
         bSaturationDown.Setup("-");
         bSaturationDown.addEventListener(MouseEvent.CLICK,this.SaturationDown);
         bSaturationUp.Setup("+");
         bSaturationUp.addEventListener(MouseEvent.CLICK,this.SaturationUp);
         bTiltDown.Setup("-");
         bTiltDown.addEventListener(MouseEvent.CLICK,this.TiltDown);
         bTiltUp.Setup("+");
         bTiltUp.addEventListener(MouseEvent.CLICK,this.TiltUp);
         bGrainDown.Setup("-");
         bGrainDown.addEventListener(MouseEvent.CLICK,this.GrainDown);
         bGrainUp.Setup("+");
         bGrainUp.addEventListener(MouseEvent.CLICK,this.GrainUp);
         bSave1.SetupKey("btn_savetoalbum");
         bSave1.Enabled = false;
         bSave2.SetupKey("btn_posttowall");
         bSave2.Enabled = false;
         bSave3.SetupKey("btn_downloadimage");
         bSave3.addEventListener(MouseEvent.CLICK,this.Save);
         var _loc1_:int = 0;
         while(_loc1_ < this.presets.length)
         {
            this["bPreset" + (_loc1_ + 1)].Setup(this.presets[_loc1_][0]);
            this["bPreset" + (_loc1_ + 1)].addEventListener(MouseEvent.CLICK,this.LoadPreset(_loc1_));
            _loc1_++;
         }
         this.Update();
      }
      
      private function LoadPreset(param1:int) : Function
      {
         var n:int = param1;
         return function(param1:MouseEvent = null):void
         {
            brightness = presets[n][1];
            contrast = presets[n][2];
            saturation = presets[n][3];
            tilt = presets[n][4];
            grain = presets[n][5];
            border = presets[n][6];
            Update();
         };
      }
      
      private function DragStart(param1:MouseEvent = null) : void
      {
         this.dragPoint = new Point(mouseX,mouseY);
         addEventListener(MouseEvent.MOUSE_MOVE,this.Dragging);
      }
      
      private function DragStop(param1:MouseEvent = null) : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.Dragging);
         this.offsetPoint.x += mouseX - this.dragPoint.x;
         this.offsetPoint.y += mouseY - this.dragPoint.y;
         this.Update();
      }
      
      private function Dragging(param1:MouseEvent = null) : void
      {
         screenshot.Take(mouseX - this.dragPoint.x + this.offsetPoint.x,mouseY - this.dragPoint.y + this.offsetPoint.y);
         this.Update();
         mcImage.removeChildAt(0);
         mcImage.addChild(new Bitmap(screenshot._processedImage));
      }
      
      private function Update() : void
      {
         tBrightness.htmlText = "<b>" + (100 + this.brightness) + "%";
         tContrast.htmlText = "<b>" + (100 + this.contrast) + "%";
         tSaturation.htmlText = "<b>" + (100 + this.saturation) + "%";
         tTilt.htmlText = this.tilt == 0 ? "<b>OFF" : "<b>ON " + this.tilt + "%";
         tGrain.htmlText = this.grain == 0 ? "<b>OFF" : (this.grain == 1 ? "<b>LOW" : "<b>HIGH");
         screenshot.Process(this.brightness,this.contrast,this.saturation,this.tilt,this.grain,this.border);
         mcImage.removeChildAt(0);
         mcImage.addChild(new Bitmap(screenshot._processedImage));
         mcImage.width = 550;
         mcImage.height = 360;
      }
      
      private function Save(param1:MouseEvent = null) : void
      {
         var _loc2_:JPGEncoder = new JPGEncoder(80);
         var _loc3_:ByteArray = _loc2_.encode(screenshot._processedImage);
         var _loc4_:FileReference;
         (_loc4_ = new FileReference()).save(_loc3_,"BackyardMonsters.jpg");
      }
      
      private function BrightnessDown(param1:MouseEvent) : void
      {
         if(this.brightness > -100)
         {
            this.brightness -= 10;
         }
         this.Update();
      }
      
      private function BrightnessUp(param1:MouseEvent) : void
      {
         if(this.brightness < 100)
         {
            this.brightness += 10;
         }
         this.Update();
      }
      
      private function ContrastDown(param1:MouseEvent) : void
      {
         if(this.contrast > -100)
         {
            this.contrast -= 10;
         }
         this.Update();
      }
      
      private function ContrastUp(param1:MouseEvent) : void
      {
         if(this.contrast < 100)
         {
            this.contrast += 10;
         }
         this.Update();
      }
      
      private function SaturationDown(param1:MouseEvent) : void
      {
         if(this.saturation > -100)
         {
            this.saturation -= 10;
         }
         this.Update();
      }
      
      private function SaturationUp(param1:MouseEvent) : void
      {
         if(this.saturation < 100)
         {
            this.saturation += 10;
         }
         this.Update();
      }
      
      private function TiltUp(param1:MouseEvent) : void
      {
         if(this.tilt < 100)
         {
            this.tilt += 10;
         }
         this.Update();
      }
      
      private function TiltDown(param1:MouseEvent) : void
      {
         if(this.tilt > 0)
         {
            this.tilt -= 10;
         }
         this.Update();
      }
      
      private function GrainDown(param1:MouseEvent) : void
      {
         if(this.grain > 0)
         {
            --this.grain;
         }
         this.Update();
      }
      
      private function GrainUp(param1:MouseEvent) : void
      {
         if(this.grain < 2)
         {
            this.grain += 1;
         }
         this.Update();
      }
   }
}
