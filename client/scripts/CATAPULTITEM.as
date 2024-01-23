package
{
   import com.monsters.display.ImageCache;
   import com.monsters.effects.ResourceBombs;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class CATAPULTITEM extends CATAPULTITEM_view
   {
       
      
      public var _props:Object;
      
      public var _bombid:String;
      
      public var _enabled:Boolean;
      
      public var _image:Sprite;
      
      public var _locked:Boolean;
      
      public var _popX:int;
      
      public var _popY:int;
      
      public var _popup:bubblepopup3;
      
      private var _constant:Boolean;
      
      public function CATAPULTITEM()
      {
         super();
      }
      
      public function Setup(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = true) : void
      {
         this._props = ResourceBombs._bombs[param1];
         this._bombid = param1;
         _txtMC._tA.htmlText = "<b>" + this._props.name + "</b>";
         this._image = new Sprite();
         addChild(this._image);
         this._popup = new bubblepopup3();
         this._popup.x = 44;
         this._popup.y = 29;
         addChild(this._popup);
         this._popX = this._popup.x;
         this._popY = this._popup.y;
         this._constant = param2;
         if(this._constant)
         {
            this.Enabled = param3;
         }
         setChildIndex(this._image,1);
         setChildIndex(_txtMC,2);
         setChildIndex(this._popup,3);
         ImageCache.GetImageWithCallBack(this._props.image,this.imageComplete);
         this.mouseEnabled = false;
         this.Hide();
         this.Update();
      }
      
      public function imageComplete(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Bitmap = new Bitmap(param2);
         this._image.addChild(_loc3_);
         _loc3_.width = 60;
         _loc3_.height = 60;
      }
      
      public function Update() : void
      {
         this._props = ResourceBombs._bombs[this._bombid];
         if(this._constant)
         {
            return;
         }
         this._locked = this._props.catapultLevel > GLOBAL._attackersCatapult;
         if(!this._props.used)
         {
            if(!this._locked)
            {
               this.Enabled = this._props.cost <= GLOBAL._attackersResources["r" + this._props.resource].Get();
            }
            else
            {
               this.Enabled = false;
            }
         }
         else
         {
            this.Enabled = false;
         }
      }
      
      public function ShowOver() : void
      {
         var _loc1_:* = "<b>" + this._props.name + "</b>";
         if(this._props.description)
         {
            _loc1_ += "<br>" + KEYS.Get(this._props.description,{
               "v1":this._props.speed * 100 + "%",
               "v2":this._props.damageMult * 100 + "%",
               "v3":this._props.speedlength
            });
         }
         _loc1_ += "<br>" + KEYS.Get("bomb_cost_resources",{
            "v1":CATAPULTPOPUP.Format(this._props.cost),
            "v2":KEYS.Get(GLOBAL._resourceNames[this._props.resource - 1])
         }) + "<br>";
         if(this._props.catapultLevel > GLOBAL._attackersCatapult)
         {
            _loc1_ += "<br>" + "<b><font color = \"#FF0000\">" + KEYS.Get("bomb_catapult_level",{"v1":this._props.catapultLevel}) + "</font></b>";
         }
         else if(this._props.cost > GLOBAL._attackersResources["r" + this._props.resource].Get() && !this._props.used)
         {
            _loc1_ += "<br><b><font color = \"#FF0000\">" + KEYS.Get("bomb_need_resources",{"v1":KEYS.Get(GLOBAL._resourceNames[this._props.resource - 1])}) + "</font></b>";
         }
         this._popup.mouseEnabled = false;
         this._popup.Setup(this._popX,this._popY,_loc1_);
         this._popup.visible = true;
      }
      
      public function Hide() : void
      {
         this._popup.visible = false;
      }
      
      public function set Enabled(param1:Boolean) : void
      {
         this._enabled = param1;
         var _loc2_:Number = this._enabled ? 1 : 0.5;
         _txtMC._tA.alpha = _loc2_;
         this._image.alpha = _loc2_;
         this.useHandCursor = this._enabled;
         this.buttonMode = this._enabled;
      }
      
      public function get Enabled() : Boolean
      {
         return this._enabled;
      }
   }
}
