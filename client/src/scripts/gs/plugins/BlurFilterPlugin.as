package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class BlurFilterPlugin extends FilterPlugin
   {
      
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
       
      
      public function BlurFilterPlugin()
      {
         super();
         this.propName = "blurFilter";
         this.overwriteProps = ["blurFilter"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = BlurFilter;
         initFilter(param2,new BlurFilter(0,0,int(param2.quality) || 2));
         return true;
      }
   }
}
