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

       
      /*
      param1 -> behaviour
      param2 -> targetPosition
      param3 -> targetRotation
      param4 -> targetCenter
      param5 -> friendly
      param6 -> house
      param7 -> level
      param8 -> feeds
      param9 -> feedTime
      param10 -> creatureID
      param11 -> health
      param12 -> foodBonus
      param13 -> powerLevel
      */
      
      public function Krallen(behaviour:String, targetPosition:Point, targetRotation:Number, targetCenter:Point = null, friendly:Boolean = false, house:BFOUNDATION = null, level:int = 1, feeds:int = 0, feedTime:int = 0, creatureID:int = 1, health:int = 20000, foodBonus:int = 0, powerLevel:int = 1)
      {
         var abilities:Array = null;
         var i:uint = 0;
         powerLevel = Math.min(powerLevel,MAX_POWERLEVEL);
         super(behaviour,targetPosition,targetRotation,targetCenter,friendly,house,level,feeds,feedTime,creatureID,health,foodBonus,powerLevel);
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
      
      //_loc1_ -> spriteDescriptor
      override protected function setupSprite() : void
      {
         _frameNumber = Math.random() * 7;
         _spriteID = _creatureID + "_" + _powerLevel.Get();
         SPRITES.SetupSprite(_spriteID);
         var spriteDescriptor:Object = SPRITES.GetSpriteDescriptor(_spriteID);
         _graphic = new BitmapData(spriteDescriptor.width,spriteDescriptor.height,true,16777215);
         _graphicMC = BYMConfig.instance.RENDERER_ON ? new Bitmap(_graphic) : graphic.addChild(new Bitmap(_graphic)) as Bitmap;
         _graphicMC.x = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_x");
         _graphicMC.y = CHAMPIONCAGE.GetGuardianProperty(_creatureID,_powerLevel.Get(),"offset_y");
         if(BYMConfig.instance.RENDERER_ON)
         {
            _rasterData = new RasterData(_graphicMC,_rasterPt,int.MAX_VALUE);
         }
      }
      
      /*
         _loc7_ -> currentBuilding
         _loc2_ -> buildings
         _loc12_ -> buildingPosition
         _loc13_ -> distance
         _loc14_ -> targets
         _loc17_ -> targetFound
         _loc18_ -> lootedBuildings
         _loc15_ -> also currentBuilding, removed since theres no use in having two for the same 
         _loc6_ -> removed since its never used
         _loc8_ -> removed since its never used
         _loc9_ -> removed since its never used
         _loc10_ -> removed since its never used
         _loc11_ -> ownPosition
         _loc16_ -> lootedBuildingKey 
         _loc19_ -> index
         _loc20_, _loc21_, _loc22_, _loc23_ -> belong to burrowing monsters which krallen its not, removed
         _loc24_, _loc25_, _loc26_ -> belong to flying monsters which krallen its not, removed
         _loc3_ -> defensiveBuildings
         _loc4_ -> bunkers
         _loc5_ -> removed since its never used
         param1 its never used but kept for consistency with other findTargets
      */

      override public function findTarget(param1:int = 0) : void
      {    
         var currentBuilding:BFOUNDATION = null;
         var ownPosition:Point = null;
         var buildingPosition:Point = null;
         var distance:int = 0;
         var lootedBuildingKey:String = null;
         var targetFound:Boolean = false;
         var index:int = 0;
         var buildings:Object = InstanceManager.getInstancesByClass(BFOUNDATION);
         var defensiveBuildings:Vector.<Object> = InstanceManager.getInstancesByClass(BTOWER);
         var bunkers:Vector.<Object> = InstanceManager.getInstancesByClass(Bunker);
         var targets:Array = [];
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
                  targets.push({
                     "building":currentBuilding,
                     "distance":distance
                  });
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
                  targets.push({
                     "building":currentBuilding,
                     "distance":distance,
                     "expand":false
                  });
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
                  targets.push({
                     "building":currentBuilding,
                     "distance":distance,
                     "expand":false
                  });
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
                  targets.push({
                     "building":currentBuilding,
                     "distance":distance,
                     "expand":true
                  });
                  targetFound = true;
               }
            }
         }
         if(targets.length == 0)
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
                  targets.push({
                     "building":currentBuilding,
                     "distance":distance,
                     "expand":true
                  });
               }
            }
         }
         if(targets.length == 0)
         {
            changeModeRetreat();
         }
         else
         {
            targets.sortOn("distance",Array.NUMERIC);
            index = 0;
            if(GLOBAL._catchup)
            {
               WaypointTo(new Point(targets[0].building._mc.x,targets[0].building._mc.y),targets[0].building);
            }
            else
            {
               index = 0;
               while(index < 2)
               {
                  if(targets.length > index)
                  {
                     WaypointTo(new Point(targets[index].building._mc.x,targets[index].building._mc.y),targets[index].building);
                  }
                  index++;
               }
            }
         }
      }
      
      override public function clear() : void
      {
         this._lootMults = null;
         super.clear();
      }
   }
}
