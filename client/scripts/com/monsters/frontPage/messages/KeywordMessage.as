package com.monsters.frontPage.messages
{
   public class KeywordMessage extends Message
   {
      
      public static const PREFIX:String = "fp_";
       
      
      protected var _keyword:String;
      
      public function KeywordMessage(param1:String, param2:String = null, param3:String = null)
      {
         this._keyword = param1;
         var _loc4_:String = !!param3 ? param3 : PREFIX + param1 + ".jpg";
         super(PREFIX + this._keyword + "_title",PREFIX + this._keyword,_loc4_,param2,videoURL);
         name = this._keyword;
      }
      
      public static function getImageURLFromKeyword(param1:String) : String
      {
         return _IMAGE_DIRECTORY + PREFIX + param1 + ".jpg";
      }
   }
}
