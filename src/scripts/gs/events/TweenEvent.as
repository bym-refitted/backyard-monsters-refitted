package gs.events
{
   import flash.events.Event;
   
   public class TweenEvent extends Event
   {
      
      public static const version:Number = 0.9;
      
      public static const START:String = "start";
      
      public static const UPDATE:String = "update";
      
      public static const COMPLETE:String = "complete";
       
      
      public var info:Object;
      
      public function TweenEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.info = param2;
      }
      
      override public function clone() : Event
      {
         return new TweenEvent(this.type,this.info,this.bubbles,this.cancelable);
      }
   }
}
