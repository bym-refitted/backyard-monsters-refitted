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
      
      override public function findTarget(param1:int = 0) : void
      {    
         var targetDistance:Number = Number.MAX_VALUE;
         var currentBuilding:BFOUNDATION = null;
         var ownPosition:Point = null;
         var buildingPosition:Point = null;
         var distance:int = 0;
         var lootedBuildingKey:String = null;
         var targetFound:Boolean = false;
         var buildings:Object = InstanceManager.getInstancesByClass(BFOUNDATION);
         var defensiveBuildings:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         var bunkers:Vector.<Object> = InstanceManager.getInstancesByClass(Bunker);
         var target:BFOUNDATION = null;
         var lootedBuildings:Dictionary = new Dictionary();
         _looking = true;
         ownPosition = PATHING.FromISO(_tmpPoint);
         for each(currentBuilding in buildings)
         {
            if(currentBuilding.health > 0 && currentBuilding is ILootable)
            {
               if(!currentBuilding._looted)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  targetFound = true;
               }
               else
               {
                  lootedBuildings[currentBuilding] = true;
               }
            }
         }
         if(!targetFound)
         {
            for each(currentBuilding in defensiveBuildings)
            {
               if(currentBuilding.health > 0 && !(currentBuilding as BTOWER).isJard)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  targetFound = true;
               }
            }
         }
         if(!targetFound)
         {
            for each(currentBuilding in bunkers)
            {
               if(currentBuilding.health > 0 && (currentBuilding._used > 0 || currentBuilding._monstersDispatchedTotal > 0))
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  targetFound = true;
               }
            }
         }
         if(!targetFound)
         {
            for(lootedBuildingKey in lootedBuildings)
            {
               if(currentBuilding = lootedBuildings[lootedBuildingKey] as BFOUNDATION)
               {
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  targetFound = true;
               }
            }
         }
         if(!targetFound)
         {
            for each(currentBuilding in BASE._buildingsMain)
            {
               if(currentBuilding._class != "decoration" && currentBuilding._class != "immovable" && currentBuilding.health > 0 && currentBuilding._class != "enemy")
               {
                  if(currentBuilding._class == "tower" && !MONSTERBUNKER.isBunkerBuilding(currentBuilding._type))
                  {
                     if((currentBuilding as BTOWER).isJard)
                     {
                        continue;
                     }
                  }
                  buildingPosition = GRID.FromISO(currentBuilding._mc.x,currentBuilding._mc.y + currentBuilding._middle);
                  distance = GLOBAL.QuickDistance(ownPosition,buildingPosition) - currentBuilding._middle;
                  if(distance < targetDistance)
                  {
                     target = currentBuilding;
                     targetDistance = distance;
                  }
                  targetFound = true;
               }
            }
         }
         if(!targetFound)
         {
            changeModeRetreat();
         }
         else
         {
            WaypointTo(new Point(target._mc.x,target._mc.y),target);           
         }
      }
      
      override public function clear() : void
      {
         this._lootMults = null;
         super.clear();
      }
   }
}
