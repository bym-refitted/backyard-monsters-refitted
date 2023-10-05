package com.monsters.siege.weapons
{
   import com.cc.utils.SecNum;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.interfaces.ITargetable;
   import com.monsters.interfaces.ITickable;
   import com.monsters.siege.SiegeWeapons;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.SoundChannel;
   import flash.utils.getTimer;
   import gs.TweenLite;
   import gs.easing.Expo;
   
   public class VacuumHose implements IAttackable, ITickable
   {
      
      public static const MR3_MAX_LOOT_MULTIPLIER:Number = 0.1;
      
      public static const END_URL:String = "siegeimages/anim1.bottom.png";
      
      public static const END_NUM_FRAMES:uint = 15;
      
      public static const END_WIDTH:uint = 52;
      
      public static const END_HEIGHT:uint = 52;
      
      public static const PIPE_URL:String = "siegeimages/anim1.top.png";
      
      public static const PIPE_NUM_FRAMES:uint = 15;
      
      public static const PIPE_WIDTH:uint = 26;
      
      public static const PIPE_HEIGHT:uint = 97;
       
      
      public var _vacuum:Sprite;
      
      public var _vacuumSound:SoundChannel;
      
      public var _vacuumHealth:SecNum;
      
      public var _vacuumMaxHealth:int;
      
      public var _vacuumLootRate:SecNum;
      
      public var _vacuumFrame:int;
      
      public var _vacuumStartTime:int;
      
      public var _vacuumCurrTime:int;
      
      public var _vacuumPipeSource:BitmapData;
      
      public var _vacuumEndSource:BitmapData;
      
      public var _vacuumHealthBar:BitmapData;
      
      public var _vacuumLootTotals:Array;
      
      public var _target:BFOUNDATION;
      
      public var _totalPossibleLoot:uint;
      
      public var _amountLooted:uint;
      
      public function VacuumHose(param1:BFOUNDATION, param2:uint, param3:uint)
      {
         this._vacuumHealthBar = new bmp_healthbarsmall(0,0);
         super();
         SPRITES.SetupSprite("vacuum_pipe");
         SPRITES.SetupSprite("vacuum_end");
         this._target = param1;
         this.ApplyVacuum(param2,param3);
      }
      
      public function hasMaxedAmountToLoot() : Boolean
      {
         return this._amountLooted > this._totalPossibleLoot;
      }
      
      public function VacuumLoot(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         if(!this.hasMaxedAmountToLoot())
         {
            _loc3_ = 0;
            _loc4_ = [];
            if(BASE._resources.r1.Get() > 0)
            {
               _loc4_.push({
                  "id":1,
                  "quantity":BASE._resources.r1.Get()
               });
            }
            if(BASE._resources.r2.Get() > 0)
            {
               _loc4_.push({
                  "id":2,
                  "quantity":BASE._resources.r2.Get()
               });
            }
            if(BASE._resources.r3.Get() > 0)
            {
               _loc4_.push({
                  "id":3,
                  "quantity":BASE._resources.r3.Get()
               });
            }
            if(BASE._resources.r4.Get() > 0)
            {
               _loc4_.push({
                  "id":4,
                  "quantity":BASE._resources.r4.Get()
               });
            }
            if(_loc4_.length > 0)
            {
               if((_loc5_ = _loc4_[int(Math.random() * _loc4_.length)]).quantity >= Math.ceil(param1))
               {
                  _loc3_ = Math.ceil(param1);
               }
               else
               {
                  _loc3_ = int(_loc5_.quantity);
               }
               BASE._resources["r" + _loc5_.id].Add(-_loc3_);
               BASE._hpResources["r" + _loc5_.id] -= _loc3_;
               if(BASE._deltaResources["r" + _loc5_.id])
               {
                  BASE._deltaResources["r" + _loc5_.id].Add(-_loc3_);
                  BASE._hpDeltaResources["r" + _loc5_.id] -= _loc3_;
               }
               else
               {
                  BASE._deltaResources["r" + _loc5_.id] = new SecNum(-_loc3_);
                  BASE._hpDeltaResources["r" + _loc5_.id] = -_loc3_;
               }
               BASE._deltaResources.dirty = true;
               BASE._hpDeltaResources.dirty = true;
               if(GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  _loc3_ = int(_loc3_ / 5);
               }
               ATTACK.Loot(_loc5_.id,_loc3_,this._target.x,this._target.y,9,this._target,true);
               this._vacuumLootTotals[_loc5_.id - 1] += _loc3_;
               this._amountLooted += _loc3_;
            }
            else
            {
               param1 = 0;
            }
         }
         var _loc2_:Number = this._vacuumHealth.Get();
         if(_loc2_ < this._vacuumMaxHealth)
         {
            _loc6_ = 11 - int(11 / this._vacuumMaxHealth * _loc2_);
            this._vacuumEndSource.copyPixels(this._vacuumHealthBar,new Rectangle(0,5 * _loc6_,17,5),new Point(17,6));
         }
      }
      
      public function get health() : Number
      {
         return this._vacuumHealth.Get();
      }
      
      public function get maxHealth() : Number
      {
         return this._vacuumMaxHealth;
      }
      
      public function modifyHealth(param1:Number, param2:ITargetable = null) : Number
      {
         this._vacuumHealth.Set(this._vacuumHealth.Get() + param1);
         return param1;
      }
      
      public function get x() : Number
      {
         return this._vacuum.x;
      }
      
      public function get y() : Number
      {
         return this._vacuum.y;
      }
      
      public function get defenseFlags() : int
      {
         return 0;
      }
      
      public function get attackFlags() : int
      {
         return 0;
      }
      
      public function get attackPriorityFlags() : Vector.<int>
      {
         return null;
      }
      
      public function ApplyVacuum(param1:int, param2:int) : void
      {
         var _loc6_:Bitmap = null;
         var _loc7_:uint = 0;
         if(this._target._destroyed)
         {
            return;
         }
         this._vacuum = new Sprite();
         this._vacuumEndSource = new BitmapData(END_WIDTH,END_HEIGHT,true,0);
         this._vacuumPipeSource = new BitmapData(PIPE_WIDTH,PIPE_HEIGHT,true,0);
         var _loc3_:Bitmap = new Bitmap(this._vacuumEndSource);
         this._vacuum.addChild(_loc3_);
         MAP._EFFECTSTOP.addChild(this._vacuum);
         this._vacuumSound = SOUNDS.Play("vacuumstart");
         if(this._vacuumSound)
         {
            this._vacuumSound.addEventListener(Event.SOUND_COMPLETE,this.onLoopStartSoundComplete,false,0,true);
         }
         this._vacuumLootTotals = [];
         this._vacuumLootTotals = [0,0,0,0];
         var _loc4_:int = -GLOBAL._mapHeight;
         var _loc5_:int = 0;
         _loc3_.x = -(END_WIDTH / 2);
         _loc3_.y = _loc5_ = _loc5_ - END_HEIGHT;
         while(_loc5_ > _loc4_)
         {
            (_loc6_ = new Bitmap(this._vacuumPipeSource)).x = -(PIPE_WIDTH / 2);
            _loc6_.y = _loc5_ = _loc5_ - PIPE_HEIGHT;
            this._vacuum.addChild(_loc6_);
         }
         this._totalPossibleLoot = uint.MAX_VALUE;
         if(this._target is ResourceOutpost)
         {
            _loc7_ = BASE._resources.r1.Get() + BASE._resources.r2.Get() + BASE._resources.r3.Get() + BASE._resources.r4.Get();
            this._totalPossibleLoot = _loc7_ * MR3_MAX_LOOT_MULTIPLIER;
            print("Using the loot-o-tron on a Resource Outpost. This base has " + GLOBAL.FormatNumber(_loc7_) + " resources so you will only be able to take " + GLOBAL.FormatNumber(this._totalPossibleLoot) + ". (" + MR3_MAX_LOOT_MULTIPLIER + "%)");
         }
         this._amountLooted = 0;
         this._vacuumLootRate = new SecNum(param2);
         this._vacuumMaxHealth = param1;
         this._vacuumHealth = new SecNum(param1);
         this._vacuumStartTime = this._vacuumCurrTime = getTimer();
         this._vacuum.x = this._target.x;
         this._vacuum.y = this._target.y - 400;
         this._vacuum.alpha = 0;
         TweenLite.to(this._vacuum,2,{
            "y":this._target.y + this._target._spoutPoint.y - 50,
            "alpha":1,
            "ease":Expo.easeOut
         });
      }
      
      public function onLoopStartSoundComplete(param1:Event) : void
      {
         this._vacuumSound = SOUNDS.Play("vacuumloop",0.8,0,100);
      }
      
      public function RemoveVacuum(param1:Boolean = false) : void
      {
         var ActuallyRemove:Function = null;
         var savedVacuum:Sprite = null;
         var wasDestroyed:Boolean = param1;
         ActuallyRemove = function():void
         {
            if(savedVacuum.parent)
            {
               savedVacuum.parent.removeChild(savedVacuum);
            }
            _vacuumEndSource.dispose();
            _vacuumPipeSource.dispose();
         };
         if(this._vacuum)
         {
            savedVacuum = this._vacuum;
            this._vacuum = null;
            if(this._vacuumHealth)
            {
               this._vacuumHealth.Set(0);
            }
            this._vacuumMaxHealth = 0;
            if(this._vacuumSound)
            {
               this._vacuumSound.stop();
               SOUNDS.Play(wasDestroyed ? "vacuumbroken" : "vacuumloopoff");
            }
            TweenLite.to(savedVacuum,2,{
               "y":this._target.y - 400,
               "alpha":0,
               "ease":Expo.easeOut,
               "onComplete":ActuallyRemove
            });
         }
      }
      
      public function tick(param1:int = 1) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this._target._destroyed)
         {
            this.targetDestroyed();
            return;
         }
         if(this._vacuum)
         {
            if(!this.hasMaxedAmountToLoot())
            {
               ++this._vacuumFrame;
               SPRITES.GetFrameById(this._vacuumEndSource,"vacuum_end",this._vacuumFrame % END_NUM_FRAMES,0);
               SPRITES.GetFrameById(this._vacuumPipeSource,"vacuum_pipe",this._vacuumFrame % PIPE_NUM_FRAMES,0);
            }
            if(this._vacuumHealth.Get() > 0)
            {
               _loc2_ = (this._vacuumCurrTime - this._vacuumStartTime) * this._vacuumLootRate.Get() / 1000;
               this._vacuumCurrTime = getTimer();
               _loc3_ = (this._vacuumCurrTime - this._vacuumStartTime) * this._vacuumLootRate.Get() / 1000;
               this.VacuumLoot(_loc3_ - _loc2_);
            }
            else if(SiegeWeapons.activeWeapon)
            {
               SiegeWeapons.deactivateWeapon();
            }
         }
      }
      
      private function targetDestroyed() : void
      {
         SiegeWeapons.deactivateWeapon();
         if(UI2._top)
         {
            UI2._top.validateSiegeWeapon();
         }
      }
   }
}
