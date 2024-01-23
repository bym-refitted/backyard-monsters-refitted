package com.monsters.frontPage.messages.underusedFeatures
{
   import com.monsters.frontPage.messages.KeywordMessage;
   
   public class Underused01MonsterLocker extends KeywordMessage
   {
       
      
      private var _creatureID:String;
      
      public function Underused01MonsterLocker()
      {
         super("idlelocker","btn_open");
         body = KEYS.Get(PREFIX + "idlelocker",{"v1":this.getNextUnlockableCreatureName()});
         imageURL = _IMAGE_DIRECTORY + PREFIX + "locker.jpg";
      }
      
      override public function get areRequirementsMet() : Boolean
      {
         body = KEYS.Get(PREFIX + "idlelocker",{"v1":this.getNextUnlockableCreatureName()});
         return GLOBAL._bLocker && !CREATURELOCKER._unlocking && GLOBAL.Timestamp() - GLOBAL.StatGet("CM3") > 60 * 60 * 24 * 5 && Boolean(this.getNextUnlockableCreatureName());
      }
      
      override protected function onView() : void
      {
         GLOBAL.StatSet("CM3",GLOBAL.Timestamp());
      }
      
      override protected function onButtonClick() : void
      {
         var _loc1_:String = this.getNextUnlockableCreatureName();
         CREATURELOCKER._popupCreatureID = this._creatureID;
         CREATURELOCKER.Show();
         CREATURELOCKER._mc.ShowB(this._creatureID);
         POPUPS.Next();
      }
      
      private function getNextUnlockableCreatureName() : String
      {
         var _loc3_:String = null;
         if(!GLOBAL._bLocker)
         {
            return null;
         }
         var _loc1_:Object = CREATURELOCKER.GetAppropriateCreatures();
         var _loc2_:Number = GLOBAL._bLocker._lvl.Get();
         for(_loc3_ in _loc1_)
         {
            if(!CREATURELOCKER._lockerData[_loc3_] && !CREATURELOCKER._creatures[_loc3_].blocked && _loc2_ >= _loc1_[_loc3_].page)
            {
               this._creatureID = _loc3_;
               return KEYS.Get(_loc1_[_loc3_].name);
            }
         }
         return null;
      }
   }
}
