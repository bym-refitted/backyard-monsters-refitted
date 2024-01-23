package com.monsters.maproom3.bookmarks
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import gs.TweenLite;
   
   public class BookmarksExpandableFrame extends MapRoom3ExpandableFrame
   {
       
      
      private const EXPAND_TWEEN_TIME:Number = 0.5;
      
      private var m_Contents:Sprite;
      
      private var m_MaxExpandedHeight:uint;
      
      private var m_ExpandUp:Boolean = false;
      
      private var m_Expanded:Boolean = true;
      
      public function BookmarksExpandableFrame(param1:Sprite, param2:String, param3:int = -1, param4:Boolean = false)
      {
         super();
         headerText.htmlText = param2;
         headerText.mouseEnabled = false;
         this.m_Contents = param1;
         contentsContainer.addChild(this.m_Contents);
         contentsContainer.mask = background;
         this.m_MaxExpandedHeight = param3 != -1 ? uint(param3) : uint(this.m_Contents.height);
         this.m_ExpandUp = param4;
         if(this.m_ExpandUp == true)
         {
            this.y -= this.m_MaxExpandedHeight + frameFooter.height;
         }
         var _loc5_:int = BASE.isInfernoMainYardOrOutpost ? 2 : 1;
         frameHeader.gotoAndStop(_loc5_);
         frameBorders.gotoAndStop(_loc5_);
         frameFooter.gotoAndStop(_loc5_);
         frameBorders.mouseEnabled = false;
         frameBorders.mouseChildren = false;
         this.Collapse(false);
         collapseExpandButton.visible = this.m_MaxExpandedHeight > 0;
         collapseExpandButton.buttonMode = true;
         collapseExpandButton.addEventListener(MouseEvent.CLICK,this.OnCollapseExpandButtonClicked,false,0,true);
      }
      
      public function Clear() : void
      {
         collapseExpandButton.removeEventListener(MouseEvent.CLICK,this.OnCollapseExpandButtonClicked);
         contentsContainer.removeChild(this.m_Contents);
         this.m_Contents = null;
      }
      
      private function OnCollapseExpandButtonClicked(param1:MouseEvent) : void
      {
         if(this.m_Expanded)
         {
            this.Collapse();
         }
         else
         {
            this.Expand();
         }
      }
      
      private function Expand(param1:Boolean = true) : void
      {
         if(this.m_Expanded == true)
         {
            return;
         }
         if(this.m_ExpandUp)
         {
            this.ExpandUp(param1);
         }
         else
         {
            this.ExpandDown(param1);
         }
         collapseExpandButton.gotoAndStop(2);
         this.m_Expanded = true;
      }
      
      private function Collapse(param1:Boolean = true) : void
      {
         if(this.m_Expanded == false)
         {
            return;
         }
         if(this.m_ExpandUp)
         {
            this.CollapseDown(param1);
         }
         else
         {
            this.CollapseUp(param1);
         }
         collapseExpandButton.gotoAndStop(1);
         this.m_Expanded = false;
      }
      
      private function ExpandDown(param1:Boolean = true) : void
      {
         var _loc2_:Number = param1 ? this.EXPAND_TWEEN_TIME : 0;
         var _loc3_:Number = frameHeader.y + frameHeader.height + this.m_MaxExpandedHeight;
         TweenLite.to(background,_loc2_,{"height":this.m_MaxExpandedHeight});
         TweenLite.to(frameBorders,_loc2_,{"height":this.m_MaxExpandedHeight});
         TweenLite.to(frameFooter,_loc2_,{"y":_loc3_});
      }
      
      private function CollapseUp(param1:Boolean = true) : void
      {
         var _loc2_:Number = param1 ? this.EXPAND_TWEEN_TIME : 0;
         var _loc3_:Number = frameHeader.y + frameHeader.height - frameFooter.height;
         TweenLite.to(background,_loc2_,{"height":0});
         TweenLite.to(frameBorders,_loc2_,{"height":0});
         TweenLite.to(frameFooter,_loc2_,{"y":_loc3_});
      }
      
      private function ExpandUp(param1:Boolean = true) : void
      {
         var _loc2_:Number = param1 ? this.EXPAND_TWEEN_TIME : 0;
         TweenLite.to(this,_loc2_,{"y":y - (this.m_MaxExpandedHeight + frameFooter.height)});
         this.ExpandDown(param1);
      }
      
      private function CollapseDown(param1:Boolean = true) : void
      {
         var _loc2_:Number = param1 ? this.EXPAND_TWEEN_TIME : 0;
         TweenLite.to(this,_loc2_,{"y":y + (this.m_MaxExpandedHeight + frameFooter.height)});
         this.CollapseUp(param1);
      }
   }
}
