package com.monsters.frontPage.messages.news
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class News01MagmaTower extends KeywordMessage
   {
       
      
      public function News01MagmaTower()
      {
         var _loc1_:String = "";
         if(GLOBAL.StatGet(BUILDING14.UNDERHALL_LEVEL) >= 1)
         {
            _loc1_ = "btn_buildnow";
         }
         super("3_14_0",_loc1_);
         imageURL = _IMAGE_DIRECTORY + PREFIX + "magmaabove.jpg";
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         return !GLOBAL._flags.viximo && !GLOBAL._flags.kongregate;
      }
      
      override protected function onButtonClick() : void
      {
         buyBuilding(INFERNO_MAGMA_TOWER.ID);
      }
   }
}
