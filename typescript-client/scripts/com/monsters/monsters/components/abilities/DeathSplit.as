package com.monsters.monsters.components.abilities
{
   import com.monsters.monsters.MonsterBase;
   import com.monsters.monsters.components.Component;
   import com.monsters.monsters.creeps.CreepBase;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class DeathSplit extends Component
   {
       
      
      private var _target:MonsterBase;
      
      private var _splitType:String;
      
      public function DeathSplit(param1:MonsterBase, param2:String)
      {
         super();
         this._target = param1;
         this._target.addEventListener(MonsterBase.k_DEATH_EVENT,this.split);
         this._splitType = param2;
      }
      
      protected function split(param1:Event = null) : void
      {
         var _loc5_:String = null;
         var _loc6_:MonsterBase = null;
         this._target.removeEventListener(MonsterBase.k_DEATH_EVENT,this.split);
         
         if(this._target._friendly && this._target._house)
         {
            return;
         }
         
         var _loc2_:int = CREATURES.GetProperty(this._target._creatureID,"splits",0,this._target._friendly);
         var _loc3_:Point = new Point(this._target._mc.x + Math.random() * 120 - 60,this._target._mc.y + Math.random() * 120 - 60);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc5_ = "bounce";
            if(this._target._behaviour == MonsterBase.k_sBHVR_DEFEND)
            {
               _loc5_ = "defend";
            }
            if(this._target._friendly)
            {
               (_loc6_ = CREATURES.Spawn(this._splitType,MAP._BUILDINGTOPS,_loc5_,_loc3_,Math.random() * 360)).isDisposable = true;
            }
            else
            {
               _loc6_ = CREEPS.Spawn(this._splitType,MAP._BUILDINGTOPS,_loc5_,_loc3_,Math.random() * 360,1,false,true);
            }
            _loc3_ = new Point(this._target._mc.x + Math.random() * 120 - 60,this._target._mc.y + Math.random() * 120 - 60);
            if(this._target._behaviour == MonsterBase.k_sBHVR_DEFEND)
            {
               (_loc6_ as CreepBase).changeModeDefend();
            }
            _loc4_++;
         }
      }
   }
}
