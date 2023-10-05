package com.monsters.display
{
   import com.monsters.configs.BYMConfig;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.getTimer;
   
   public class BuildingOverlay
   {
      
      private static const k_SHOW_DEBUG_HEALTH:Boolean = false;
      
      private static var debugHealth:TextField;
      
      private static var _buildings:Object = {};
      
      private static var _bmdHPbarLarge:BitmapData = new bmp_healthbarlarge(0,0);
      
      private static var _bmdHPbarSmall:BitmapData = new bmp_healthbarsmall(0,0);
      
      private static var _bmpProgressBarLarge:BitmapData = new bmp_progressbarlarge(0,0);
      
      private static var _bmpOverlayText:BitmapData = new bmp_overlaytext(0,0);
      
      private static var _isSetup:Boolean = false;
      
      private static var u_bmd:BitmapData;
      
      private static var r_bmd:BitmapData;
      
      private static var b_bmd:BitmapData;
      
      private static var f_bmd:BitmapData;
      
      private static var labelWidth:int;
      
      private static var _textDO:DisplayObject;
       
      
      public function BuildingOverlay()
      {
         super();
      }
      
      public static function Setup(param1:BFOUNDATION) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Sprite = null;
         var _loc4_:Point = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:BitmapData = null;
         _loc4_ = param1._overlayOffset;
         if(!_isSetup)
         {
            _isSetup = true;
            labelWidth = 0;
            _loc5_ = [new GlowFilter(0,1,2,2,4,1)];
            u_bmd = ImageText.Get(KEYS.Get("bdg_state_upgrading"),9,0.6,_loc5_);
            r_bmd = ImageText.Get(KEYS.Get("bdg_state_repairing"),9,0.6,_loc5_);
            b_bmd = ImageText.Get(KEYS.Get("bdg_state_building"),9,0.6,_loc5_);
            f_bmd = ImageText.Get(KEYS.Get("bdg_state_fortifying"),9,0.6,_loc5_);
            _loc6_ = [u_bmd,r_bmd,b_bmd,f_bmd];
            for each(_loc7_ in _loc6_)
            {
               labelWidth = labelWidth > _loc7_.width ? labelWidth : _loc7_.width;
            }
         }
         _buildings[param1._id] = {
            "container":new Sprite(),
            "bmdtext":new BitmapData(labelWidth,21,true,16777215),
            "bmdprogress":new BitmapData(51,6,true,16777215),
            "bmdhp":new BitmapData(51,6,true,16777215),
            "indextext":"",
            "indexprogress":-1,
            "indexhp":-1
         };
         _loc3_ = _buildings[param1._id].container;
         _loc3_.mouseEnabled = false;
         _loc3_.mouseChildren = false;
         _loc2_ = _loc3_.addChild(new Bitmap(_buildings[param1._id].bmdtext));
         _loc2_.x = -26 + _loc4_.x + (51 - labelWidth) * 0.5;
         _loc2_.y = -32 + _loc4_.y;
         _loc2_ = _loc3_.addChild(new Bitmap(_buildings[param1._id].bmdprogress));
         _loc2_.x = -26 + _loc4_.x;
         _loc2_.y = -20 + _loc4_.y;
         _loc2_ = _loc3_.addChild(new Bitmap(_buildings[param1._id].bmdhp));
         _loc2_.x = -26 + _loc4_.x;
         _loc2_.y = -14 + _loc4_.y;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            param1._mc.addChild(_loc3_);
         }
         else
         {
            _loc3_.x = param1._mc.x;
            _loc3_.y = param1._mc.y;
            MAP._BUILDINGTOPS.addChild(_loc3_);
         }
         if(GLOBAL._aiDesignMode && k_SHOW_DEBUG_HEALTH)
         {
            debugHealth = new TextField();
            debugHealth.defaultTextFormat = new TextFormat("Arial",10,16777215,true);
         }
         Update(param1);
      }
      
      public static function Update(param1:BFOUNDATION, param2:Boolean = false) : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:Sprite = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc3_:int = -1;
         var _loc4_:String = "";
         var _loc7_:int = getTimer();
         if(!_buildings[param1._id])
         {
            Setup(param1);
         }
         _loc8_ = _buildings[param1._id];
         if(GLOBAL._render)
         {
            if(BYMConfig.instance.RENDERER_ON)
            {
               (_loc9_ = _buildings[param1._id].container).x = param1._mc.x;
               _loc9_.y = param1._mc.y;
            }
            if(param1._repairing)
            {
               _loc3_ = 49 / param1.maxHealth * param1.health;
               _loc4_ = "repairing";
            }
            else if(param1._countdownBuild.Get() > 0)
            {
               if(param1._prefab)
               {
                  _loc10_ = 0;
                  _loc11_ = 0;
                  while(_loc11_ < param1._prefab)
                  {
                     _loc10_ += GLOBAL._buildingProps[param1._type - 1].costs[_loc11_].time;
                     _loc11_++;
                  }
                  _loc6_ = _loc10_;
               }
               else
               {
                  _loc6_ = int(param1._buildingProps.costs[param1._lvl.Get()].time);
               }
               _loc3_ = 49 / _loc6_ * (_loc6_ - param1._countdownBuild.Get());
               _loc4_ = "building";
            }
            else if(param1._countdownUpgrade.Get() > 0)
            {
               _loc6_ = int(param1._buildingProps.costs[param1._lvl.Get()].time);
               _loc3_ = 49 / _loc6_ * (_loc6_ - param1._countdownUpgrade.Get());
               _loc4_ = "upgrading";
            }
            else if(param1._countdownFortify.Get() > 0)
            {
               if(param1._buildingProps.fortify_costs[param1._fortification.Get()])
               {
                  _loc6_ = int(param1._buildingProps.fortify_costs[param1._fortification.Get()].time);
                  _loc3_ = 49 / _loc6_ * (_loc6_ - param1._countdownFortify.Get());
                  _loc4_ = "fortifying";
               }
            }
            if(_loc4_ != _loc8_.indextext || param2)
            {
               _loc8_.indextext = _loc4_;
               _loc5_ = _loc8_.bmdtext;
               if(_loc4_ == "repairing")
               {
                  _loc5_.copyPixels(r_bmd,new Rectangle(0,0,r_bmd.width,r_bmd.height),new Point((labelWidth - r_bmd.width) * 0.5,-1));
               }
               if(_loc4_ == "building")
               {
                  _loc5_.copyPixels(b_bmd,new Rectangle(0,0,b_bmd.width,b_bmd.height),new Point((labelWidth - b_bmd.width) * 0.5,-1));
               }
               if(_loc4_ == "upgrading")
               {
                  _loc5_.copyPixels(u_bmd,new Rectangle(0,0,u_bmd.width,u_bmd.height),new Point((labelWidth - u_bmd.width) * 0.5,-1));
               }
               if(_loc4_ == "fortifying")
               {
                  _loc5_.copyPixels(f_bmd,new Rectangle(0,0,f_bmd.width,f_bmd.height),new Point((labelWidth - f_bmd.width) * 0.5,-1));
               }
            }
            if(_loc3_ == -1)
            {
               if(_loc8_.indexprogress != -1)
               {
                  _loc8_.indexprogress = -1;
                  _loc5_ = _loc8_.bmdtext;
                  _loc5_.fillRect(_loc5_.rect,0);
                  _loc5_ = _loc8_.bmdprogress;
                  _loc5_.fillRect(_loc5_.rect,0);
               }
            }
            else if(_loc3_ != _loc8_.indexprogress)
            {
               _loc8_.indexprogress = _loc3_;
               _loc5_ = _loc8_.bmdprogress;
               if(param1._repairing)
               {
                  _loc5_.fillRect(_loc5_.rect,0);
               }
               else
               {
                  _loc5_.copyPixels(_bmpProgressBarLarge,new Rectangle(0,6 * _loc3_,51,6),new Point(0,0));
               }
            }
            if(debugHealth)
            {
               debugHealth.text = param1.health + "/" + param1.maxHealth;
               debugHealth.visible = param1.isDamaged;
               param1.graphic.addChild(debugHealth);
            }
            if(param1.health <= 0)
            {
               _loc8_.indexhp = -1;
               _loc5_ = _loc8_.bmdhp;
               _loc5_.fillRect(_loc5_.rect,0);
            }
            else if(param1.health < param1.maxHealth)
            {
               _loc3_ = 19 - int(19 / param1.maxHealth * param1.health);
               if(_loc3_ != _loc8_.indexhp)
               {
                  _loc8_.indexhp = _loc3_;
                  (_loc5_ = _loc8_.bmdhp).copyPixels(_bmdHPbarLarge,new Rectangle(0,6 * _loc3_,51,6),new Point(0,0));
               }
            }
            else if(_loc8_.indexhp != -1)
            {
               _loc8_.indexhp = -1;
               _loc5_ = _loc8_.bmdhp;
               _loc5_.fillRect(_loc5_.rect,0);
            }
         }
      }
      
      public static function clearBuilding(param1:BFOUNDATION) : void
      {
         var _loc2_:Object = _buildings[param1._id];
         if(!_loc2_)
         {
            return;
         }
         clearOverlay(_loc2_);
         delete _buildings[param1._id];
      }
      
      protected static function clearOverlay(param1:Object) : void
      {
         if(Boolean(param1.container) && param1.container.parent == MAP._BUILDINGTOPS)
         {
            MAP._BUILDINGTOPS.removeChild(param1.container);
         }
         if(param1.bmdtext is BitmapData)
         {
            param1.bmdtext.dispose();
         }
         if(param1.bmdprogress is BitmapData)
         {
            param1.bmdprogress.dispose();
         }
         if(param1.bmdhp is BitmapData)
         {
            param1.bmdhp.dispose();
         }
         param1.container = null;
         param1.indextext = null;
      }
      
      public static function Clear() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in _buildings)
         {
            clearOverlay(_loc1_);
         }
         _buildings = {};
      }
   }
}
