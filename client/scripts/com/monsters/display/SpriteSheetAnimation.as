package com.monsters.display
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class SpriteSheetAnimation extends Bitmap
   {
       
      
      public var totalFrames:int;
      
      public var currentFrame:int;
      
      public var currentRow:int;
      
      public var isPlaying:Boolean;
      
      public var doesRepeat:Boolean;
      
      public var spriteData:SpriteData;
      
      public function SpriteSheetAnimation(param1:SpriteData, param2:int)
      {
         this.spriteData = param1;
         this.totalFrames = param2;
         super(new BitmapData(param1.width,param1.height,true,0));
      }
      
      public function play() : void
      {
         this.isPlaying = true;
      }
      
      public function stop() : void
      {
         this.isPlaying = false;
      }
      
      public function gotoAndPlay(param1:int) : void
      {
         this.currentFrame = param1;
         this.isPlaying = true;
      }
      
      public function gotoAndStop(param1:int) : void
      {
         this.currentFrame = param1;
         this.isPlaying = false;
      }
      
      public function update() : void
      {
         if(this.isPlaying)
         {
            ++this.currentFrame;
            if(this.currentFrame > this.totalFrames)
            {
               this.animationComplete();
            }
         }
         this.render();
      }
      
      public function render() : void
      {
         SPRITES.GetFrame(bitmapData,this.spriteData,this.currentFrame % this.totalFrames,this.currentRow);
      }
      
      private function animationComplete() : void
      {
         if(this.doesRepeat)
         {
            this.currentFrame = 0;
         }
      }
   }
}
