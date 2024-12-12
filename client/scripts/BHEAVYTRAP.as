package
{
   import com.monsters.monsters.MonsterBase;
   import flash.events.*;
   import flash.geom.Point;
   
   public class BHEAVYTRAP extends BTRAP
   {
       
      
      public function BHEAVYTRAP()
      {
         super();
      }
      
      override public function FindTargets() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MonsterBase = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc7_:Array = Targeting.getCreepsInRange(_range,_position,Targeting.getOldStyleTargets(-1));
         _hasTargets = false;
         _targetCreeps = [];
         for(_loc3_ in _loc7_)
         {
            _loc1_ = _loc7_[_loc3_];
            _loc2_ = _loc1_.creep;
            _loc4_ = Number(_loc1_.dist);
            _loc5_ = _loc1_.pos;
            _loc8_ = _loc2_._creatureID.substr(0,1);
            _loc9_ = int(_loc2_._creatureID.substring(_loc2_._creatureID.indexOf("C") + 1));
            if(!(_loc8_ == "C" && (_loc9_ < 10 || _loc9_ > 12)))
            {
               if(!(_loc8_ == "I" && (_loc9_ < 7 || _loc9_ > 8)))
               {
                  _targetCreeps.push({
                     "creep":_loc2_,
                     "dist":_loc4_,
                     "position":_loc5_
                  });
                  _hasTargets = true;
                  return;
               }
            }
         }
      }
      
      override public function Explode() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MonsterBase = null;
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:Array = Targeting.getCreepsInRange(_size,new Point(_mc.x,_mc.y),Targeting.getOldStyleTargets(-1));
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         for(_loc3_ in _loc7_)
         {
            _loc1_ = _loc7_[_loc3_];
            _loc2_ = _loc1_.creep;
            if(_loc2_.health > 0)
            {
               _loc8_++;
               _loc4_ = Number(_loc1_.dist);
               _loc5_ = _loc1_.pos;
               _loc2_.modifyHealth(-(_buildingProps.damage[0].Get() / _buildingProps.size * (_buildingProps.size - _loc4_ * 0.5)));
               if(_loc2_.health <= 0)
               {
                  _loc9_++;
                  GIBLETS.Create(new Point(_mc.x,_mc.y + 3),0.8,75,2);
               }
            }
         }
         _loc7_ = Targeting.getCreepsInRange(_size,new Point(_mc.x,_mc.y),Targeting.getOldStyleTargets(2));
         for(_loc3_ in _loc7_)
         {
            _loc1_ = _loc7_[_loc3_];
            _loc2_ = _loc1_.creep;
            if(_loc2_.health > 0)
            {
               _loc8_++;
               _loc4_ = Number(_loc1_.dist);
               _loc5_ = _loc1_.pos;
               _loc2_.modifyHealth(-(_buildingProps.damage[0].Get() * 0.5 / _buildingProps.size * (_buildingProps.size - _loc4_ * 0.5)));
               if(_loc2_.health <= 0)
               {
                  _loc9_++;
                  GIBLETS.Create(new Point(_mc.x,_mc.y + 3),0.8,75,2);
               }
            }
         }
         if(_loc8_ > 0)
         {
            _fired = true;
            if(_loc9_ == _loc8_)
            {
               ATTACK.Log("htrap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapkilled",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc9_
               }) + "</font>");
            }
            else if(_loc9_ > 0)
            {
               ATTACK.Log("htrap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapdamagedkilled",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc8_,
                  "v3":_loc9_
               }) + "</font>");
            }
            else
            {
               ATTACK.Log("htrap" + _id,"<font color=\"#FF0000\">" + KEYS.Get("attack_log_trapdamaged",{
                  "v1":KEYS.Get(_buildingProps.name),
                  "v2":_loc8_
               }) + "</font>");
            }
            EFFECTS.Scorch(new Point(_mc.x,_mc.y + 5));
         }
         _hasTargets = false;
         _mc.visible = true;
         setHealth(0);
         SOUNDS.Play("trap");
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            RecycleC();
         }
      }
   }
}
