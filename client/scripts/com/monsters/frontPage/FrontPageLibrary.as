package com.monsters.frontPage
{
   import com.monsters.frontPage.categories.*;
   import com.monsters.frontPage.messages.Message;
   import com.monsters.frontPage.messages.buildtree.*;
   import com.monsters.frontPage.messages.news.News01MagmaTower;
   import com.monsters.frontPage.messages.news.News02InfernoYardExpansion;
   import com.monsters.frontPage.messages.news.News03Vorg;
   import com.monsters.frontPage.messages.news.News04Slimeattikus;
   import com.monsters.frontPage.messages.news.News05YardPlanner2;
   import com.monsters.frontPage.messages.news.News06TownHallLevel10;
   import com.monsters.frontPage.messages.promotions.Maproom3OptInPopup;
   import com.monsters.frontPage.messages.promotions.Promo01DaveClub;
   import com.monsters.frontPage.messages.promotions.Promo02DaveClub;
   import com.monsters.frontPage.messages.promotions.Promo03RecapturedGorgo;
   import com.monsters.frontPage.messages.promotions.Promo04RecapturedDrull;
   import com.monsters.frontPage.messages.promotions.Promo05RecapturedFomor;
   import com.monsters.frontPage.messages.promotions.Promo06RecapturedKorath;
   import com.monsters.frontPage.messages.underusedFeatures.Underused01MonsterLocker;
   import com.monsters.frontPage.messages.underusedFeatures.Underused02Academy;
   
   public class FrontPageLibrary
   {
      
      public static var NEWS:Category;
      
      public static var PROMOTIONS:Category;
      
      public static var WHATS_AVAILABLE:Category;
      
      public static var UNDERUSED_FEATURES:Category;
      
      public static var LONG_TERM:Category;
      
      public static var PRO_TIPS:Category;
      
      public static var EVENTS:Category;
      
      public static var CATEGORIES:Vector.<Category> = new Vector.<Category>();
       
      
      public function FrontPageLibrary()
      {
         super();
      }
      
      public static function initialize() : void
      {
         addCategories();
         addMessages();
      }
      
      public static function addMessages() : void
      {
         NEWS.addMessage(new News01MagmaTower());
         NEWS.addMessage(new News02InfernoYardExpansion());
         NEWS.addMessage(new News03Vorg());
         NEWS.addMessage(new News04Slimeattikus());
         NEWS.addMessage(new News05YardPlanner2());
         NEWS.addMessage(new News06TownHallLevel10());
         // PROMOTIONS.addMessage(new Maproom3OptInPopup()); Disable Map Room 3 popups
         PROMOTIONS.addMessage(new Promo01DaveClub());
         PROMOTIONS.addMessage(new Promo02DaveClub());
         PROMOTIONS.addMessage(new Promo03RecapturedGorgo());
         PROMOTIONS.addMessage(new Promo04RecapturedDrull());
         PROMOTIONS.addMessage(new Promo05RecapturedFomor());
         PROMOTIONS.addMessage(new Promo06RecapturedKorath());
         UNDERUSED_FEATURES.addMessage(new Underused01MonsterLocker());
         UNDERUSED_FEATURES.addMessage(new Underused02Academy());
         WHATS_AVAILABLE.addMessage(new BuildTree_01_SniperCannonTowers());
         WHATS_AVAILABLE.addMessage(new BuildTree_02_RadioTower());
         WHATS_AVAILABLE.addMessage(new BuildTree_03_MonsterLocker());
         WHATS_AVAILABLE.addMessage(new BuildTree_04_BoobyTraps());
         WHATS_AVAILABLE.addMessage(new BuildTree_05_Blocks());
         WHATS_AVAILABLE.addMessage(new BuildTree_06_Catapult());
         WHATS_AVAILABLE.addMessage(new BuildTree_07_StoneBlocks());
         WHATS_AVAILABLE.addMessage(new BuildTree_08_MonsterAcademy());
         WHATS_AVAILABLE.addMessage(new BuildTree_09_HCC());
         WHATS_AVAILABLE.addMessage(new BuildTree_10_YardPlanner());
         WHATS_AVAILABLE.addMessage(new BuildTree_11_MonsterJuicer());
         WHATS_AVAILABLE.addMessage(new BuildTree_12_MonsterBunker());
         WHATS_AVAILABLE.addMessage(new BuildTree_13_MonsterBaiter());
         WHATS_AVAILABLE.addMessage(new BuildTree_14_TeslaTower());
         WHATS_AVAILABLE.addMessage(new BuildTree_15_LaserTower());
         WHATS_AVAILABLE.addMessage(new BuildTree_16_AerialTower());
         WHATS_AVAILABLE.addMessage(new BuildTree_18_MetalBlocks());
         WHATS_AVAILABLE.addMessage(new BuildTree_19_ChampionChamber());
      }
      
      public static function addCategories() : void
      {
         NEWS = new News();
         PROMOTIONS = new Promotions();
         WHATS_AVAILABLE = new WhatsAvailable();
         UNDERUSED_FEATURES = new UnderusedFeatures();
         LONG_TERM = new LongTerm();
         PRO_TIPS = new ProTips();
         EVENTS = new ReplayableEventsCategory();
         CATEGORIES = Vector.<Category>([EVENTS,PROMOTIONS,NEWS,WHATS_AVAILABLE,UNDERUSED_FEATURES,LONG_TERM,PRO_TIPS]);
      }
      
      public static function getCategoryByName(param1:String) : Category
      {
         var _loc3_:Category = null;
         var _loc2_:int = 0;
         while(_loc2_ < CATEGORIES.length)
         {
            _loc3_ = CATEGORIES[_loc2_];
            if(_loc3_.name == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public static function getMessageByName(param1:String) : Message
      {
         var _loc3_:Category = null;
         var _loc4_:Message = null;
         var _loc2_:int = 0;
         while(_loc2_ < CATEGORIES.length)
         {
            _loc3_ = CATEGORIES[_loc2_];
            if(_loc4_ = _loc3_.getMessageByName(param1))
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}
