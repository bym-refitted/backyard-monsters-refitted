package
{
   import com.monsters.display.ImageCache;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.MouseEvent;
   
   public class CHAMPIONBUTTON extends GUARDIANBUTTON_CLIP
   {
       
      
      public var _creatureID:String;
      
      public var _creatureData:Object;
      
      public var _level:int;
      
      public var _description:bubblepopup3;
      
      public var _sent:Boolean = false;
      
      private var _index:int = 0;
      
      private const MAX_ICON_LEVEL:uint = 6;
      
      public function CHAMPIONBUTTON(param1:String, param2:int, param3:int, param4:int, param5:DisplayObjectContainer)
      {
         super();
         this._index = param3;
         this._creatureID = param1;
         this._creatureData = CHAMPIONCAGE._guardians[param1];
         this._level = Math.min(this.MAX_ICON_LEVEL,param2);
         var _loc6_:String = String(CHAMPIONCAGE._guardians[param1].name);
         if(Boolean(GLOBAL._playerGuardianData[this._index]) && Boolean(GLOBAL._playerGuardianData[this._index].l.Get()))
         {
            txtName.htmlText = "<b>" + _loc6_ + " Level " + GLOBAL._playerGuardianData[this._index].l.Get() + "</b>";
         }
         else
         {
            txtName.htmlText = "<b>" + _loc6_ + " Level 1</b>";
         }
         ImageCache.GetImageWithCallBack("monsters/" + this._creatureID + "_L" + this._level + "-small.png",this.IconLoaded,true,1);
         this._description = new bubblepopup3();
         this._description.Setup(190,26,KEYS.Get(CHAMPIONCAGE._guardians[this._creatureID].description),5);
         param5.addChild(this._description);
         this._description.visible = false;
         _bg.gotoAndStop("bg" + String(param4 % 2 + 1));
         bSend.SetupKey("btn_send");
         bSend.addEventListener(MouseEvent.CLICK,this.Send);
         bRetreat.SetupKey("btn_retreat");
         bRetreat.addEventListener(MouseEvent.CLICK,this.Retreat);
         addEventListener(MouseEvent.ROLL_OVER,this.Over);
         addEventListener(MouseEvent.ROLL_OUT,this.Out);
         if(!GLOBAL.isInAttackMode)
         {
            bSend.visible = false;
            bSend.Enabled = false;
            bRetreat.visible = false;
            bRetreat.Enabled = false;
         }
         if(CREEPS._flungGuardian)
         {
            CREEPS._flungGuardian[this._index] = false;
         }
         this.Update();
      }
      
      public function IconLoaded(param1:String, param2:BitmapData) : void
      {
         mcImage.addChild(new Bitmap(param2));
      }
      
      public function Update() : void
      {
         if(CREEPS._flungGuardian[this._index])
         {
            bSend.removeEventListener(MouseEvent.CLICK,this.Send);
            bSend.Enabled = false;
         }
      }
      
      public function Send(param1:MouseEvent) : void
      {
         if(!this._sent)
         {
            ATTACK.BucketAdd(this._creatureID);
            bSend.SetupKey("btn_hold");
            ATTACK.BucketUpdate();
            this._sent = true;
         }
         else
         {
            this.deSelectSend();
         }
         this.Update();
      }
      
      public function deSelectSend() : void
      {
         if(bSend.Enabled)
         {
            ATTACK.BucketRemove(this._creatureID);
            bSend.SetupKey("btn_send");
            ATTACK.BucketUpdate();
            this._sent = false;
         }
      }
      
      public function Retreat(param1:MouseEvent) : void
      {
         var _loc2_:int = CREEPS.getGuardianIndex(int(this._creatureID.substr(1)));
         if(_loc2_ >= 0)
         {
            CREEPS._guardianList[_loc2_].changeModeRetreat();
         }
      }
      
      public function Over(param1:MouseEvent) : void
      {
         this._description.visible = true;
      }
      
      public function Out(param1:MouseEvent) : void
      {
         this._description.visible = false;
      }
   }
}
