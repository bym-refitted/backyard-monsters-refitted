package
{
   import gs.TweenLite;
   import gs.easing.Bounce;
   
   public class ParticleLoot
   {
       
      
      private var _resourcePackage:ResourcePackage_CLIP;
      
      private var _building:BFOUNDATION;
      
      public function ParticleLoot(param1:BFOUNDATION, param2:int, param3:int)
      {
         super();
         if(!GLOBAL._catchup)
         {
            this._building = param1;
            this._resourcePackage = new ResourcePackage_CLIP();
            MAP._RESOURCES.addChild(this._resourcePackage);
            this._resourcePackage.mcDot.gotoAndStop(param3);
            this._resourcePackage.x = param1._mc.x;
            this._resourcePackage.y = param1._mc.y;
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
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc7_:Number = NaN;
         _loc1_ = this._building._mcFootprint.width * 0.35;
         _loc2_ = this._building._mcFootprint.height * 0.35;
         _loc3_ = Math.random() * 2 - 1;
         this._resourcePackage.x += _loc3_ * _loc1_;
         var _loc4_:Number = this._resourcePackage.x + _loc3_ * _loc1_;
         TweenLite.to(this._resourcePackage,2,{
            "x":_loc4_,
            "overwrite":0,
            "onComplete":this.Remove
         });
         var _loc5_:Number = Math.random() * 2 - 1;
         this._resourcePackage.y += _loc3_ * _loc2_;
         var _loc6_:Number;
         _loc7_ = (_loc6_ = _loc3_ * -1 * _loc2_) + _loc2_ * 1.5;
         this._resourcePackage.mcShadow.y = _loc7_;
         TweenLite.to(this._resourcePackage.mcDot,1,{
            "y":_loc7_,
            "ease":Bounce.easeOut,
            "overwrite":0
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
