package com.monsters.frontPage
{
   import com.monsters.frontPage.categories.Category;
   import com.monsters.frontPage.categories.News;
   import com.monsters.frontPage.events.FrontPageEvent;
   import com.monsters.frontPage.messages.Message;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class FrontPageHandler
   {
      
      private static var _graphic:com.monsters.frontPage.FrontPageGraphic;
      
      private static var _activeCategory:Category;
      
      private static var _activeMessage:Message;
      
      private static var _qualifiedCategories:Vector.<Category>;
      
      private static var _messagesSeen:Vector.<Message>;
      
      private static var _timeSpentViewing:Number;
      
      private static var _hasBeenSeenThisSession:Boolean = false;
      
      private static var _hasBeenSetupThisSession:Boolean = false;
       
      
      public function FrontPageHandler()
      {
         super();
      }
      
      public static function get isVisible() : Boolean
      {
         return _graphic !== null;
      }
      
      public static function get hasBeenSeenThisSession() : Boolean
      {
         return _hasBeenSeenThisSession;
      }
      
      public static function get hasBeenSetupThisSession() : Boolean
      {
         return _hasBeenSetupThisSession;
      }
      
      public static function set activeCategory(param1:Category) : void
      {
         _activeCategory = param1;
         if(_graphic)
         {
            _graphic.updateCategories(_activeCategory,_qualifiedCategories);
            _graphic.mcNew.alpha = _activeCategory is News ? 1 : 0;
            if(_qualifiedCategories.length > 1)
            {
               _graphic.bNext.visible = true;
               _graphic.bPrev.visible = true;
            }
         }
         activeMessage = _activeCategory.getNextQualifiedMessage();
      }
      
      public static function set activeMessage(param1:Message) : void
      {
         _activeMessage = param1;
         if(Boolean(_graphic) && Boolean(_activeMessage))
         {
            _graphic.showMessage(param1);
            _messagesSeen.push(_activeMessage);
         }
      }
      
      public static function interupt() : void
      {
         closedPopup();
         POPUPS.Next();
      }
      
      public static function initialize(param1:Object = null) : void
      {
         FrontPageLibrary.initialize();
         if(param1)
         {
            setup(param1);
         }
      }
      
      public static function showPopup(param1:Boolean = false) : Boolean
      {
         var _loc2_:DisplayObject = null;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD || BASE.isOutpost || !TUTORIAL.hasFinished || _hasBeenSeenThisSession || !BASE.isMainYard || INFERNO_EMERGENCE_EVENT.isGoingToAttack)
         {
            return false;
         }
         if(_graphic && !param1 || !updateQualifiedCategories())
         {
            return false;
         }
         if(_graphic)
         {
            _loc2_ = _graphic;
            closedPopup();
            POPUPS.Remove(_loc2_);
         }
         _graphic = new com.monsters.frontPage.FrontPageGraphic();
         _graphic.addEventListener(FrontPageEvent.NEXT,nextCategory);
         _graphic.addEventListener(FrontPageEvent.PREVIOUS,previousCategory);
         _graphic.addEventListener(FrontPageEvent.CHANGE_CATEGORY,changeCategory);
         _graphic.addEventListener(Event.REMOVED_FROM_STAGE,closedPopup);
         _messagesSeen = new Vector.<Message>();
         _timeSpentViewing = GLOBAL.Timestamp();
         activeCategory = _qualifiedCategories[0];
         POPUPS.Push(_graphic,null,null,null,null,false,"wait");
         _hasBeenSeenThisSession = true;
         return true;
      }
      
      private static function closedPopup(param1:Event = null) : void
      {
         var _loc2_:Number = NaN;
         _graphic.removeEventListener(FrontPageEvent.NEXT,nextCategory);
         _graphic.removeEventListener(FrontPageEvent.PREVIOUS,previousCategory);
         _graphic.removeEventListener(FrontPageEvent.CHANGE_CATEGORY,changeCategory);
         _graphic.removeEventListener(Event.REMOVED_FROM_STAGE,closedPopup);
         _graphic = null;
         if(param1)
         {
            _loc2_ = GLOBAL.Timestamp() - _timeSpentViewing;
            LOGGER.StatB({
               "st1":"GTP",
               "st2":"time",
               "value":GLOBAL.Timestamp() - _timeSpentViewing
            },"time_seen");
            save();
         }
      }
      
      private static function save() : void
      {
         var _loc2_:Message = null;
         var _loc1_:int = 0;
         while(_loc1_ < _messagesSeen.length)
         {
            _loc2_ = _messagesSeen[_loc1_];
            _loc2_.viewed();
            _loc2_.category.lastMessageSeen = _loc2_;
            LOGGER.StatB({
               "st1":"GTP",
               "st2":"View"
            },_loc2_.name);
            _loc1_++;
         }
         BASE.Save();
      }
      
      public static function refresh() : void
      {
         if(updateQualifiedCategories())
         {
            activeCategory = _qualifiedCategories[0];
         }
      }
      
      protected static function updateQualifiedCategories() : Vector.<Category>
      {
         var _loc2_:Category = null;
         var _loc3_:Message = null;
         _qualifiedCategories = new Vector.<Category>();
         var _loc1_:int = 0;
         while(_loc1_ < FrontPageLibrary.CATEGORIES.length)
         {
            _loc2_ = FrontPageLibrary.CATEGORIES[_loc1_];
            _loc3_ = _loc2_.getNextQualifiedMessage();
            if(_loc3_)
            {
               _qualifiedCategories.push(_loc2_);
            }
            _loc1_++;
         }
         if(_qualifiedCategories.length == 0)
         {
            _qualifiedCategories = null;
         }
         return _qualifiedCategories;
      }
      
      protected static function changeCategory(param1:FrontPageEvent) : void
      {
         var _loc2_:Category = param1.category;
         if(_loc2_ == _activeCategory)
         {
            return;
         }
         if(!updateQualifiedCategories())
         {
            return;
         }
         activeCategory = _loc2_;
      }
      
      protected static function nextCategory(param1:FrontPageEvent) : void
      {
         if(!updateQualifiedCategories())
         {
            return;
         }
         activeCategory = _qualifiedCategories[verifyIndex(_qualifiedCategories.indexOf(_activeCategory) + 1)];
      }
      
      protected static function previousCategory(param1:FrontPageEvent) : void
      {
         if(!updateQualifiedCategories())
         {
            return;
         }
         activeCategory = _qualifiedCategories[verifyIndex(_qualifiedCategories.indexOf(_activeCategory) - 1)];
      }
      
      private static function verifyIndex(param1:int) : int
      {
         if(param1 > _qualifiedCategories.length - 1)
         {
            param1 = 0;
         }
         else if(param1 < 0)
         {
            param1 = int(_qualifiedCategories.length - 1);
         }
         return param1;
      }
      
      public static function setup(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Category = null;
         _hasBeenSetupThisSession = true;
         for(_loc2_ in param1)
         {
            _loc3_ = FrontPageLibrary.getCategoryByName(_loc2_);
            if(_loc3_)
            {
               _loc3_.setup(param1[_loc2_]);
            }
         }
      }
      
      public static function export() : Object
      {
         var _loc1_:Object = null;
         var _loc3_:Category = null;
         var _loc4_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < FrontPageLibrary.CATEGORIES.length)
         {
            _loc3_ = FrontPageLibrary.CATEGORIES[_loc2_];
            if(_loc4_ = _loc3_.export())
            {
               if(!_loc1_)
               {
                  _loc1_ = {};
               }
               _loc1_[_loc3_.name] = _loc4_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public static function closeAll() : void
      {
         if(POPUPS._open)
         {
            POPUPS.Next();
         }
         if(BUILDINGS._open)
         {
            BUILDINGS.Hide();
         }
         if(BUILDINGOPTIONS._open)
         {
            BUILDINGOPTIONS.Hide();
         }
      }
   }
}
