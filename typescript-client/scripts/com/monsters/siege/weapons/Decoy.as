package com.monsters.siege.weapons
{
   import com.monsters.display.SpriteData;
   import com.monsters.display.SpriteSheetAnimation;
   import com.monsters.managers.InstanceManager;
   import com.monsters.monsters.champions.ChampionBase;
   import com.monsters.monsters.components.statusEffects.DecoyEffect;
   import com.monsters.monsters.creeps.CreepBase;
   import com.monsters.siege.SiegeWeaponProperty;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import gs.TweenLite;
   import gs.easing.Expo;
   
   public class Decoy extends SiegeWeapon
   {
      
      public static const ID:String = "decoy";
      
      public static const DAMAGE:String = "siegeWeaponDamage";
      
      public static const EXPLOSION_SOUND:String = "othersounds/decoyExplosionSound.mp3";
      
      public static const LOOPING_SOUND:String = "othersounds/decoyLoopingSound.mp3";
      
      public static const DECOY_WAVE:String = "decoyWaveAnimation";
      
      public static const DECOY_FUSE:String = "decoyFuseAnimation";
      
      public static const DECOY_EXPLOSION:String = "decoyExplosionAnimation";
      
      public static const LAND_SOUND:String = "othersounds/decoyLandSound.mp3";
       
      
      public var x:Number;
      
      public var y:Number;
      
      public var decoyGraphic:SpriteSheetAnimation;
      
      private var _attractedCreeps:Array;
      
      private var _loopingChannel:SoundChannel;
      
      private var _isActive:Boolean;
      
      private var _container:Sprite;
      
      private var _fuse:SpriteSheetAnimation;
      
      public function Decoy()
      {
         weaponID = ID;
         dropTarget = DROPZONE.SIEGEWEAPON_GROUND_SPECIAL;
         super();
         addProperty(DAMAGE,new SiegeWeaponProperty([1000,1500,2500,3500,4500,6500,9000,12500,17000,23500],1));
         addProperty(RANGE,new SiegeWeaponProperty([250,270,290,310,320,350,380,410,440,480],2));
         addProperty(DURATION,new SiegeWeaponProperty([10,11,12,12,14,15,17,18,19,21],3));
         addProperty(UPGRADE_COSTS,new SiegeWeaponProperty([{
            "r1":37599.9587467407,
            "r2":43866.6185378641,
            "r3":43866.6185378641,
            "r4":0,
            "time":14400
         },{
            "r1":72169.829039505,
            "r2":84198.1338794225,
            "r3":84198.1338794225,
            "r4":0,
            "time":18900
         },{
            "r1":138513.14459241,
            "r2":161598.668691145,
            "r3":161598.668691145,
            "r4":0,
            "time":25200
         },{
            "r1":265769.311821143,
            "r2":310064.197124667,
            "r3":310064.197124667,
            "r4":0,
            "time":36000
         },{
            "r1":509415.86296686,
            "r2":594318.50679467,
            "r3":594318.50679467,
            "r4":0,
            "time":55800
         },{
            "r1":972778.278801511,
            "r2":1134907.9919351,
            "r3":1134907.9919351,
            "r4":0,
            "time":86400
         },{
            "r1":1833130.23035504,
            "r2":2138651.93541421,
            "r3":2138651.93541421,
            "r4":0,
            "time":216000
         },{
            "r1":3309676.9374281,
            "r2":3861289.76033278,
            "r3":3861289.76033278,
            "r4":0,
            "time":302400
         },{
            "r1":5369777.93088871,
            "r2":6264740.91937016,
            "r3":6264740.91937016,
            "r4":0,
            "time":345600
         },{
            "r1":7386672.13671496,
            "r2":8617784.15950078,
            "r3":8617784.15950078,
            "r4":0,
            "time":388800
         }]));
         addProperty(BUILD_COSTS,new SiegeWeaponProperty([{
            "r1":14324,
            "r2":28648,
            "r3":28648,
            "r4":0,
            "time":3000
         },{
            "r1":27493,
            "r2":54987,
            "r3":54987,
            "r4":0,
            "time":4500
         },{
            "r1":52767,
            "r2":105534,
            "r3":105534,
            "r4":0,
            "time":7200
         },{
            "r1":101245,
            "r2":202491,
            "r3":202491,
            "r4":0,
            "time":9900
         },{
            "r1":194063,
            "r2":388126,
            "r3":388126,
            "r4":0,
            "time":15300
         },{
            "r1":370582,
            "r2":741164,
            "r3":741164,
            "r4":0,
            "time":22500
         },{
            "r1":698335,
            "r2":1396671,
            "r3":1396671,
            "r4":0,
            "time":34200
         },{
            "r1":1260829,
            "r2":2521659,
            "r3":2521659,
            "r4":0,
            "time":51300
         },{
            "r1":2045630,
            "r2":4091259,
            "r3":4091259,
            "r4":0,
            "time":76500
         },{
            "r1":2813970,
            "r2":5627941,
            "r3":5627941,
            "r4":0,
            "time":86400
         }]));
         this.loadAssets();
      }
      
      private function loadAssets() : void
      {
         SPRITES.SetupSprite(DECOY_EXPLOSION);
         SPRITES.SetupSprite(DECOY_FUSE);
         SPRITES.SetupSprite(DECOY_WAVE);
      }
      
      public function get damage() : int
      {
         return Math.max(0,Math.min(23500,getProperty(DAMAGE).getValueForLevel(level)));
      }
      
      override public function onActivation(param1:Number, param2:Number) : void
      {
         this.loadAssets();
         this.x = param1;
         this.y = param2;
         this._container = new Sprite();
         this._container.x = param1;
         this._container.y = param2;
         this.setDecoyGraphic(new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(DECOY_WAVE) as SpriteData,45));
         this._fuse = new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(DECOY_FUSE) as SpriteData,21);
         this._fuse.x = this.decoyGraphic.x + -8;
         this._fuse.y = this.decoyGraphic.y + 30;
         this._fuse.render();
         this._container.addChild(this._fuse);
         MAP._BUILDINGTOPS.addChild(this._container);
         TweenLite.from(this._container,0.6,{
            "y":this._container.y - 300,
            "ease":Expo.easeIn,
            "onComplete":this.onDecoyLanding
         });
         TweenLite.delayedCall(duration - 0.5,this.startFuseAnimation);
         this._attractedCreeps = [];
         SOUNDS.Play(LAND_SOUND);
      }
      
      private function startFuseAnimation() : void
      {
         this._fuse.play();
      }
      
      private function onDecoyLanding() : void
      {
         this._isActive = true;
         this._loopingChannel = SOUNDS.Play(LOOPING_SOUND,0.8,0,int.MAX_VALUE);
         this.decoyGraphic.play();
         this.decoyGraphic.doesRepeat = true;
         this._container.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this.ejectDefendersFromBunkers();
      }
      
      private function ejectDefendersFromBunkers() : void
      {
         var _loc1_:Vector.<BFOUNDATION> = new Vector.<BFOUNDATION>();
         BASE.GetBuildingOverlap(this.x,this.y,range,_loc1_);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] is BUILDING22)
            {
               BUILDING22(_loc1_[_loc2_]).EjectCreeps(new Point(this.x,this.y));
            }
            _loc2_++;
         }
      }
      
      private function updateDecoy() : void
      {
         var _loc2_:CreepBase = null;
         var _loc1_:Array = this.getDefendingCreepsInRange();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(_loc1_[_loc3_] is CreepBase)
            {
               _loc2_ = CreepBase(_loc1_[_loc3_]);
               if(this._attractedCreeps.indexOf(_loc2_) == -1)
               {
                  this.attractCreep(_loc2_);
               }
            }
            _loc3_++;
         }
         _loc3_ = int(this._attractedCreeps.length - 1);
         while(_loc3_ >= 0)
         {
            _loc2_ = this._attractedCreeps[_loc3_];
            if(_loc1_.indexOf(_loc2_) == -1)
            {
               this.detractCreep(_loc2_,_loc3_);
            }
            _loc3_--;
         }
         this.ejectDefendersFromBunkers();
      }
      
      private function attractCreep(param1:CreepBase) : void
      {
         this._attractedCreeps.push(param1);
         param1.addStatusEffect(new DecoyEffect(param1));
         param1.changeModeDecoy();
      }
      
      private function detractCreep(param1:CreepBase, param2:int) : void
      {
         this._attractedCreeps.splice(param2,1);
         param1.findDefenseTargets();
         param1.removeStatusEffect(DecoyEffect);
         TweenLite.killDelayedCallsTo(this.startFuseAnimation);
      }
      
      override public function onDeactivation() : void
      {
         var _loc4_:BFOUNDATION = null;
         var _loc5_:int = 0;
         var _loc6_:* = undefined;
         var _loc1_:Point = new Point(this.x,this.y);
         var _loc2_:Array = this.getDefendingCreepsInRange();
         var _loc3_:Vector.<Object> = InstanceManager.getInstancesByClass(BFOUNDATION);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ is BMUSHROOM === false && GLOBAL.QuickDistance(_loc1_,new Point(_loc4_.x,_loc4_.y)) < range * 0.65)
            {
               _loc2_.push(_loc4_);
            }
         }
         Targeting.DealLinearAEDamage(_loc1_,range,this.damage,_loc2_);
         _loc5_ = int(this._attractedCreeps.length - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = this._attractedCreeps[_loc5_];
            this.detractCreep(_loc6_,_loc5_);
            _loc5_--;
         }
         SOUNDS.Play(EXPLOSION_SOUND);
         if(this._loopingChannel)
         {
            this._loopingChannel.stop();
         }
         this._container.removeChild(this._fuse);
         this.setDecoyGraphic(new SpriteSheetAnimation(SPRITES.GetSpriteDescriptor(DECOY_EXPLOSION) as SpriteData,33));
         this.decoyGraphic.play();
         this._isActive = false;
      }
      
      private function setDecoyGraphic(param1:SpriteSheetAnimation) : void
      {
         if(Boolean(this.decoyGraphic) && Boolean(this.decoyGraphic.parent))
         {
            this.decoyGraphic.parent.removeChild(this.decoyGraphic);
         }
         this.decoyGraphic = param1;
         this.decoyGraphic.render();
         this.decoyGraphic.x = -(this.decoyGraphic.width * 0.5);
         this.decoyGraphic.y = -(this.decoyGraphic.height * 0.5);
         this._container.addChild(this.decoyGraphic);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.decoyGraphic.update();
         if(this._isActive)
         {
            this.updateDecoy();
            this._fuse.update();
         }
         else if(this.decoyGraphic.currentFrame >= this.decoyGraphic.totalFrames)
         {
            this._container.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(this._container.parent)
            {
               this._container.parent.removeChild(this._container);
            }
         }
      }
      
      private function getDefendingCreepsInRange(param1:int = 2147483647) : Array
      {
         var _loc5_:* = undefined;
         var _loc6_:Number = NaN;
         var _loc2_:Array = [];
         if(!this._isActive)
         {
            return [];
         }
         var _loc3_:Point = new Point(this.x,this.y);
         var _loc4_:Object = CREATURES._creatures;
         if(CREATURES._guardian)
         {
            if(GLOBAL.QuickDistance(new Point(CREATURES._guardian._mc.x,CREATURES._guardian._mc.y),_loc3_) <= range)
            {
               _loc2_.push(CREATURES._guardian);
            }
         }
         for each(_loc5_ in _loc4_)
         {
            if(!(_loc5_._behaviour != "defend" && _loc5_._behaviour != "bunker" && _loc5_._behaviour != "decoy" && !(_loc5_ is ChampionBase)))
            {
               if((_loc6_ = GLOBAL.QuickDistance(new Point(_loc5_._mc.x,_loc5_._mc.y),_loc3_)) <= range)
               {
                  _loc2_.push(_loc5_);
                  if(_loc2_.length >= param1)
                  {
                     return _loc2_;
                  }
               }
            }
         }
         return _loc2_;
      }
   }
}
