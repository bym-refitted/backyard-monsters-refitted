package com.monsters.frontPage.messages
{
   import com.monsters.frontPage.FrontPageHandler;
   import com.monsters.frontPage.categories.Category;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class Message
   {
      
      protected static const _IMAGE_DIRECTORY:String = "popups/front_page/";
       
      
      public var name:String;
      
      public var title:String;
      
      public var body:String;
      
      public var imageURL:String;
      
      public var videoURL:String;
      
      public var timeLastSeen:uint;
      
      public var category:Category;
      
      protected var _doesSave:Boolean = true;
      
      protected var _buttonCopy:String;
      
      protected var _bodyArguments:Object;
      
      public function Message(param1:String, param2:String, param3:String = null, param4:String = null, param5:String = null)
      {
         super();
         this.title = KEYS.Get(param1);
         this.body = KEYS.Get(param2,this._bodyArguments);
         if(param3)
         {
            this.imageURL = _IMAGE_DIRECTORY + param3;
         }
         this.videoURL = param5;
         if(param4)
         {
            this._buttonCopy = KEYS.Get(param4);
         }
         this.name = param1;
      }
      
      public function get hasBeenSeen() : Boolean
      {
         return Boolean(this.timeLastSeen);
      }
      
      public function get areRequirementsMet() : Boolean
      {
         return true;
      }
      
      public function setupButton(param1:Button) : Button
      {
         if(!this._buttonCopy)
         {
            param1.visible = false;
            return param1;
         }
         param1.Highlight = true;
         param1.Setup(this._buttonCopy);
         param1.removeEventListener(MouseEvent.CLICK,this.clickedButton);
         param1.addEventListener(MouseEvent.CLICK,this.clickedButton,false,0,false);
         return param1;
      }
      
      public function viewed() : void
      {
         this.timeLastSeen = GLOBAL.Timestamp();
         this.onView();
      }
      
      protected function clickedButton(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         LOGGER.StatB({
            "st1":"GTP",
            "st2":"CTA",
            "value":1
         },this._buttonCopy);
         _loc2_.removeEventListener(MouseEvent.CLICK,this.clickedButton);
         this.onButtonClick();
      }
      
      public function refresh() : void
      {
      }
      
      protected function onButtonClick() : void
      {
      }
      
      protected function onView() : void
      {
      }
      
      public function setup(param1:Object) : void
      {
         if(!param1)
         {
            return;
         }
         if(param1.seen == 1)
         {
            this.timeLastSeen = GLOBAL.Timestamp();
         }
         else
         {
            this.timeLastSeen = param1.seen;
         }
      }
      
      public function export() : Object
      {
         if(!this.timeLastSeen || !this._doesSave)
         {
            return null;
         }
         return {
            "name":this.name,
            "seen":this.timeLastSeen
         };
      }
      
      public function buyBuilding(param1:int, param2:Boolean = true) : void
      {
         if(param2)
         {
            FrontPageHandler.closeAll();
         }
         BUILDINGS._buildingID = param1;
         BUILDINGS.Show();
      }
      
      public function buyMenu(param1:int = 1, param2:int = 1, param3:int = 0) : void
      {
         BUILDINGS.Show();
         BUILDINGS._mc.SwitchB(param1,param2,param3);
         POPUPS.Next();
      }
      
      public function upgradeBuilding(param1:int) : void
      {
         var _loc2_:BFOUNDATION = null;
         FrontPageHandler.closeAll();
         _loc2_ = BASE.findBuilding(param1);
         if(_loc2_)
         {
            BUILDINGOPTIONS.Show(_loc2_,"upgrade");
         }
         else
         {
            this.buyBuilding(param1);
         }
      }
      
      public function markAsUnseenIfOlderThan(param1:int) : void
      {
         if(GLOBAL.Timestamp() - this.timeLastSeen >= param1)
         {
            this.timeLastSeen = 0;
         }
      }
   }
}
