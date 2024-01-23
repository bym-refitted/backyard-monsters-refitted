package com.monsters.frontPage.messages.news
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class News02InfernoYardExpansion extends KeywordMessage
   {
       
      
      public function News02InfernoYardExpansion()
      {
         var _loc1_:String = null;
         if(!BASE.isInfernoMainYardOrOutpost && MAPROOM_DESCENT.DescentPassed)
         {
            _loc1_ = "btn_gotoinferno";
         }
         super("3_16_0",_loc1_);
      }
      
      override protected function onButtonClick() : void
      {
         POPUPS.Next();
         INFERNOPORTAL.ToggleYard();
      }
   }
}
