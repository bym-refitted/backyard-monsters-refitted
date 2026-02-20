package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.geom.*;
   import flash.utils.getTimer;
   
   public class MAPBG
   {
       
      
      public function MAPBG()
      {
         super();
      }
      
      public static function MakeTile(param1:String = "grass") : BitmapData
      {
         var tile:int = 0;
         var ti:int = 0;
         var tileCount:int = 0;
         var g:Object = null;
         var t:Object = null;
         var h:int = 0;
         var groundMask:BitmapData = null;
         var groundCompiled:BitmapData = null;
         var groundCompiledBMP:Bitmap = null;
         var v:int = 0;
         var i:int = 0;
         var texture:String = param1;
         try
         {
            ti = getTimer();
            tileCount = 0;
            if(texture == "lava")
            {
               g = {
                  "g1":new inferno_lava1(0,0),
                  "g2":new inferno_lava2(0,0),
                  "g3":new inferno_lava3(0,0),
                  "g4":new inferno_lava4(0,0)
               };
               tileCount = 4;
            }
            else if(texture == "rock")
            {
               g = {
                  "g1":new isorock1(0,0),
                  "g2":new isorock2(0,0),
                  "g3":new isorock3(0,0),
                  "g4":new isograss1(0,0),
                  "g5":new isograss2(0,0)
               };
               tileCount = 5;
            }
            else if(texture == "sand")
            {
               g = {
                  "g1":new isosand1(0,0),
                  "g2":new isosand2(0,0),
                  "g3":new isosand3(0,0),
                  "g4":new isosand4(0,0)
               };
               tileCount = 4;
            }
            else if(texture == "grass")
            {
               g = {
                  "g1":new isograss1(0,0),
                  "g2":new isograss2(0,0),
                  "g3":new isograss3(0,0),
                  "g4":new isograss4(0,0),
                  "g5":new isograss5(0,0),
                  "g6":new isograss6(0,0),
                  "g7":new isograss7(0,0)
               };
               tileCount = 7;
            }
            else if(texture == "crater")
            {
               g = {"g1":new isocrater1(0,0)};
               tileCount = 1;
            }
            t = {
               "t1":new BitmapData(1000,500,true,0),
               "t2":new BitmapData(1000,500,true,0),
               "t3":new BitmapData(1000,500,true,0),
               "t4":new BitmapData(1000,500,true,0),
               "t5":new BitmapData(1000,500,true,0),
               "t6":new BitmapData(1000,500,true,0),
               "t7":new BitmapData(1000,500,true,0)
            };
            h = 0;
            while(h < 5)
            {
               v = 0;
               while(v < 5)
               {
                  i = 1;
                  while(i <= tileCount)
                  {
                     t["t" + i].copyPixels(g["g" + i],new Rectangle(0,0,200,100),new Point(h * 200,v * 100),null,null,true);
                     i++;
                  }
                  v++;
               }
               h++;
            }
            groundCompiled = new BitmapData(1000,500,true,0);
            groundCompiledBMP = new Bitmap(groundCompiled);
            groundCompiled.draw(t["t1"]);
            tile = 2;
            while(tile <= tileCount)
            {
               groundMask = new BitmapData(1000,500,true,0);
               groundMask.perlinNoise(50 * tile,25 * tile,2,BASE._baseSeed + 1 + tile,true,false,BitmapDataChannel.ALPHA,true,null);
               groundCompiled.copyPixels(t["t" + tile],new Rectangle(0,0,1000,500),new Point(0,0),groundMask,null,true);
               tile++;
            }
            i = 1;
            while(i < tileCount)
            {
               g["g" + i].dispose();
               t["t" + i].dispose();
               i++;
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","MAPBG.MakeTile: " + e.message + " | " + e.getStackTrace());
         }
         return groundCompiled;
      }
   }
}
