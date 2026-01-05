package
{
   import com.cc.utils.SecNum;
   import flash.geom.Rectangle;
   
   public class HatcheryBase extends BFOUNDATION
   {
       
      
      public var _finishCost:SecNum;
      
      public var _finishQueue:Object;
      
      public var _finishAll:Boolean = true;
      
      public function HatcheryBase()
      {
         this._finishQueue = {};
         super();
         _footprint = [new Rectangle(0,0,100,100)];
         _gridCost = [[new Rectangle(0,0,100,100),10],[new Rectangle(10,10,80,80),200]];
         _monsterQueue = [];
         this._finishCost = new SecNum(0);
      }
   }
}
