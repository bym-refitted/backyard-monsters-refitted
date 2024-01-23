package com.smartfoxserver.v2.requests
{
   import com.smartfoxserver.v2.SmartFox;
   import com.smartfoxserver.v2.entities.data.ISFSArray;
   import com.smartfoxserver.v2.entities.data.SFSArray;
   import com.smartfoxserver.v2.entities.variables.UserVariable;
   import com.smartfoxserver.v2.exceptions.SFSValidationError;
   
   public class SetUserVariablesRequest extends BaseRequest
   {
      
      public static const KEY_USER:String = "u";
      
      public static const KEY_VAR_LIST:String = "vl";
       
      
      private var _userVariables:Array;
      
      public function SetUserVariablesRequest(param1:Array)
      {
         super(BaseRequest.SetUserVariables);
         this._userVariables = param1;
      }
      
      override public function validate(param1:SmartFox) : void
      {
         var _loc2_:Array = [];
         if(this._userVariables == null || this._userVariables.length == 0)
         {
            _loc2_.push("No variables were specified");
         }
         if(_loc2_.length > 0)
         {
            throw new SFSValidationError("SetUserVariables request error",_loc2_);
         }
      }
      
      override public function execute(param1:SmartFox) : void
      {
         var _loc3_:UserVariable = null;
         var _loc2_:ISFSArray = SFSArray.newInstance();
         for each(_loc3_ in this._userVariables)
         {
            _loc2_.addSFSArray(_loc3_.toSFSArray());
         }
         _sfso.putSFSArray(KEY_VAR_LIST,_loc2_);
      }
   }
}
