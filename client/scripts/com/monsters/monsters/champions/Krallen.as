package com.monsters.monsters.champions
{
   import com.cc.utils.SecNum;
   import com.monsters.configs.BYMConfig;
   import com.monsters.interfaces.ILootable;
   import com.monsters.managers.InstanceManager;
   import com.monsters.pathing.PATHING;
   import com.monsters.rendering.RasterData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   public class Krallen extends ChampionBase
   {
      
      public static const MAX_POWERLEVEL:int = 2;
      
      public static const TYPE:uint = 5;
       
      
      public var _lootMults:Dictionary;
      
      public function Krallen(param1:String, param2:Point, param3:Number, param4:Point = null, param5:Boolean = false, param6:BFOUNDATION = null, param7:int = 1, param8:int = 0, param9:int = 0, param10:int = 1, param11:int = 20000, param12:int = 0, param13:int = 1)
      {
         var abilities:Array = null;
         var i:uint = 0;
         param13 = Math.min(param13,MAX_POWERLEVEL);
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13);
         abilities = CHAMPIONCAGE.GetGuardianProperties(_creatureID,"abilities");
         var powerLevel:Number = _powerLevel.Get();
         var numAbilities:uint = abilities.length;
         this._lootMults = new Dictionary();
         this._lootMults[BRESOURCE] = new SecNum(2);
         this._lootMults[BSTORAGE] = new SecNum(3);
         _buff = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_level.Get(),"buffs");
         while(i < numAbilities)
         {
            if(powerLevel < i)
            {
               break;
            }
            var abilityClass:Class = abilities[i] as Class;
            if(abilityClass)
            {
               addComponent(new abilityClass());
            }
            i++;
         }
      }
      
      override protected function setupSprite() : void
      {
         _frameNumber = Math.random() * 7;
         _spriteID = _creatureID + "_" + _powerLevel.Get();
         SPRITES.SetupSprite(_spriteID);
         var _loc1_:Object = SPRITES.GetSpriteDescriptor(_spriteID);
         _graphic = new BitmapData(_loc1_.width,_loc1_.height,true,16777215);
         _graphicMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_graphic) : graphic.addChild(new Bitmap(_graphic)) as Bitmap;
         _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_x");
         _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_y");
         if(BYMConfig.instance.RENDERER_ON)
         {
            _rasterData = new RasterData(_graphicMC,_rasterPt,int.MAX_VALUE);
         }
      }
      
      /*
       * The following changes have been made to this function
       * 
       * @autor: matiasbais
       * 
       * @changes: Renamed local registers to readable variables names and removed unused logic
       * Moved repeated logic about calculating the closest buildings to an auxiliary function (getClosestBuildings - in MonsterBase.as)
       * 
       * @param {int} targetGroup - specifies the targetting preference of the current monster, in this case it's not used
       *
      */
      override public function findTarget(targetGroup:int = 0) : void
      {    
         var targets:Array = [null,null];
         targets = getClosestBuildings(BASE._buildingsMain, function(b:BFOUNDATION):Boolean{
               return(b is ILootable && !b._looted)
            });
         if(targets[0]==null)
         {
            targets = getClosestBuildings(BASE._buildingsTowers, function(b:BFOUNDATION):Boolean{
               if(b._class == "tower")
                  {
                     if(!MONSTERBUNKER.isBunkerBuilding(b._type)){
                        if(!(b as BTOWER).isJard)
                        {
                           return true;
                        }
                     }
                  }
                  return false;
            });
         }
         if(targets[0]==null)
         {
            targets = getClosestBuildings(BASE._buildingsTowers, function(b:BFOUNDATION):Boolean{
               if(b._class == "tower")
                  {
                     if(MONSTERBUNKER.isBunkerBuilding(b._type)){
                        if((b._used > 0 || b._monstersDispatchedTotal > 0))
                        {
                           return true;   
                        }
                     }
                  }
                  return false;
            });
         }
         if(targets[0]==null)
         {
            targets = getClosestBuildings(BASE._buildingsMain, function(b:BFOUNDATION):Boolean{
               return(b is ILootable && b._looted)
            });
         }
         
         if(targets[0]==null)
         {
            targets = getClosestBuildings(BASE._buildingsMain, function(b:BFOUNDATION):Boolean{
               if(b._class != "decoration" && b._class != "immovable" && b._class != "enemy")
               {
                  if(b._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(b._type))
                  {
                     if((b as BTOWER).isJard)
                     {
                        return false;
                     }
                  }
                  return true;
               }
            });
         }
         if(targets[0]==null)
         {
            changeModeRetreat();
         }
         else if(!GLOBAL._catchup && targets[1]!=null)
         {
            WaypointTo(new Point(targets[0]._mc.x,targets[0]._mc.y),targets[0]);   
            WaypointTo(new Point(targets[1]._mc.x,targets[1]._mc.y),targets[1]);           
         }
         else
         {
            WaypointTo(new Point(targets[0]._mc.x,targets[0]._mc.y),targets[0]);     
         }
      }
      
      override public function clear() : void
      {
         this._lootMults = null;
         super.clear();
      }
   }
}
