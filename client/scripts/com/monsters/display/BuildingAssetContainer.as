package com.monsters.display
{
   import flash.display.MovieClip;
   
   public class BuildingAssetContainer extends MovieClip
   {
       
      
      public function BuildingAssetContainer()
      {
         super();
         this.Clear();
      }
      
      public function Clear() : void
      {
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
      }
   }
}
