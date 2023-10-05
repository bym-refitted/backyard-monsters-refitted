package com.monsters.effects
{
   import com.monsters.configs.BYMConfig;
   import com.monsters.rendering.RasterData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import gs.TweenLite;
   import gs.easing.Sine;
   
   internal class ResourceBombParticle
   {
      
      public static const k_TYPE_TWIGS:uint = 1;
      
      public static const k_TYPE_PEBBLE:uint = 2;
      
      public static const k_TYPE_PUTTY:uint = 3;
       
      
      private var mc:DisplayObject;
      
      private var container:MovieClip;
      
      private var bmd_frame:BitmapData;
      
      private var mctop:MovieClip;
      
      private var mcbottom:MovieClip;
      
      private var animframe:int;
      
      private var variation:int;
      
      private var m_position:Point;
      
      private var m_bomb:com.monsters.effects.ResourceBomb;
      
      private var m_id:String;
      
      private var m_resourceId:int;
      
      private var m_rasterData:RasterData;
      
      private var m_rasterPt:Point;
      
      private var m_cleared:Boolean;
      
      public function ResourceBombParticle(param1:MovieClip, param2:MovieClip, param3:Point, param4:com.monsters.effects.ResourceBomb, param5:String, param6:int, param7:int)
      {
         super();
         this.mctop = param1;
         this.mcbottom = param2;
         this.m_position = param3;
         this.m_bomb = param4;
         this.m_id = param5;
         this.m_resourceId = param7;
         this.m_cleared = false;
         var _loc8_:Point = new Point();
         switch(this.m_resourceId)
         {
            case k_TYPE_TWIGS:
               this.variation = int(Math.random() * 5);
               this.bmd_frame = new BitmapData(24,30,true,16777215);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_twigs,new Rectangle(24 * this.variation,0,24,30),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mctop.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.mc = new Bitmap(this.bmd_frame);
               }
               _loc8_.x = -12;
               _loc8_.y = -15;
               break;
            case k_TYPE_PEBBLE:
               this.variation = int(Math.random() * 18);
               this.bmd_frame = new BitmapData(27,17,true,16777215);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_pebble,new Rectangle(27 * this.variation,0,27,17),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mctop.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.mc = new Bitmap(this.bmd_frame);
               }
               _loc8_.x = -40;
               _loc8_.y = -42;
               break;
            case k_TYPE_PUTTY:
               this.bmd_frame = new BitmapData(81,52,true,16777215);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_putty,new Rectangle(0,0,81,52),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mctop.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.mc = new Bitmap(this.bmd_frame);
               }
               _loc8_.x = -40;
               _loc8_.y = -26;
         }
         this.mc.x = param3.x + 100 + _loc8_.x;
         this.mc.y = param3.y - GLOBAL.StageHeight + _loc8_.y;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            this.mc.cacheAsBitmap = true;
         }
         else
         {
            this.m_rasterPt = new Point(this.mc.x - MAP.instance.offset.x + this.mctop.x,this.mc.y - MAP.instance.offset.y + this.mctop.y);
            this.m_rasterData = new RasterData(this.bmd_frame,this.m_rasterPt,int.MAX_VALUE);
            this.m_rasterData.visible = false;
         }
         this.mc.visible = false;
         if(!BYMConfig.instance.RENDERER_ON)
         {
            if(param7 == k_TYPE_PUTTY)
            {
               TweenLite.to(this.mc,0.3 + Math.random() * 0.5,{
                  "delay":1,
                  "x":param3.x,
                  "y":param3.y,
                  "onStart":this.Add,
                  "onComplete":this.Hit,
                  "ease":Sine.easeIn
               });
            }
            else
            {
               TweenLite.to(this.mc,0.3 + Math.random() * 0.5,{
                  "delay":1 + Math.random() * (param6 * 2),
                  "x":param3.x,
                  "y":param3.y,
                  "onStart":this.Add,
                  "onComplete":this.Hit,
                  "ease":Sine.easeIn
               });
            }
         }
         else if(param7 == k_TYPE_PUTTY)
         {
            TweenLite.to(this.m_rasterPt,0.3 + Math.random() * 0.5,{
               "delay":1,
               "x":param3.x - MAP.instance.offset.x + this.mctop.x,
               "y":param3.y - MAP.instance.offset.y + this.mctop.y,
               "onStart":this.Add,
               "onComplete":this.Hit,
               "ease":Sine.easeIn
            });
         }
         else
         {
            TweenLite.to(this.m_rasterPt,0.3 + Math.random() * 0.5,{
               "delay":1 + Math.random() * (param6 * 2),
               "x":param3.x - MAP.instance.offset.x + this.mctop.x,
               "y":param3.y - MAP.instance.offset.y + this.mctop.y,
               "onStart":this.Add,
               "onComplete":this.Hit,
               "ease":Sine.easeIn
            });
         }
      }
      
      protected function Add() : void
      {
         if(!BYMConfig.instance.RENDERER_ON)
         {
            this.mc.visible = true;
         }
         else
         {
            this.m_rasterData.visible = true;
         }
      }
      
      protected function Hit() : void
      {
         if(this.m_cleared)
         {
            return;
         }
         if(!BYMConfig.instance.RENDERER_ON)
         {
            this.mctop.removeChild(this.mc);
         }
         this.animframe = 0;
         var _loc1_:Point = new Point(0,0);
         this.m_bomb.Damage(this.m_position);
         switch(this.m_resourceId)
         {
            case k_TYPE_TWIGS:
               this.bmd_frame.copyPixels(ResourceBombs.bmd_twigs,new Rectangle(24 * this.variation,30,24,30),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mcbottom.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.m_rasterData.data = this.bmd_frame;
               }
               _loc1_.x = -12;
               _loc1_.y = -15;
               this.m_bomb.RemoveParticle(this.m_id);
               break;
            case k_TYPE_PEBBLE:
               this.variation = int(Math.random() * 4);
               this.bmd_frame = new BitmapData(80,85,true,16777215);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_pebblehit,new Rectangle(0,85 * this.variation,80,85),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mcbottom.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.m_rasterData.data = this.bmd_frame;
               }
               _loc1_.x = -40;
               _loc1_.y = -50;
               this.mc.addEventListener(Event.ENTER_FRAME,this.Anim);
               break;
            default:
               this.variation = int(Math.random() * 4);
               this.bmd_frame = new BitmapData(81,52,true,16777215);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_putty,new Rectangle(0,81 * this.variation,81,52),new Point(0,0));
               if(!BYMConfig.instance.RENDERER_ON)
               {
                  this.mc = this.mcbottom.addChild(new Bitmap(this.bmd_frame));
               }
               else
               {
                  this.m_rasterData.data = this.bmd_frame;
               }
               _loc1_.x = -40;
               _loc1_.y = -26;
               this.mc.addEventListener(Event.ENTER_FRAME,this.Anim);
         }
         if(!this.m_cleared)
         {
            this.mc.x = this.m_position.x + _loc1_.x;
            this.mc.y = this.m_position.y + _loc1_.y;
            if(BYMConfig.instance.RENDERER_ON)
            {
               this.m_rasterPt.x = this.mc.x - MAP.instance.offset.x - this.mctop.x;
               this.m_rasterPt.y = this.mc.y - MAP.instance.offset.y - this.mctop.y;
            }
         }
      }
      
      protected function Anim(param1:Event) : void
      {
         var _loc3_:Rectangle = null;
         if(this.m_cleared)
         {
            return;
         }
         var _loc2_:int = 20;
         if(this.m_resourceId == 2)
         {
            if(this.animframe == 20)
            {
               this.mc.removeEventListener(Event.ENTER_FRAME,this.Anim);
               this.m_bomb.RemoveParticle(this.m_id);
            }
            else
            {
               _loc3_ = new Rectangle(80 * this.animframe,85 * this.variation,80,85);
               this.bmd_frame.copyPixels(ResourceBombs.bmd_pebblehit,_loc3_,new Point(0,0));
               if(BYMConfig.instance.RENDERER_ON)
               {
                  this.m_rasterData.data = this.bmd_frame;
               }
               ++this.animframe;
            }
         }
         else if(this.animframe == 14)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.Anim);
            this.m_bomb.RemoveParticle(this.m_id);
         }
         else
         {
            _loc3_ = new Rectangle(81 * this.animframe,81 * this.variation,81,52);
            this.bmd_frame.copyPixels(ResourceBombs.bmd_putty,_loc3_,new Point(0,0));
            if(BYMConfig.instance.RENDERER_ON)
            {
               this.m_rasterData.data = this.bmd_frame;
            }
            ++this.animframe;
         }
      }
      
      public function clear() : void
      {
         if(this.m_cleared)
         {
            return;
         }
         if(BYMConfig.instance.RENDERER_ON)
         {
            if(this.m_resourceId !== k_TYPE_TWIGS)
            {
               MAP.effectsBMD.copyPixels(this.bmd_frame,this.bmd_frame.rect,this.m_rasterPt);
            }
            if(this.m_rasterData)
            {
               this.m_rasterData.clear();
            }
            this.m_rasterData = null;
            this.m_rasterPt = null;
         }
         if(this.bmd_frame)
         {
            this.bmd_frame.dispose();
         }
         this.mc = null;
         this.container = null;
         this.bmd_frame = null;
         this.mctop = null;
         this.mcbottom = null;
         this.m_position = null;
         this.m_bomb = null;
         this.m_cleared = true;
      }
   }
}
