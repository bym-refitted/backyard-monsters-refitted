package com.monsters.baseplanner
{
   import com.monsters.baseplanner.components.BuildingItem;
   import com.monsters.baseplanner.events.BasePlannerEvent;
   import com.monsters.baseplanner.events.BasePlannerServiceEvent;
   import com.monsters.baseplanner.events.BasePlannerTransferEvent;
   import com.monsters.baseplanner.popups.BasePlannerPopup;
   import com.monsters.baseplanner.popups.transfer.BasePlannerLoadPopup;
   import com.monsters.baseplanner.popups.transfer.BasePlannerSavePopup;
   import com.monsters.baseplanner.popups.transfer.BasePlannerTransferPopup;
   import com.monsters.managers.InstanceManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class BasePlanner
   {
      
      public static const TYPE:uint = 10;
      
      public static var canSave:Boolean = true;
      
      public static const DEFAULT_NUMBER_OF_SLOTS:uint = 2;
      
      public static var slots:uint = DEFAULT_NUMBER_OF_SLOTS;
      
      public static var maxNumberOfSlots:uint = DEFAULT_NUMBER_OF_SLOTS;
       
      
      public var popup:BasePlannerPopup;
      
      public var service:BasePlannerService;
      
      private var _templates:Vector.<BaseTemplate>;
      
      private var _activeTemplate:PlannerTemplate;
      
      private var _transferPopup:BasePlannerTransferPopup;
      
      public function BasePlanner()
      {
         super();
      }
      
      public function setup(param1:Boolean = true) : void
      {
         canSave = !BASE.isOutpost;
         this.service = new BasePlannerService();
         this.service.loadTemplates();
         this.service.addEventListener(BasePlannerServiceEvent.LOADED_TEMPLATES_LIST,this.loadedTemplateList);
         this._activeTemplate = new PlannerTemplate();
         this.setActiveTemplate(BASE.getTemplate());
         this.show();
      }
      
      private function loadedTemplateList(param1:BasePlannerServiceEvent) : void
      {
         this._templates = param1.templatesList;
         if(this._transferPopup)
         {
            this._transferPopup.updateList(this._templates);
         }
      }
      
      private function loadTemplateAtSlot(param1:uint) : void
      {
         this.setActiveTemplate(this._templates[param1]);
      }
      
      private function setActiveTemplate(param1:BaseTemplate) : void
      {
         this._activeTemplate.importData(param1);
         if(this.popup)
         {
            this.popup.redraw();
            this.popup.hasBeenSaved = true;
            this.popup.changedPlannerData();
         }
      }
      
      public function show(param1:MouseEvent = null) : void
      {
         BASE.BuildingDeselect();
         if(!this.popup)
         {
            this.popup = new BasePlannerPopup(this._activeTemplate);
            this.popup.addEventListener(BasePlannerEvent.APPLY,this.clickedApply);
            this.popup.addEventListener(BasePlannerEvent.SAVE,this.clickedSave);
            this.popup.addEventListener(BasePlannerEvent.LOAD,this.clickedLoad);
            GLOBAL._layerWindows.addChild(this.popup);
            this.popup.hasBeenSaved = true;
         }
      }
      
      private function clickedSave(param1:Event) : void
      {
         this.popup.removeSelection();
         if(this._transferPopup)
         {
            POPUPS.Remove(this._transferPopup);
         }
         this.service.loadTemplates();
         this._transferPopup = new BasePlannerSavePopup();
         if(this._templates)
         {
            this._transferPopup.updateList(this._templates);
         }
         this._transferPopup.addEventListener(BasePlannerEvent.SAVE,this.saveTemplate,false,0,true);
         this._transferPopup.addEventListener(Event.CLOSE,this.closedTransferPopup);
         POPUPS.Add(this._transferPopup,1);
      }
      
      private function clickedLoad(param1:Event) : void
      {
         this.popup.removeSelection();
         if(this._transferPopup)
         {
            POPUPS.Remove(this._transferPopup);
         }
         this.service.loadTemplates();
         this._transferPopup = new BasePlannerLoadPopup();
         if(this._templates)
         {
            this._transferPopup.updateList(this._templates);
         }
         this._transferPopup.addEventListener(BasePlannerEvent.LOAD,this.loadTemplate,false,0,true);
         this._transferPopup.addEventListener(Event.CLOSE,this.closedTransferPopup);
         POPUPS.Add(this._transferPopup,1);
      }
      
      private function clickedApply(param1:Event) : void
      {
         var _loc3_:PlannerNode = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._activeTemplate.inventoryData.length)
         {
            _loc3_ = this._activeTemplate.inventoryData[_loc2_];
            if(_loc3_.building._id != PlannerTemplate._DECORATION_ID && _loc3_.category == BuildingItem.TYPE_DECORATION)
            {
               _loc3_.building.RecycleC();
               InstanceManager.removeInstance(_loc3_.building);
            }
            _loc2_++;
         }
         BASE.applyTemplate(this._activeTemplate.exportData());
         PLANNER.Hide();
         BASE.Save();
      }
      
      protected function loadTemplate(param1:BasePlannerTransferEvent) : void
      {
         this.loadTemplateAtSlot(param1.slot);
         this.closedTransferPopup(null);
      }
      
      protected function saveTemplate(param1:BasePlannerTransferEvent) : void
      {
         this._activeTemplate.name = param1.name;
         this._activeTemplate.slot = param1.slot;
         this.service.saveTemplate(this._activeTemplate.exportData(),param1.slot);
         if(this.popup)
         {
            this.popup.hasBeenSaved = true;
         }
         this.closedTransferPopup(null);
      }
      
      protected function closedTransferPopup(param1:Event = null) : void
      {
         POPUPS.Remove(this._transferPopup);
         this._transferPopup.clear();
         this._transferPopup.removeEventListener(Event.CLOSE,this.closedTransferPopup);
         this._transferPopup = null;
      }
      
      public function hide(param1:MouseEvent = null) : void
      {
         if(this.popup)
         {
            this.popup.removeEventListener(BasePlannerEvent.APPLY,this.clickedApply);
            this.popup.removeEventListener(BasePlannerEvent.SAVE,this.clickedSave);
            this.popup.removeEventListener(BasePlannerEvent.LOAD,this.clickedLoad);
            this.popup.Remove();
            SOUNDS.Play("close");
            GLOBAL._layerWindows.removeChild(this.popup);
            this.popup = null;
         }
         if(this._transferPopup)
         {
            this.closedTransferPopup();
         }
      }
   }
}
