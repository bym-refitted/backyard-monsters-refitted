package
{
   import flash.geom.Rectangle;
   
   public class BUILDING117 extends BHEAVYTRAP
   {
       
      
      public function BUILDING117()
      {
         super();
         _type = 117;
         _footprint = [new Rectangle(0,0,20,20)];
         SetProps();
      }
      
      override public function Constructed() : void
      {
         var heavyTrapsConstructed:Number = ACHIEVEMENTS._stats["heavytraps"] as Number;
         ACHIEVEMENTS._stats["heavytraps"] = heavyTrapsConstructed + 1;
         ACHIEVEMENTS.Check();
         super.Constructed();
      }
   }
}
