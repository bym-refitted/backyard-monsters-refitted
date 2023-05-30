package com.monsters.effects.fire
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class Fire extends Sprite
   {
      
      private static var flames:Array = [];
      
      private static var flame:com.monsters.effects.fire.Flame;
      
      private static var phase:int;
      
      private static var _frameNumber:int = 0;
       
      
      private var monster:Sprite;
      
      private var monsterBmp:Bitmap;
      
      private var count:int;
      
      private var countMax:int;
      
      public function Fire()
      {
         super();
      }
      
      public static function Add(param1:DisplayObject, param2:Bitmap, param3:Point) : void
      {
         if(flames.length < 5)
         {
            flame = (param1 as MovieClip).addChild(new com.monsters.effects.fire.Flame(param1,param2.width + 20,param2.height + 60)) as com.monsters.effects.fire.Flame;
            flame.emitter = param2;
            flame.enhance = 5;
            flame.cooling = 5;
            flame.x = param3.x;
            flame.y = param3.y + 2;
            flames.push(flame);
         }
      }
      
      public static function Remove(param1:int) : void
      {
         flames[param1].Clear();
         flames.splice(param1,1);
      }
      
      public static function Tick() : void
      {
         var _loc1_:int = 0;
         if(++_frameNumber % 2 == 0)
         {
            _loc1_ = 0;
            while(_loc1_ < flames.length)
            {
               flame = flames[_loc1_];
               flame.Tick();
               if(flame.phase == 0)
               {
                  flame.cooling -= 0.2;
                  if(flame.cooling < 0.8)
                  {
                     flame.phase = 1;
                  }
               }
               else if(flame.phase > 0)
               {
                  flame.phase += 1;
                  if(flame.phase > 200)
                  {
                     flame.cooling += 0.02;
                     if(flame.cooling > 5)
                     {
                        Remove(_loc1_);
                        _loc1_--;
                     }
                  }
               }
               _loc1_++;
            }
         }
      }
      
      public static function Clear() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < flames.length)
         {
            Remove(_loc1_);
            _loc1_--;
            _loc1_++;
         }
         flames = [];
      }
   }
}
