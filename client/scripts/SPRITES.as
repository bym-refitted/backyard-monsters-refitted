package
{
   import com.monsters.display.ImageCache;
   import com.monsters.display.SpriteData;
   import com.monsters.projectiles.ResurrectProjectile;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.Jars;
   import flash.display.BitmapData;
   
   public class SPRITES
   {
      
      public static var _sprites:Object;
       
      
      public function SPRITES()
      {
         super();
      }
      
      public static function Setup() : void
      {
         _sprites = {};
         if(!BASE.isInfernoMainYardOrOutpost)
         {
            _sprites.worker = new SpriteData("monsters/worker.png",27,27,9,19);
         }
         else
         {
            _sprites.worker = new SpriteData("monsters/inferno_worker.v2.png",64,55,32,36);
         }
         _sprites.C1 = new SpriteData("monsters/sprite.1.v1.png",24,21,8,14);
         _sprites.C2 = new SpriteData("monsters/octoooze.png",39,28,19,15);
         _sprites.C3 = new SpriteData("monsters/sprite.3.v2.png",30,28,7,20);
         _sprites.C4 = new SpriteData("monsters/fink.png",34,32,15,21);
         _sprites.C5 = new SpriteData("monsters/eyera.png",26,23,11,15);
         _sprites.C6 = new SpriteData("monsters/ichi.png",27,26,11,17);
         _sprites.C7 = new SpriteData("monsters/bandito.png",29,28,11,17);
         _sprites.C8 = new SpriteData("monsters/fang.png",34,31,16,19);
         _sprites.C9 = new SpriteData("monsters/brain.v2.png",34,24,16,13);
         _sprites.C10 = new SpriteData("monsters/crabatron.png",37,27,15,18);
         _sprites.C11 = new SpriteData("monsters/sprite.11.v2.png",48,35,24,22);
         _sprites.C12 = new SpriteData("monsters/sprite.12.v2.png",53,46,21,27);
         _sprites.C12Gold = new SpriteData("monsters/sprite.12.gold.png",53,46,21,27);
         _sprites.C13 = new SpriteData("monsters/13.png",40,26,19,17);
         _sprites.C14 = new SpriteData("monsters/14.v1.png",28,28,15,14);
         _sprites.C15 = new SpriteData("monsters/zafreeti.v2.png",56,70,28,35);
         _sprites.C16 = new SpriteData("monsters/vorg_anim.png",40,40,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.C17 = new SpriteData("monsters/slimeattikus_anim.png",48,31,SpriteData.FUBAR_X,SpriteData.FUBAR_Y - 21);
         _sprites.C18 = new SpriteData("monsters/slimeattikusmini_anim.png",30,20,SpriteData.FUBAR_X - 11,SpriteData.FUBAR_Y - 25);
         _sprites.C19 = new SpriteData("monsters/rezghul.png",48,43,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.IC1 = new SpriteData("monsters/spurtz.png",24,28,12,14);
         _sprites.IC2 = new SpriteData("monsters/zagnoid.png",64.4,46,26,28);
         _sprites.IC3 = new SpriteData("monsters/malphus.png",51,35,25,17);
         _sprites.IC4 = new SpriteData("monsters/valgos.png",55,32,11,15);
         _sprites.IC5 = new SpriteData("monsters/balthazar.png",56,37,33,18.5);
         _sprites.IC6 = new SpriteData("monsters/grokus.v2.png",57,39,28,20);
         _sprites.IC7 = new SpriteData("monsters/sabnox.png",42,34,21,17);
         _sprites.IC8 = new SpriteData("monsters/wormzer.png",58,42,29,21);
         _sprites.G1_1 = new SpriteData("monsters/ape_1.png",96,69,26,36);
         _sprites.G1_2 = new SpriteData("monsters/ape_2.png",89,73,26,36);
         _sprites.G1_3 = new SpriteData("monsters/ape_3.png",103,88,26,36);
         _sprites.G1_4 = new SpriteData("monsters/ape_4.png",148,127,26,36);
         _sprites.G1_5 = new SpriteData("monsters/ape_5.png",160,137,26,36);
         _sprites.G1_6 = new SpriteData("monsters/ape_6.png",140,120,26,36);
         _sprites.G2_1 = new SpriteData("monsters/dragon_1.png",64,41,26,36);
         _sprites.G2_2 = new SpriteData("monsters/dragon_2.png",87,58,26,36);
         _sprites.G2_3 = new SpriteData("monsters/dragon_3.png",114,85,26,36);
         _sprites.G2_4 = new SpriteData("monsters/dragon_4.png",131,93,26,36);
         _sprites.G2_5 = new SpriteData("monsters/dragon_5.png",156,117,26,36);
         _sprites.G2_6 = new SpriteData("monsters/dragon_6.png",171,125,26,36);
         _sprites.G3_1 = new SpriteData("monsters/fly_1.png",53,40,26,36);
         _sprites.G3_2 = new SpriteData("monsters/fly_2.png",63,46,26,36);
         _sprites.G3_3 = new SpriteData("monsters/fly_3.png",98,81,26,36);
         _sprites.G3_4 = new SpriteData("monsters/fly_4.png",120,92,26,36);
         _sprites.G3_5 = new SpriteData("monsters/fly_5.png",133,105,26,36);
         _sprites.G3_6 = new SpriteData("monsters/fly_6.png",124,105,26,36);
         _sprites.G4_1 = new SpriteData("monsters/korath_1.png",72,49,26,36);
         _sprites.G4_2 = new SpriteData("monsters/korath_2.png",119,81,26,36);
         _sprites.G4_3 = new SpriteData("monsters/korath_3.png",128,102,26,36);
         _sprites.G4_4 = new SpriteData("monsters/korath_4.png",153,123,26,36);
         _sprites.G4_5 = new SpriteData("monsters/korath_5.png",199,162,26,36);
         _sprites.G4_6 = new SpriteData("monsters/korath_6.png",202,167,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.G5_1 = new SpriteData("monsters/krallen_1_rev_65.png",130,80,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.G5_2 = new SpriteData("monsters/krallen_2_rev_65.png",131,90,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.G5_3 = new SpriteData("monsters/krallen_3_rev_65.png",142,100,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.C200 = new SpriteData("monsters/looter.png",51,47,7,33);
         _sprites.shadow = new SpriteData("monsters/flyingshadow.png",31,20,15,10);
         _sprites.bigshadow = new SpriteData("monsters/zafreeti-shadow.png",48,32,24,16);
         _sprites.rocket = new SpriteData("monsters/daverocket.png",16,16,26,36);
         _sprites.vacuum_pipe = new SpriteData("siegeimages/vacuum-pipe.png",26,97,26,36);
         _sprites.vacuum_end = new SpriteData("siegeimages/vacuum-end.png",52,52,26,36);
         _sprites.heart = new SpriteData("effects/heart_icon.v2.png",12,12,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.flame = new SpriteData("effects/flame_icon.png",16,25,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.venom = new SpriteData("effects/venom_icon.v2.png",16,26,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites.venomBal = new SpriteData("effects/venomBal_icon.png",420,332,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[SpurtzCannon.SPURTZ_PROJECTILE] = new SpriteData("buildings/ispurtz_cannon/spurtz_projectile.png",34,27,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[Jars.JAR_GRAPHIC] = new SpriteData(Jars.JAR_GRAPHIC_URL,Jars.JAR_GRAPHIC_WIDTH,Jars.JAR_GRAPHIC_HEIGHT,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[Decoy.DECOY_WAVE] = new SpriteData("siegeimages/decoy_wave_anim.png",61,70,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[Decoy.DECOY_FUSE] = new SpriteData("siegeimages/decoy_fuse_anim.png",44,49,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[Decoy.DECOY_EXPLOSION] = new SpriteData("siegeimages/decoy_explosion_anim.png",184,195,SpriteData.FUBAR_X,SpriteData.FUBAR_Y);
         _sprites[ResurrectProjectile.k_resurecctProjectile] = new SpriteData(ResurrectProjectile.k_projectileImageURL,20,20,0,0);
      }
      
      public static function Clear() : void
      {
         _sprites = null;
      }
      
      public static function SetupSprite(param1:String) : void
      {
         ImageCache.GetImageWithCallBack(_sprites[param1].key,onAssetLoaded);
      }
      
      public static function GetSpriteDescriptor(param1:String) : Object
      {
         return _sprites[param1];
      }
      
      private static function onAssetLoaded(param1:String, param2:BitmapData) : void
      {
         var _loc3_:SpriteData = null;
         for each(_loc3_ in _sprites)
         {
            if(_loc3_.key == param1)
            {
               _loc3_.image = param2;
            }
         }
      }
      
      public static function GetSprite(param1:BitmapData, param2:String, param3:String, param4:int, param5:int = 0, param6:int = -1) : int
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!GLOBAL._render)
         {
            return -1;
         }
         if(param4 < 0)
         {
            param4 = 360 + param4;
         }
         if(param2 == "worker")
         {
            if(STORE._storeData.BST)
            {
               if(param6 != param4 / 12)
               {
                  GetFrame(param1,_sprites.worker,param4 / 12,1);
               }
               return param4 / 12 + 30;
            }
            if(param6 != param4 / 12)
            {
               GetFrame(param1,_sprites.worker,param4 / 12,0);
            }
            return param4 / 12;
         }
         if(param2 == "C9")
         {
            if(param3 == "invisible")
            {
               if(param6 != param4 / 12 + 30)
               {
                  GetFrame(param1,_sprites.C9,param4 / 12,1);
               }
               return param4 / 12 + 30;
            }
            if(param6 != param4 / 12)
            {
               GetFrame(param1,_sprites.C9,param4 / 12,0);
            }
            return param4 / 12;
         }
         if(param2 == "C12")
         {
            if(param6 != param4 * 0.083333333)
            {
               GetFrame(param1,_sprites.C12,param4 * 0.083333333);
            }
            return param4 * 0.083333333;
         }
         if(param2 == "C13")
         {
            if(param3 == "walking")
            {
               if(param6 != param4 / 12)
               {
                  GetFrame(param1,_sprites.C13,param4 / 12);
               }
               return param4 / 12;
            }
            if(param3 == "burrowed")
            {
               if(param6 != 33)
               {
                  GetFrame(param1,_sprites.C13,param4 / 12,4);
               }
               return 33;
            }
            if(param3 == "transition")
            {
               if(param6 != 34)
               {
                  GetFrame(param1,_sprites.C13,param4 / 12,param5);
               }
               return 34;
            }
         }
         if(param2 == "C14")
         {
            if(param6 != param4 / 11.25 + param5 % 9 / 3 * 32)
            {
               GetFrame(param1,_sprites.C14,int(param4 / 11.25),param5 % 9 / 3);
            }
            return param4 / 11.25 + param5 % 9 / 3 * 32;
         }
         if(param2 == "C16")
         {
            if(param6 != param4 / 11.25 + param5 % 9 / 3 * 32)
            {
               GetFrame(param1,_sprites.C16,int(param4 / 11.25),param5 % 9 / 3);
            }
            return param4 / 11.25 + param5 % 9 / 3 * 32;
         }
         if(param2 == "C19")
         {
            if(param3 == "idle")
            {
               if(param6 != param4 / 12)
               {
                  GetFrame(param1,_sprites.C19,param4 / 12,1);
               }
            }
            else if(param3 == "moving")
            {
               if(param6 != param4 / 12)
               {
                  GetFrame(param1,_sprites.C19,param4 / 12,param5 / 8 % 5 + 1);
               }
            }
            return param4 / 12;
         }
         if(param2 == "C15")
         {
            if(param6 != param4 / 11.25)
            {
               GetFrame(param1,_sprites.C15,int(param4 / 11.25));
            }
            return param4 / 11.25;
         }
         if(param2 == "IC1")
         {
            if(param6 != param4 / 11.25)
            {
               GetFrame(param1,_sprites.IC1,param4 / 11.25,param5 / 8 % 2 + 1);
            }
            return param4 / 11.25;
         }
         if(param2 == "IC3")
         {
            if(param6 != param4 / 12)
            {
               GetFrame(param1,_sprites.IC3,param4 / 12,param5 / 8 % 8 + 1);
            }
            return param4 / 12;
         }
         if(param2 == "IC5")
         {
            if(param6 != param4 / 12)
            {
               GetFrame(param1,_sprites.IC5,param4 / 12,param5 / 8 % 6 + 1);
            }
            return param4 / 12;
         }
         if(param2.substr(0,2) == "G1" || param2.substr(0,2) == "G2")
         {
            if(_sprites[param2])
            {
               if(param3 == "idle")
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5));
               }
               else if(param3 == "walking")
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 7 + 1);
               }
               else if(param3 == GLOBAL.e_BASE_MODE.ATTACK)
               {
                  if((_loc7_ = param2.substr(3,1)) == "4" || _loc7_ == "5" || _loc7_ == "6")
                  {
                     GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 8 + 8);
                  }
                  else
                  {
                     GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 7 + 8);
                  }
               }
               return param4 / 22.5;
            }
         }
         if(param2.substr(0,2) == "G3")
         {
            if(_sprites[param2])
            {
               if(param3 == "idle")
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5));
               }
               else if((_loc7_ = param2.substr(3,1)) == "1")
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 7 + 1);
               }
               else if(_loc7_ == "2")
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 8 + 1);
               }
               else
               {
                  GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 6 + 1);
               }
               return param4 / 22.5;
            }
         }
         if(param2.substr(0,2) == "G4" && Boolean(_sprites[param2]))
         {
            if(param3 == "idle")
            {
               GetFrame(param1,_sprites[param2],int(param4 / 22.5));
            }
            else if(param3 == "walking")
            {
               _loc8_ = int(param2.substr(3,1));
               _loc9_ = 8;
               if(_loc8_ == 3)
               {
                  _loc9_ = 9;
               }
               else if(_loc8_ > 3)
               {
                  _loc9_ = 10;
               }
               GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % _loc9_ + 0);
            }
            else if(param3 == GLOBAL.e_BASE_MODE.ATTACK)
            {
               _loc8_ = int(param2.substr(3,1));
               switch(_loc8_)
               {
                  case 1:
                     _loc9_ = 9;
                     _loc10_ = 8;
                     break;
                  case 2:
                     _loc9_ = 9;
                     _loc10_ = 8;
                     break;
                  case 3:
                     _loc9_ = 10;
                     _loc10_ = 9;
                     break;
                  case 4:
                     _loc9_ = 10;
                     _loc10_ = 10;
                     break;
                  case 5:
                     _loc9_ = 10;
                     _loc10_ = 10;
                     break;
                  case 6:
                     _loc9_ = 10;
                     _loc10_ = 10;
               }
               GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % _loc9_ + _loc10_);
            }
            else if(param3 == "stomp")
            {
               GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % 10 + 20);
            }
            return param4 / 22.5;
         }
         if(param2.substr(0,2) == "G5" && Boolean(_sprites[param2]))
         {
            if(param3 == "walking" || param3 == "idle")
            {
               _loc9_ = 10;
               GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % _loc9_ + 0);
            }
            else if(param3 == GLOBAL.e_BASE_MODE.ATTACK)
            {
               _loc8_ = int(param2.substr(3,1));
               switch(_loc8_)
               {
                  case 1:
                     _loc9_ = 6;
                     _loc10_ = 10;
                     break;
                  case 2:
                     _loc9_ = 6;
                     _loc10_ = 10;
                     break;
                  case 3:
                     _loc9_ = 6;
                     _loc10_ = 10;
               }
               GetFrame(param1,_sprites[param2],int(param4 / 22.5),param5 / 8 % _loc9_ + _loc10_);
            }
            return param4 / 22.5;
         }
         if(param2 == "shadow")
         {
            GetFrame(param1,_sprites.shadow,0);
            return 0;
         }
         if(param2 == "bigshadow")
         {
            GetFrame(param1,_sprites.bigshadow,0);
            return 0;
         }
         if(param2 == "C200")
         {
            if(param3 == "empty")
            {
               GetFrame(param1,_sprites.C200,param4 / 12);
            }
            else
            {
               GetFrame(param1,_sprites.C200,param4 / 12,1);
            }
            return param4 / 12;
         }
         if(param2 == "rocket")
         {
            if(param6 != param4 / 11.25)
            {
               GetFrame(param1,_sprites.rocket,param4 / 11.25);
            }
            return param4 / 11.25;
         }
         if(param2 == SpurtzCannon.SPURTZ_PROJECTILE)
         {
            if(param6 != param4 / 11.25)
            {
               GetFrame(param1,_sprites[SpurtzCannon.SPURTZ_PROJECTILE],param4 / 11.25,param5 / 8 % 2 + 1);
            }
            return param4 / 11.25;
         }
         if(_sprites[param2])
         {
            if(param6 != param4 / 12)
            {
               GetFrame(param1,_sprites[param2],param4 / 12);
            }
            return param4 / 12;
         }
         print("could not get frame " + param2);
         return 0;
      }
      
      public static function GetFrame(param1:BitmapData, param2:SpriteData, param3:int, param4:int = 0) : void
      {
         if(Boolean(param2) && Boolean(param2.image))
         {
            param2.rect.x = param2.rect.width * param3;
            param2.rect.y = param2.rect.height * param4;
            if(param1)
            {
               param1.copyPixels(param2.image,param2.rect,param2.offset);
            }
            else
            {
               print("passed in a null canvas",true);
            }
         }
      }
      
      public static function GetFrameById(param1:BitmapData, param2:String, param3:int, param4:int = 0) : void
      {
         GetFrame(param1,_sprites[param2],param3,param4);
      }
   }
}
