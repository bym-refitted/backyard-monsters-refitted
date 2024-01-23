package
{
   import gs.TweenLite;
   import gs.easing.Sine;
   
   public class ParticleVacuumLoot
   {
       
      
      private var _resourcePackage:ResourcePackage_CLIP;
      
      private var _building:BFOUNDATION;
      
      public function ParticleVacuumLoot(param1:BFOUNDATION, param2:int, param3:int)
      {
         super();
         if(!GLOBAL._catchup)
         {
            this._building = param1;
            this._resourcePackage = new ResourcePackage_CLIP();
            MAP._RESOURCES.addChild(this._resourcePackage);
            this._resourcePackage.mcDot.gotoAndStop(param3);
            this._resourcePackage.x = param1._mc.x + param1._spoutPoint.x;
            this._resourcePackage.y = param1._mc.y + param1._spoutPoint.y;
            this._resourcePackage.mcShadow.visible = false;
            this.Launch();
            TweenLite.to(this._resourcePackage,0.5,{
               "alpha":0,
               "delay":1.5,
               "overwrite":0
            });
            SOUNDS.Play("bankland");
         }
      }
      
      public function Launch() : void
      {
         var _loc2_:BFOUNDATION = null;
         var _loc1_:Number = 10;
         _loc2_ = GLOBAL.townHall as BFOUNDATION;
         var _loc3_:Number = this._resourcePackage.x;
         var _loc4_:Number = this._resourcePackage.y + _loc2_._spoutPoint.y - 200;
         this._resourcePackage.x += (Math.random() * 2 - 1) * _loc1_;
         TweenLite.to(this._resourcePackage,1,{
            "x":_loc3_,
            "y":_loc4_,
            "ease":Sine.easeIn,
            "onComplete":this.Remove
         });
      }
      
      public function Remove() : void
      {
         try
         {
            MAP._RESOURCES.removeChild(this._resourcePackage);
         }
         catch(e:Error)
         {
         }
         this._resourcePackage = null;
      }
   }
}
