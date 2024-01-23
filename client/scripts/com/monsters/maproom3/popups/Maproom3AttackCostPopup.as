package com.monsters.maproom3.popups
{
   import com.cc.utils.SecNum;
   import com.monsters.maproom3.MapRoom3Cell;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   public class Maproom3AttackCostPopup extends EventDispatcher
   {
      
      public static const k_LOAD_ATTACK:String = "loadAttack";
       
      
      public var addtionalLoadParameters:Object;
      
      private var m_graphic:attackCostPopup;
      
      private var m_cell:MapRoom3Cell;
      
      private var m_shinyCost:Number;
      
      private var m_totalNeededResources:uint;
      
      public function Maproom3AttackCostPopup(param1:MapRoom3Cell)
      {
         super();
         this.m_graphic = new attackCostPopup();
         this.m_cell = param1;
         this.setup();
      }
      
      private function setup() : void
      {
         var _loc2_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:icon_costs = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc1_:Array = this.m_cell.attackCost;
         var _loc3_:int = 1;
         while(_loc3_ < 5)
         {
            _loc4_ = Number(_loc1_[_loc3_ - 1]);
            _loc5_ = Number(GLOBAL._attackersResources["r" + _loc3_].Get());
            if((_loc6_ = _loc4_ - _loc5_) > 0)
            {
               this.m_totalNeededResources += _loc6_;
            }
            _loc2_ += _loc4_;
            _loc3_++;
         }
         this.m_shinyCost = STORE.GetShinyCostFromTotalResources(_loc2_);
         this.m_graphic.tBody.htmlText = KEYS.Get("msg_attackcost",{"v1":this.m_cell.name});
         this.m_graphic.mcInstant.tDescription.htmlText = KEYS.Get("msg_attackinstant");
         this.m_graphic.mcInstant.bAction.Setup(KEYS.Get("btn_useshiny",{"v1":this.m_shinyCost}));
         this.m_graphic.mcInstant.bAction.addEventListener(MouseEvent.CLICK,this.clickedShinyAttack,false,0,true);
         this.m_graphic.mcResources.bAction.Setup(KEYS.Get("btn_useresources"));
         _loc3_ = 1;
         while(_loc3_ < 6)
         {
            _loc7_ = this.m_graphic.mcResources.getChildByName("mcR" + _loc3_) as icon_costs;
            _loc8_ = int(_loc1_[_loc3_ - 1]);
            if(_loc7_)
            {
               _loc9_ = GLOBAL._attackersResources["r" + _loc3_].Get() < _loc8_ ? "FF0000" : "000000";
               if(!_loc8_)
               {
                  _loc7_.alpha = 0.25;
               }
               _loc7_.gotoAndStop(_loc3_);
               _loc7_.tValue.htmlText = "<b><font color=\"#" + _loc9_ + "\">" + GLOBAL.FormatNumber(_loc8_) + "</font></b>";
               _loc7_.tTitle.htmlText = "<b>" + KEYS.Get(GLOBAL._resourceNames[_loc3_ - 1]) + "</b>";
            }
            _loc3_++;
         }
         this.m_graphic.mcResources.mcTime.visible = false;
         this.m_graphic.mcResources.bAction.addEventListener(MouseEvent.CLICK,this.clickedResourceAttack,false,0,true);
      }
      
      protected function clickedShinyAttack(param1:MouseEvent) : void
      {
         if(BASE._pendingPurchase.length == 0)
         {
            if(Boolean(this.m_shinyCost) && this.m_shinyCost > BASE._credits.Get())
            {
               POPUPS.Next();
               POPUPS.DisplayGetShiny();
            }
            else
            {
               this.addtionalLoadParameters = {"shiny":this.m_shinyCost};
               dispatchEvent(new Event(k_LOAD_ATTACK));
            }
         }
      }
      
      protected function clickedResourceAttack(param1:MouseEvent = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:SecNum = null;
         if(this.m_totalNeededResources)
         {
            _loc2_ = uint(STORE.GetShinyCostFromTotalResources(this.m_totalNeededResources));
            GLOBAL.Message(KEYS.Get("msg_needresourcesattack",{
               "v1":GLOBAL.FormatNumber(this.m_totalNeededResources),
               "v2":GLOBAL.FormatNumber(_loc2_)
            }),KEYS.Get("btn_getresources"),this.clickedResourceTopoff);
         }
         else
         {
            _loc3_ = this.m_cell.attackCost;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = GLOBAL._resources["r" + (_loc4_ + 1)];
               GLOBAL._resources["r" + (_loc4_ + 1)] = new SecNum(_loc5_.Get() - _loc3_[_loc4_]);
               _loc4_++;
            }
            this.addtionalLoadParameters = {"resources":_loc3_};
            dispatchEvent(new Event(k_LOAD_ATTACK));
         }
      }
      
      private function clickedResourceTopoff() : void
      {
         var _loc1_:uint = uint(STORE.GetShinyCostFromTotalResources(this.m_totalNeededResources));
         if(BASE._pendingPurchase.length == 0)
         {
            if(Boolean(_loc1_) && _loc1_ > BASE._credits.Get())
            {
               POPUPS.DisplayGetShiny();
            }
            else
            {
               this.addtionalLoadParameters = {"shiny":_loc1_};
               dispatchEvent(new Event(k_LOAD_ATTACK));
            }
         }
      }
      
      public function get graphic() : attackCostPopup
      {
         return this.m_graphic;
      }
   }
}
