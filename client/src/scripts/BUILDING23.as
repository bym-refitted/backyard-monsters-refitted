package
{
   import com.cc.utils.SecNum;
   import com.monsters.interfaces.IAttackable;
   import com.monsters.siege.weapons.Vacuum;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BUILDING23 extends BTOWER
   {
      
      public static const TYPE:uint = 23;
       
      
      public var _animMC:MovieClip;
      
      public var _animFrame:int = 0;
      
      public var _field:BitmapData;
      
      public var _fieldBMP:Bitmap;
      
      public var _animBitmap:BitmapData;
      
      public var _blend:int;
      
      public var _blending:Boolean;
      
      public var _bank:SecNum;
      
      public function BUILDING23()
      {
         super();
         _type = 23;
         _frameNumber = 0;
         _footprint = [new Rectangle(0,0,70,70)];
         _gridCost = [[new Rectangle(0,0,70,70),10],[new Rectangle(10,10,50,50),200]];
         _spoutPoint = new Point(0,0);
         _spoutHeight = 30;
         _top = -30;
         SetProps();
      }
      
      override public function Fire(param1:IAttackable) : void
      {
         super.Fire(param1);
         SOUNDS.Play("laser",!isJard ? 0.8 : 0.4);
         var _loc2_:Number = 0.5 + 0.5 / maxHealth * health;
         var _loc3_:Number = 1;
         if(Boolean(GLOBAL._towerOverdrive) && GLOBAL._towerOverdrive.Get() >= GLOBAL.Timestamp())
         {
            _loc3_ = 1.25;
         }
         if(isJard)
         {
            _jarHealth.Add(-int(damage * 25 * _loc2_ * _loc3_));
            ATTACK.Damage(_mc.x,_mc.y + _top,damage * 25 * _loc2_ * _loc3_);
            if(_jarHealth.Get() <= 0)
            {
               KillJar();
            }
         }
         else if(_targetVacuum)
         {
            EFFECTS.Laser(x,y + 35,GLOBAL.townHall.x,GLOBAL.townHall.y - GLOBAL.townHall._mc.height * 2,60,int(damage * 25 * _loc2_ * _loc3_),0);
            ATTACK.Damage(_mc.x,_mc.y + _top,damage * 25 * _loc2_ * _loc3_);
            Vacuum.getHose().modifyHealth(-int(damage * 25 * _loc2_ * _loc3_));
         }
         else
         {
            EFFECTS.Laser(x,y + 35,param1.x,param1.y,60,int(damage * _loc2_ * _loc3_),_splash,this.Track);
         }
      }
      
      public function Track(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 360 + param1;
         }
         param1 /= 6.66;
         _animTick = param1;
         this.AnimFrame();
      }
      
      override public function AnimFrame(param1:Boolean = true) : void
      {
         if(_animLoaded && !GLOBAL._catchup)
         {
            _animRect.x = _animRect.width * _animTick;
            _animContainerBMD.copyPixels(_animBMD,_animRect,_nullPoint);
         }
         ++_frameNumber;
      }
      
      override public function Constructed() : void
      {
         var Brag:Function;
         var mc:MovieClip = null;
         super.Constructed();
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && BASE.isMainYard)
         {
            Brag = function(param1:MouseEvent):void
            {
               GLOBAL.CallJS("sendFeed",["build-lt",KEYS.Get("pop_laserbuilt_streamtitle"),KEYS.Get("pop_laserbuilt_streambody"),"build-lasertower.png"]);
               POPUPS.Next();
            };
            mc = new popup_building();
            mc.tA.htmlText = "<b>" + KEYS.Get("pop_laserbuilt_title") + "</b>";
            mc.tB.htmlText = KEYS.Get("pop_laserbuilt_body");
            mc.bPost.SetupKey("btn_brag");
            mc.bPost.addEventListener(MouseEvent.CLICK,Brag);
            mc.bPost.Highlight = true;
            POPUPS.Push(mc,null,null,null,"build.v2.png");
         }
      }
   }
}
