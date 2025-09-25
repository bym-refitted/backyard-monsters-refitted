package
{
   import flash.display.DisplayObject;
   import gs.TweenLite;
   import gs.easing.Quad;
   import flash.system.Capabilities;
   
   public class POPUPSETTINGS
   {
      
      private static const _BOTTOM_PADDING:int = 100;
       
      
      public function POPUPSETTINGS()
      {
         super();
      }
      
      public static function AlignToCenter(param1:DisplayObject) : void
      {
         param1.x = GLOBAL._SCREENCENTER.x;
         param1.y = GLOBAL._SCREENCENTER.y - _BOTTOM_PADDING;
         if(GAME._isSmallSize)
         {
            param1.y = GLOBAL._SCREENCENTER.y - _BOTTOM_PADDING / 2;
         }
      }
      
      public static function AlignToUpperLeft(param1:DisplayObject, param2:Boolean = false) : void
      {
         param1.x = GLOBAL._SCREENCENTER.x - param1.width * 0.5;
         param1.y = GLOBAL._SCREENCENTER.y - _BOTTOM_PADDING - param1.height * 0.5;
         if(param2)
         {
            param1.y = GLOBAL._SCREENCENTER.y - param1.height * 0.5;
         }
      }
      
      public static function ScaleUp(param1:DisplayObject) : void
      {
         if (Capabilities.playerType == "Desktop")
         {
            param1.scaleX = 1.8;
            param1.scaleY = 1.8;
         }
         else
         {
            param1.scaleX = 0.9;
            param1.scaleY = 0.9;
            TweenLite.to(param1,0.2,{
               "scaleX":1,
               "scaleY":1,
               "ease":Quad.easeOut
            });
         }
      }
      
      public static function ScaleUpFromTopLeft(param1:DisplayObject) : void
      {
         param1.scaleX = 0.9;
         param1.scaleY = 0.9;
         TweenLite.to(param1,0.2,{
            "transformAroundCenter":{"scale":1},
            "ease":Quad.easeOut
         });
      }
   }
}
