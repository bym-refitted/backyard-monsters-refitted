package
{
   import com.monsters.effects.ResourceBombs;
   import flash.events.*;
   import flash.geom.Point;
   
   public class DROPZONE extends DROPZONE_CLIP
   {
      
      public static const GROUND:int = 1;
      
      public static const BUILDINGS:int = 2;
      
      public static const MONSTERS:int = 3;
      
      public static const SIEGEWEAPON_GROUND:int = 4;
      
      public static const SIEGEWEAPON_BUILDINGS:int = 5;
      
      public static const SIEGEWEAPON_GROUND_SPECIAL:int = 6;
      
      public static const SIEGEWEAPON_GROUND_SPECIAL_RADIUS:int = 30;
       
      
      public var _size:int;
      
      public var _middle:Point;
      
      public var _dropTarget:int = 1;
      
      private var _targetedBuildings:Vector.<BFOUNDATION>;
      
      public function DROPZONE(param1:int = 32, param2:int = 1)
      {
         this._middle = new Point(0,0);
         this._targetedBuildings = new Vector.<BFOUNDATION>();
         super();
         this._size = param1;
         this._dropTarget = param2;
         // ring1 (the aiming ring) is a nested child of DROPZONE_CLIP that is null on iOS, so
         // the original ring1.addEventListener threw #1009 here and the whole drop zone was
         // never created -> could not deploy troops at all. Guard it; the touch tap-to-deploy
         // below (PlaceTouch) does not need the ring.
         if(ring1)
         {
            ring1.addEventListener(MouseEvent.MOUSE_UP,this.Place);
            ring1.addEventListener(MouseEvent.MOUSE_DOWN,MAP.Click);
            ring1.mouseEnabled = true;
            ring1.buttonMode = true;
            ring1.gotoAndStop(1);
         }
         addEventListener(Event.ENTER_FRAME,this.Follow);
         this.Update(this._size,param2);
         // Touch: there is no hovering cursor for the aiming ring to Follow, so the small ring
         // is never under the finger and ring1's MOUSE_UP (Place) never fires -> can't deploy.
         // Deploy at the tapped point instead: listen on the whole battlefield and, on release,
         // snap to the tap location and reuse the same Drop()/ATTACK.Spawn path.
         if(GLOBAL._iosViewport && MAP._GROUND)
         {
            MAP._GROUND.addEventListener(MouseEvent.MOUSE_UP,this.PlaceTouch);
         }
      }
      
      public function Update(param1:int, param2:int) : void
      {
         this._size = param1;
         this._dropTarget = param2;
         if(ring1)
         {
            ring1.width = this._size * 1.2;
            ring1.height = this._size * 1.2 * 0.5;
         }
      }
      
      public function Place(param1:MouseEvent) : void
      {
         if(!MAP._dragged && ATTACK._countdown >= 0)
         {
            this.Drop();
         }
      }

      public function PlaceTouch(param1:MouseEvent) : void
      {
         // A tap (not a map-scroll drag) anywhere on the ground deploys at that point on iOS.
         if(!MAP._dragged && ATTACK._countdown >= 0 && MAP._GROUND)
         {
            this.x = MAP._GROUND.mouseX;
            this.y = MAP._GROUND.mouseY;
            this.Drop();
         }
      }
      
      public function Follow(param1:Event = null) : void
      {
         if(MAP._GROUND)
         {
            x = MAP._GROUND.mouseX;
            y = MAP._GROUND.mouseY;
            switch(this._dropTarget)
            {
               case GROUND:
                  if(!BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
                  {
                     if(ring1) ring1.gotoAndStop(1);
                  }
                  else
                  {
                     if(ring1) ring1.gotoAndStop(2);
                  }
                  break;
               case SIEGEWEAPON_GROUND:
                  if(!BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
                  {
                     if(ring1) ring1.gotoAndStop(1);
                  }
                  else
                  {
                     if(ring1) ring1.gotoAndStop(2);
                  }
                  this.UpdateTargetBuildings(x,y,this._size);
                  break;
               case SIEGEWEAPON_GROUND_SPECIAL:
                  if(!BASE.BuildingOverlap(new Point(x,y),SIEGEWEAPON_GROUND_SPECIAL_RADIUS,true,true,true))
                  {
                     if(ring1) ring1.gotoAndStop(1);
                  }
                  else
                  {
                     if(ring1) ring1.gotoAndStop(2);
                  }
                  this.UpdateTargetBuildings(x,y,this._size);
                  break;
               case BUILDINGS:
               case SIEGEWEAPON_BUILDINGS:
                  if(BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
                  {
                     if(ring1) ring1.gotoAndStop(1);
                  }
                  else
                  {
                     if(ring1) ring1.gotoAndStop(2);
                  }
                  this.UpdateTargetBuildings(x,y,this._size);
                  break;
               case MONSTERS:
                  if(CREEPS.CreepOverlap(new Point(x,y),this._size))
                  {
                     if(ring1) ring1.gotoAndStop(1);
                  }
                  else
                  {
                     if(ring1) ring1.gotoAndStop(2);
                  }
            }
         }
      }
      
      public function Clear() : void
      {
         while(this._targetedBuildings.length)
         {
            this._targetedBuildings.pop().disableHighlight();
         }
      }
      
      public function Destroy() : void
      {
         this.Clear();
         removeEventListener(Event.ENTER_FRAME,this.Follow);
         if(GLOBAL._iosViewport && MAP._GROUND)
         {
            MAP._GROUND.removeEventListener(MouseEvent.MOUSE_UP,this.PlaceTouch);
         }
      }
      
      public function get isOverTarget() : Boolean
      {
         return this._targetedBuildings.length > 0;
      }
      
      public function UpdateTargetBuildings(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:int = 0;
         this.Clear();
         BASE.GetBuildingOverlap(param1,param2,param3,this._targetedBuildings);
         switch(this._dropTarget)
         {
            case SIEGEWEAPON_BUILDINGS:
               _loc4_ = int(this._targetedBuildings.length - 1);
               while(_loc4_ >= 0)
               {
                  if(!(this._targetedBuildings[_loc4_] is BTOWER))
                  {
                     this._targetedBuildings.splice(_loc4_,1);
                  }
                  _loc4_--;
               }
               break;
            case SIEGEWEAPON_GROUND_SPECIAL:
               _loc4_ = int(this._targetedBuildings.length - 1);
               while(_loc4_ >= 0)
               {
                  if(!(this._targetedBuildings[_loc4_] is BUILDING22))
                  {
                     this._targetedBuildings.splice(_loc4_,1);
                  }
                  _loc4_--;
               }
         }
         _loc4_ = 0;
         while(_loc4_ < this._targetedBuildings.length)
         {
            this._targetedBuildings[_loc4_].highlight(3355545);
            _loc4_++;
         }
      }
      
      public function Drop() : void
      {
         var _loc1_:SIEGEWEAPONPOPUP = null;
         switch(this._dropTarget)
         {
            case GROUND:
               if(!BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
               {
                  ATTACK.Spawn(new Point(x,y),this._size / 2);
               }
               break;
            case BUILDINGS:
               if(BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
               {
                  ResourceBombs.BombDrop();
               }
               break;
            case MONSTERS:
               if(CREEPS.CreepOverlap(new Point(x,y),this._size))
               {
                  ResourceBombs.BombDrop();
               }
               break;
            case SIEGEWEAPON_GROUND:
               if(BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
               {
                  break;
               }
               _loc1_ = UI2._top._siegeweapon;
               if(Boolean(_loc1_) && _loc1_._state == 1)
               {
                  _loc1_.Fire(x,y);
               }
               break;
            case SIEGEWEAPON_BUILDINGS:
               if(!BASE.BuildingOverlap(new Point(x,y),this._size,true,true,true))
               {
                  break;
               }
               _loc1_ = UI2._top._siegeweapon;
               if(Boolean(_loc1_) && _loc1_._state == 1)
               {
                  _loc1_.Fire(x,y);
               }
               break;
            case SIEGEWEAPON_GROUND_SPECIAL:
               if(BASE.BuildingOverlap(new Point(x,y),SIEGEWEAPON_GROUND_SPECIAL_RADIUS,true,true,true))
               {
                  break;
               }
               _loc1_ = UI2._top._siegeweapon;
               if(Boolean(_loc1_) && _loc1_._state == 1)
               {
                  _loc1_.Fire(x,y);
               }
               break;
         }
      }
   }
}
