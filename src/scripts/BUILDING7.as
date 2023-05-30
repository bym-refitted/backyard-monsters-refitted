package
{
   import flash.geom.Rectangle;
   
   public class BUILDING7 extends BMUSHROOM
   {
       
      
      public function BUILDING7()
      {
         super();
         _type = 7;
         _footprint = [new Rectangle(0,0,30,30)];
         _gridCost = [[new Rectangle(0,0,30,30),10]];
         SetProps();
      }
   }
}
