package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.match.MatchExpression;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class FindRoomsRequest extends BaseRequest
   {
      
      public static const KEY_EXPRESSION:String = "e";
      
      public static const KEY_GROUP:String = "g";
      
      public static const KEY_LIMIT:String = "l";
      
      public static const KEY_FILTERED_ROOMS:String = "fr";
       
      
      private var _matchExpr:MatchExpression;
      
      private var _groupId:String;
      
      private var _limit:int;
      
      public function FindRoomsRequest(param1:MatchExpression, param2:String = null, param3:int = 0)
      {
         super(BaseRequest.FindRooms);
         this._matchExpr = param1;
         this._groupId = param2;
         this._limit = param3;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._matchExpr == null)
         {
            _loc2_.push("Missing Match Expression");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("FindRooms request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         _sfso.putSFSArray(KEY_EXPRESSION,this._matchExpr.toSFSArray());
         if(this._groupId != null)
         {
            _sfso.putUtfString(KEY_GROUP,this._groupId);
         }
         if(this._limit > 0)
         {
            _sfso.putShort(KEY_LIMIT,this._limit);
         }
      }
   }
}
