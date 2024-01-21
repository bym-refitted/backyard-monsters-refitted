package
{
   
   import com.monsters.maproom_manager.MapRoomManager;
   import com.monsters.missions.*;
   import com.monsters.siege.SiegeWeapons;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.Jars;
   import com.monsters.siege.weapons.Vacuum;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class QUESTS
   {
      
      public static var _global:Object;
      
      public static var _questGroups:Array;
      
      public static var _mainQuests:Array;
      
      public static var _completed:Object;
      
      public static var _displayedInstructions:Boolean;
      
      public static var _mc:QUESTSPOPUP;
      
      public static var _open:Boolean;
      
      public static var _infernoQuests:Array;
       
      
      public function QUESTS()
      {
         super();
      }
      
      public static function get amountCompleted() : int
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         for each(_loc2_ in _completed)
         {
            _loc1_++;
         }
         return _loc1_;
      }
      
      public static function Setup() : void
      {
         _displayedInstructions = false;
         _global = {
            "blvl":0,
            "brlvl":0,
            "b1lvl":0,
            "b2lvl":0,
            "b3lvl":0,
            "b4lvl":0,
            "b5lvl":0,
            "b6lvl":0,
            "b7lvl":0,
            "b8lvl":0,
            "b9lvl":0,
            "b10lvl":0,
            "b11lvl":0,
            "b12lvl":0,
            "b13lvl":0,
            "b14lvl":0,
            "b15lvl":0,
            "b16lvl":0,
            "b17lvl":0,
            "b18lvl":0,
            "b19lvl":0,
            "b20lvl":0,
            "b21lvl":0,
            "b22lvl":0,
            "b23lvl":0,
            "b24lvl":0,
            "b25lvl":0,
            "b26lvl":0,
            "b51lvl":0,
            "b128lvl":0,
            "b113lvl":0,
            "b129lvl":0,
            "b130lvl":0,
            "b132lvl":0,
            "kills":0,
            "bonus_bookmark":0,
            "bonus_fan":0,
            "bonus_invites":0,
            "bonus_gifts":0,
            "mushroomspicked":0,
            "goldmushroomspicked":0,
            "monstersblended":0,
            "monstersblendedgoo":0,
            "singleclickbank":0,
            "destroy_tribe1":0,
            "destroy_tribe2":0,
            "destroy_tribe3":0,
            "destroy_tribe4":0,
            "destroy_baseL":0,
            "worder_count":0,
            "hatch_champ1":0,
            "hatch_champ2":0,
            "hatch_champ3":0,
            "upgrade_champ1":0,
            "upgrade_champ2":0,
            "upgrade_champ3":0,
            "gift_accept":0,
            "email_build":0,
            "email_att":0,
            "email_news":0,
            "siege_decoy_built":0,
            "siege_vacuum_built":0,
            "siege_jars_built":0,
            "siege_decoy_level":0,
            "siege_vacuum_level":0,
            "siege_jars_level":0
         };
         _questGroups = [{
            "id":0,
            "name":"q_construction"
         },{
            "id":1,
            "name":"q_monsters"
         },{
            "id":2,
            "name":"q_attacking"
         },{
            "id":3,
            "name":"q_good"
         },{
            "id":4,
            "name":"q_evil"
         }];
         if(!BASE.isInfernoMainYardOrOutpost)
         {
            setupMainQuests();
         }
         else
         {
            setupInfernoQuests();
         }
         _completed = {};
      }
      
      public static function setupMainQuests() : void
      {
         var _loc2_:Object = null;
         _mainQuests = [{
            "order":1,
            "block":true,
            "list":false,
            "reward":[0,750,0,0,0],
            "id":"C0",
            "group":0,
            "name":"q_c0_name",
            "description":"q_c0_description",
            "hint":"q_c0_hint",
            "questimage":"building-townhall.png",
            "questicon":"icon_TH-L1.png",
            "streamTitle":"q_c0_streamtitle",
            "streamDescription":"q_c0_streamdescription",
            "streamImage":"quests/generic.png",
            "rules":{"b14lvl":1}
         },{
            "order":2,
            "block":true,
            "list":false,
            "reward":[1100,800,0,0,0],
            "id":"C1",
            "group":0,
            "name":"q_c1_name",
            "description":"q_c1_description",
            "hint":"q_c1_hint",
            "questimage":"completequest.png",
            "questicon":"icon_twig.png",
            "streamTitle":"q_c1_streamtitle",
            "streamDescription":"q_c1_streamdescription",
            "streamImage":"quests/generic.png",
            "rules":{"brlvl":1}
         },{
            "order":3,
            "block":true,
            "list":false,
            "reward":[500,1500,500,500,1000],
            "id":"C8",
            "group":3,
            "name":"q_c8_name",
            "description":"q_c8_description",
            "hint":"q_c8_hint",
            "questimage":"building-store.png",
            "questicon":"icon_store.png",
            "streamTitle":"q_c8_streamtitle",
            "streamDescription":"q_c8_streamdescription",
            "streamImage":"quests/openforbusiness.png",
            "rules":{"b12lvl":1}
         },{
            "order":4,
            "list":true,
            "reward":[4000,4600,500,0,0],
            "id":"U1",
            "group":0,
            "name":"q_u1_name",
            "description":"q_u1_description",
            "hint":"q_u1_hint",
            "questimage":"nextlevel.v2.png",
            "questicon":"cat_construction.png",
            "streamTitle":"q_u1_streamtitle",
            "streamDescription":"q_u1_streamdescription",
            "streamImage":"quests/nextlevel.png",
            "rules":{"blvl":2}
         },{
            "order":5,
            "list":true,
            "reward":[2000,2000,0,0,0],
            "id":"T1",
            "group":0,
            "name":"q_t1_name",
            "description":"q_t1_description",
            "hint":"q_t1_hint",
            "questimage":"building-sniper.png",
            "questicon":"icon_sniper.png",
            "streamTitle":"q_t1_streamtitle",
            "streamDescription":"q_t1_streamdescription",
            "streamImage":"quests/sniper.png",
            "rules":{"b21lvl":1}
         },{
            "order":6,
            "list":true,
            "reward":[800,800,1000,1000,0],
            "id":"D1",
            "group":2,
            "name":"q_d1_name",
            "description":"q_d1_description",
            "hint":"q_d1_hint",
            "questimage":"firstblood.v2.png",
            "questicon":"icon_First-Blood.png",
            "streamTitle":"q_d1_streamtitle",
            "streamDescription":"q_d1_streamdescription",
            "streamImage":"quests/firstblood.r3.png",
            "rules":{"kills":1}
         },{
            "order":7,
            "list":true,
            "reward":[2000,2000,2000,2000,0],
            "id":"CR3",
            "group":1,
            "name":"q_cr3_name",
            "description":"q_cr3_description",
            "hint":"q_cr3_hint",
            "questimage":"building-housing.png",
            "questicon":"icon_housing.png",
            "streamTitle":"q_cr3_streamtitle",
            "streamDescription":"q_cr3_streamdescription",
            "streamImage":"quests/housing.png",
            "rules":{"b15lvl":1}
         },{
            "order":8,
            "list":true,
            "reward":[0,0,0,1000,0],
            "id":"C18",
            "group":2,
            "name":"q_c18_name",
            "description":"q_c18_description",
            "hint":"q_c18_hint",
            "questimage":"building-flinger.png",
            "questicon":"icon_flinger.png",
            "streamTitle":"q_c18_streamtitle",
            "streamDescription":"q_c18_streamdescription",
            "streamImage":"quests/flinger.png",
            "rules":{"b5lvl":1}
         },{
            "order":9,
            "list":true,
            "reward":[0,0,0,1000,0],
            "id":"C17",
            "group":2,
            "name":"q_c17_name",
            "description":"q_c17_description",
            "hint":"q_c17_hint",
            "questimage":"building-map.png",
            "questicon":"icon_maproom.png",
            "streamTitle":"q_c17_streamtitle",
            "streamDescription":"q_c17_streamdescription",
            "streamImage":"quests/maproom.png",
            "rules":{"b11lvl":1}
         },{
            "order":10,
            "list":true,
            "reward":[6500,6500,500,1500,0],
            "id":"WM1",
            "group":2,
            "name":"q_wm1_name",
            "description":"q_wm1_description",
            "hint":"q_wm1_hint",
            "questimage":"tribe_legionnaire.v2.png",
            "questicon":"icon_tribe_legonnaire.png",
            "streamTitle":"q_wm1_streamtitle",
            "streamDescription":"q_wm1_streamdescription",
            "streamImage":"quests/tribe-legionnaire.v2.png",
            "rules":{"destroy_tribe1":1}
         },{
            "order":11,
            "list":true,
            "reward":[1000,1000,0,1000,0],
            "id":"CR2",
            "group":1,
            "name":"q_cr2_name",
            "description":"q_cr2_description",
            "hint":"q_cr2_hint",
            "questimage":"building-hatchery.png",
            "questicon":"icon_hatchery.png",
            "rules":{"b13lvl":1}
         },{
            "order":36,
            "list":true,
            "reward":[20000,0,0,0,0],
            "id":"C51",
            "group":2,
            "name":"q_c51_name",
            "description":"q_c51_description",
            "hint":"q_c51_hint",
            "questimage":"building-catapult.png",
            "questicon":"icon_catapult.png",
            "streamTitle":"q_c51_streamtitle",
            "streamDescription":"q_c51_streamdescription",
            "streamImage":"quests/catapult.png",
            "rules":{"b51lvl":1}
         },{
            "order":15,
            "list":true,
            "reward":[2000,2000,1000,1000,0],
            "id":"S1",
            "group":0,
            "name":"q_s1_name",
            "description":"q_s1_description",
            "hint":"q_s1_hint",
            "questimage":"building-storage.v2.png",
            "questicon":"icon_storage.png",
            "streamTitle":"q_s1_streamtitle",
            "streamDescription":"q_s1_streamdescription",
            "streamImage":"quests/building-storage.r3.png",
            "rules":{"b6lvl":1}
         },{
            "order":13,
            "list":true,
            "reward":[1000,1000,500,500,0],
            "id":"M1",
            "group":3,
            "name":"q_m1_name",
            "description":"q_m1_description",
            "hint":"q_m1_hint",
            "questimage":"mushroomsoup.png",
            "questicon":"icon_mushroomsoup.png",
            "streamTitle":"q_m1_streamtitle",
            "streamDescription":"q_m1_streamdescription",
            "streamImage":"quests/mushroomsoup.png",
            "rules":{"mushroomspicked":5}
         },{
            "order":19,
            "list":true,
            "reward":[1000,1000,5000,0,0],
            "id":"CR1",
            "group":1,
            "name":"q_cr1_name",
            "description":"q_cr1_description",
            "hint":"q_cr1_hint",
            "questimage":"building-monsterlocker.v2.png",
            "questicon":"icon_monsterlocker.png",
            "streamTitle":"q_cr1_streamtitle",
            "streamDescription":"q_cr1_streamdescription",
            "streamImage":"quests/building-monsterlocker.r3.png",
            "prereq":"C13",
            "rules":{"b8lvl":1}
         },{
            "order":12,
            "list":true,
            "reward":[8000,8000,8000,8000,0],
            "id":"C3",
            "group":0,
            "name":"q_c3_name",
            "description":"q_c3_description",
            "hint":"q_c3_hint",
            "questimage":"nextlevel2.v2.png",
            "questicon":"icon_nextlevel.png",
            "streamTitle":"q_c3_streamtitle",
            "streamDescription":"q_c3_streamdescription",
            "streamImage":"quests/nextlevel2.png",
            "rules":{
               "b1lvl":2,
               "b2lvl":2,
               "b3lvl":2,
               "b4lvl":2
            }
         },{
            "order":16,
            "list":true,
            "reward":[4000,4000,0,500,0],
            "id":"C13",
            "group":0,
            "name":"q_c13_name",
            "description":"q_c13_description",
            "hint":"q_c13_hint",
            "questimage":"building-townhall.png",
            "questicon":"icon_TH-L2.png",
            "streamTitle":"q_c13_streamtitle",
            "streamDescription":"q_c13_streamdescription",
            "streamImage":"quests/building-TH-L2.r3.png",
            "rules":{"b14lvl":2}
         },{
            "order":14,
            "list":true,
            "reward":[2000,2000,0,0,0],
            "id":"T2",
            "group":0,
            "name":"q_t2_name",
            "description":"q_t2_description",
            "hint":"q_t2_hint",
            "questimage":"building-cannon.v2.png",
            "questicon":"icon_cannon.png",
            "streamTitle":"q_t2_streamtitle",
            "streamDescription":"q_t2_streamdescription",
            "streamImage":"quests/building-cannon.r3.png",
            "rules":{"b20lvl":1}
         },{
            "order":46,
            "list":true,
            "reward":[10000,10000,10000,0,0],
            "id":"T3",
            "group":0,
            "name":"q_t3_name",
            "description":"q_t3_description",
            "hint":"q_t3_hint",
            "questimage":"building-tesla.png",
            "questicon":"icon_tesla.png",
            "streamTitle":"q_t3_streamtitle",
            "streamDescription":"q_t3_streamdescription",
            "streamImage":"build-lightning.png",
            "rules":{"b25lvl":1}
         },{
            "order":23,
            "list":true,
            "reward":[20000,0,0,0,0],
            "id":"C9",
            "group":0,
            "name":"q_c9_name",
            "description":"q_c9_description",
            "hint":"q_c9_hint",
            "questimage":"building-twig-L3.png",
            "questicon":"icon_B1-L3.png",
            "streamTitle":"q_c9_streamtitle",
            "streamDescription":"q_c9_streamdescription",
            "streamImage":"quests/building-twig-L3.r3.png",
            "rules":{"b1lvl":3}
         },{
            "order":24,
            "list":true,
            "reward":[0,10000,0,0,0],
            "id":"C10",
            "group":0,
            "name":"q_c10_name",
            "description":"q_c10_description",
            "hint":"q_c10_hint",
            "questimage":"building-pebbles-L3.v2.png",
            "questicon":"icon_B2-L3.png",
            "streamTitle":"q_c10_streamtitle",
            "streamDescription":"q_c10_streamdescription",
            "streamImage":"quests/building-pebble-L3.r3.png",
            "rules":{"b2lvl":3}
         },{
            "order":25,
            "list":true,
            "reward":[0,0,2500,0,0],
            "id":"C11",
            "group":0,
            "name":"q_c11_name",
            "description":"q_c11_description",
            "hint":"q_c11_hint",
            "questimage":"building-putty-L3.v2.png",
            "questicon":"icon_B3-L3.png",
            "streamTitle":"q_c11_streamtitle",
            "streamDescription":"q_c11_streamdescription",
            "streamImage":"quests/building-putty-L3.r3.png",
            "rules":{"b3lvl":3}
         },{
            "order":26,
            "list":true,
            "reward":[0,0,0,2000,0],
            "id":"C12",
            "group":0,
            "name":"q_c12_name",
            "description":"q_c12_description",
            "hint":"q_c12_hint",
            "questimage":"building-goo-L3.v2.png",
            "questicon":"icon_B4-L3.png",
            "streamTitle":"q_c12_streamtitle",
            "streamDescription":"q_c12_streamdescription",
            "streamImage":"quests/building-goo-L3.r3.png",
            "rules":{"b4lvl":3}
         },{
            "order":27,
            "list":true,
            "reward":[4000,4000,2000,2000,0],
            "id":"S2",
            "group":0,
            "name":"q_s2_name",
            "description":"q_s2_description",
            "hint":"q_s2_hint",
            "questimage":"building-storage.v2.png",
            "questicon":"icon_storage.png",
            "streamTitle":"q_s2_streamtitle",
            "streamDescription":"q_s2_streamdescription",
            "streamImage":"quests/building-storage.r3.png",
            "prereq":"S1",
            "rules":{"b6lvl":2}
         },{
            "order":29,
            "list":true,
            "reward":[20000,0,0,0,0],
            "id":"C4",
            "group":0,
            "name":"q_c4_name",
            "description":"q_c4_description",
            "hint":"q_c4_hint",
            "questimage":"building-twig-L3.png",
            "questicon":"icon_B1-L3.png",
            "streamTitle":"q_c4_streamtitle",
            "streamDescription":"q_c4_streamdescription",
            "streamImage":"quests/building-twig-L3.r3.png",
            "prereq":"C9",
            "rules":{"b1lvl":4}
         },{
            "order":62,
            "list":true,
            "reward":[1000,1000,500,500,0],
            "id":"M4",
            "group":3,
            "name":"q_m4_name",
            "description":"q_m4_description",
            "hint":"q_m4_hint",
            "questimage":"mushroombooty.png",
            "questicon":"icon_mushroombooty.png",
            "streamTitle":"q_m4_streamtitle",
            "streamDescription":"q_m4_streamdescription",
            "streamImage":"quests/mushroombooty.png",
            "prereq":"M1",
            "rules":{"goldmushroomspicked":5}
         },{
            "order":30,
            "list":true,
            "reward":[0,20000,0,0,0],
            "id":"C5",
            "group":0,
            "name":"q_c5_name",
            "description":"q_c5_description",
            "hint":"q_c5_hint",
            "questimage":"building-pebbles-L3.v2.png",
            "questicon":"icon_B2-L3.png",
            "streamTitle":"q_c5_streamtitle",
            "streamDescription":"q_c5_streamdescription",
            "streamImage":"quests/building-pebble-L3.r3.png",
            "prereq":"C10",
            "rules":{"b2lvl":4}
         },{
            "order":31,
            "list":true,
            "reward":[0,0,10000,0,0],
            "id":"C6",
            "group":0,
            "name":"q_c6_name",
            "description":"q_c6_description",
            "hint":"q_c6_hint",
            "questimage":"building-putty-L3.png",
            "questicon":"icon_B3-L3.png",
            "streamTitle":"q_c6_streamtitle",
            "streamDescription":"q_c6_streamdescription",
            "streamImage":"quests/building-putty-L3.r3.png",
            "prereq":"C11",
            "rules":{"b3lvl":4}
         },{
            "order":32,
            "list":true,
            "reward":[0,0,0,10000,0],
            "id":"C7",
            "group":0,
            "name":"q_c7_name",
            "description":"q_c7_description",
            "hint":"q_c7_hint",
            "questimage":"building-goo-L3.png",
            "questicon":"icon_B4-L3.png",
            "streamTitle":"q_c7_streamtitle",
            "streamDescription":"q_c7_streamdescription",
            "streamImage":"quests/building-goo-L3.r3.png",
            "prereq":"C12",
            "rules":{"b4lvl":4}
         },{
            "order":35,
            "list":true,
            "reward":[5000,5000,2500,2500,0],
            "id":"C14",
            "group":0,
            "name":"q_c14_name",
            "description":"q_c14_description",
            "hint":"q_c14_hint",
            "questimage":"building-townhall-L3.v4.png",
            "questicon":"icon_TH-L3.png",
            "streamTitle":"q_c14_streamtitle",
            "streamDescription":"q_c14_streamdescription",
            "streamImage":"quests/building-TH-L3.r3.png",
            "prereq":"C13",
            "rules":{"b14lvl":3}
         },{
            "order":34,
            "list":true,
            "reward":[8000,8000,4000,4000,0],
            "id":"S3",
            "group":0,
            "name":"q_s3_name",
            "description":"q_s3_description",
            "hint":"q_s3_hint",
            "questimage":"building-storage.v2.png",
            "questicon":"icon_storage.png",
            "streamTitle":"q_s3_streamtitle",
            "streamDescription":"q_s3_streamdescription",
            "streamImage":"quests/building-storage.r3.png",
            "prereq":"S2",
            "rules":{"b6lvl":3}
         },{
            "order":45,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"C15",
            "group":0,
            "name":"q_c15_name",
            "description":"q_c15_description",
            "hint":"q_c15_hint",
            "questimage":"building-townhall-L4.v2.png",
            "questicon":"icon_TH-L4.png",
            "streamTitle":"q_c15_streamtitle",
            "streamDescription":"q_c15_streamdescription",
            "streamImage":"quests/building-TH-L4.r3.png",
            "reward_creatureid":"C9",
            "monster_reward":20,
            "prereq":"C14",
            "rules":{"b14lvl":4}
         },{
            "order":37,
            "list":true,
            "reward":[16000,16000,8000,8000,0],
            "id":"S4",
            "group":0,
            "name":"q_s4_name",
            "description":"q_s4_description",
            "hint":"q_s4_hint",
            "questimage":"building-storage.v2.png",
            "questicon":"icon_storage.png",
            "streamTitle":"q_s4_streamtitle",
            "streamDescription":"q_s4_streamdescription",
            "streamImage":"quests/building-storage.r3.png",
            "prereq":"S3",
            "rules":{"b6lvl":4}
         },{
            "order":51,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"C16",
            "group":0,
            "name":"q_c16_name",
            "description":"q_c16_description",
            "hint":"q_c16_hint",
            "questimage":"building-townhall-L5.v2.png",
            "questicon":"icon_TH-L5.png",
            "streamTitle":"q_c16_streamtitle",
            "streamDescription":"q_c16_streamdescription",
            "streamImage":"quests/building-TH-L5.r3.png",
            "reward_creatureid":"C14",
            "monster_reward":5,
            "prereq":"C14",
            "rules":{"b14lvl":5}
         },{
            "order":38,
            "list":true,
            "reward":[32000,32000,16000,16000,0],
            "id":"S5",
            "group":0,
            "name":"q_s5_name",
            "description":"q_s5_description",
            "hint":"q_s5_hint",
            "questimage":"building-storage.v2.png",
            "questicon":"icon_storage.png",
            "streamTitle":"q_s5_streamtitle",
            "streamDescription":"q_s5_streamdescription",
            "streamImage":"quests/building-storage.r3.png",
            "prereq":"S4",
            "rules":{"b6lvl":5}
         },{
            "order":63,
            "list":true,
            "reward":[5000,5000,5000,5000,0],
            "id":"M2",
            "group":3,
            "name":"q_m2_name",
            "description":"q_m2_description",
            "hint":"q_m2_hint",
            "questimage":"mushroompizza.png",
            "questicon":"icon_mushroompizza.png",
            "streamTitle":"q_m2_streamtitle",
            "streamDescription":"q_m2_streamdescription",
            "streamImage":"mushroompizza.png",
            "prereq":"M1",
            "rules":{"mushroomspicked":100}
         },{
            "order":64,
            "list":true,
            "reward":[5000,5000,5000,5000,0],
            "id":"M5",
            "group":3,
            "name":"q_m5_name",
            "description":"q_m5_description",
            "hint":"q_m5_hint",
            "questimage":"mushroombling.png",
            "questicon":"icon_mushroombling.png",
            "streamTitle":"q_m5_streamtitle",
            "streamDescription":"q_m5_streamdescription",
            "streamImage":"quests/mushroombling.png",
            "prereq":"M4",
            "rules":{"goldmushroomspicked":20}
         },{
            "order":65,
            "list":true,
            "reward":[50000,50000,50000,50000,0],
            "id":"M6",
            "group":3,
            "name":"q_m6_name",
            "description":"q_m6_description",
            "hint":"q_m6_hint",
            "questimage":"slotmachine.png",
            "questicon":"icon_slotmachine.png",
            "streamTitle":"q_m6_streamtitle",
            "streamDescription":"q_m6_streamdescription",
            "streamImage":"quests/slotmachine.png",
            "prereq":"M5",
            "rules":{"goldmushroomspicked":50}
         },{
            "order":66,
            "list":true,
            "reward":[10000,10000,20000,20000,0],
            "id":"M3",
            "group":3,
            "name":"q_m3_name",
            "description":"q_m3_description",
            "hint":"q_m3_hint",
            "questimage":"burger.png",
            "questicon":"icon_burger.png",
            "streamTitle":"q_m3_streamtitle",
            "streamDescription":"q_m3_streamdescription",
            "streamImage":"quests/burger.png",
            "prereq":"M2",
            "rules":{"mushroomspicked":200}
         },{
            "order":44,
            "list":true,
            "reward":[0,0,1000,1000,0],
            "id":"BL1",
            "group":4,
            "name":"q_bl1_name",
            "description":"q_bl1_description",
            "hint":"q_bl1_hint",
            "questimage":"monsterjuice.v2.png",
            "questicon":"icon_monsterjuice.png",
            "streamTitle":"q_bl1_streamtitle",
            "streamDescription":"q_bl1_streamdescription",
            "streamImage":"quests/monsterjuice.r3.png",
            "rules":{"monstersblended":10}
         },{
            "order":59,
            "list":true,
            "reward":[0,0,10000,10000,0],
            "id":"BL2",
            "group":4,
            "name":"q_bl2_name",
            "description":"q_bl2_description",
            "hint":"q_bl2_hint",
            "questimage":"smoothie.v2.png",
            "questicon":"icon_smoothie.png",
            "streamTitle":"q_bl2_streamtitle",
            "streamDescription":"q_bl2_streamdescription",
            "streamImage":"quests/smoothie.r3.png",
            "prereq":"BL1",
            "rules":{"monstersblended":100}
         },{
            "order":60,
            "list":true,
            "reward":[0,0,100000,100000,0],
            "id":"BL3",
            "group":4,
            "name":"q_bl3_name",
            "description":"q_bl3_description",
            "hint":"q_bl3_hint",
            "questimage":"monstershake.v2.png",
            "questicon":"icon_monstershake.png",
            "streamTitle":"q_bl3_streamtitle",
            "streamDescription":"q_bl3_streamdescription",
            "streamImage":"quests/monstershake.r3.png",
            "prereq":"BL2",
            "rules":{"monstersblended":1000}
         },{
            "order":61,
            "list":true,
            "reward":[0,0,1000000,1000000,0],
            "id":"BL4",
            "group":4,
            "name":"q_bl4_name",
            "description":"q_bl4_description",
            "hint":"q_bl4_hint",
            "questimage":"margarita.png",
            "questicon":"icon_magarita.png",
            "streamTitle":"q_bl4_streamtitle",
            "streamDescription":"q_bl4_streamdescription",
            "streamImage":"quests/margarita.png",
            "prereq":"BL3",
            "rules":{"monstersblended":5000}
         },{
            "order":28,
            "list":true,
            "reward":[1000,1000,1000,1000,0],
            "id":"BK1",
            "group":3,
            "name":"q_bk1_name",
            "description":"q_bk1_description",
            "hint":"q_bk1_hint",
            "questimage":"gatherer.v2.png",
            "questicon":"icon_gatherer.png",
            "streamTitle":"q_bk1_streamtitle",
            "streamDescription":"q_bk1_streamdescription",
            "streamImage":"quests/gatherer.r3.png",
            "rules":{"singleclickbank":1000}
         },{
            "order":43,
            "list":true,
            "reward":[2000,2000,2000,2000,0],
            "id":"BK2",
            "group":3,
            "name":"q_bk2_name",
            "description":"q_bk2_description",
            "hint":"q_bk2_hint",
            "questimage":"trenchcoat.v2.png",
            "questicon":"icon_trenchcoat.png",
            "streamTitle":"q_bk2_streamtitle",
            "streamDescription":"q_bk2_streamdescription",
            "streamImage":"quests/trenchcoat.r3.png",
            "prereq":"BK1",
            "rules":{"singleclickbank":20000}
         },{
            "order":57,
            "list":true,
            "reward":[10000,10000,10000,10000,0],
            "id":"BK3",
            "group":3,
            "name":"q_bk3_name",
            "description":"q_bk3_description",
            "hint":"q_bk3_hint",
            "questimage":"wallstreet.v2.png",
            "questicon":"icon_wallstreet.png",
            "streamTitle":"q_bk3_streamtitle",
            "streamDescription":"q_bk3_streamdescription",
            "streamImage":"quests/wallstreet.r3.png",
            "prereq":"BK2",
            "rules":{"singleclickbank":100000}
         },{
            "order":58,
            "list":true,
            "reward":[50000,50000,50000,50000,0],
            "id":"BK4",
            "group":3,
            "name":"q_bk4_name",
            "description":"q_bk4_description",
            "hint":"q_bk4_hint",
            "questimage":"mogul.v2.png",
            "questicon":"icon_mogul.png",
            "streamTitle":"q_bk4_streamtitle",
            "streamDescription":"q_bk4_streamdescription",
            "streamImage":"quests/mogul.r3.png",
            "prereq":"BK3",
            "rules":{"singleclickbank":500000}
         },{
            "order":18,
            "list":true,
            "reward":[10000,10000,10000,10000,0],
            "id":"WM2",
            "group":2,
            "name":"q_wm2_name",
            "description":"q_wm2_description",
            "hint":"q_wm2_hint",
            "questimage":"tribe_kozu.v2.png",
            "questicon":"icon_tribe_kozu.png",
            "streamTitle":"q_wm2_streamtitle",
            "streamDescription":"q_wm2_streamdescription",
            "streamImage":"quests/tribe-kozu.v2.png",
            "rules":{"destroy_tribe2":1}
         },{
            "order":33,
            "list":true,
            "reward":[20000,20000,20000,20000,0],
            "id":"WM3",
            "group":2,
            "name":"q_wm3_name",
            "description":"q_wm3_description",
            "hint":"q_wm3_hint",
            "questimage":"tribe_abunakki.v2.png",
            "questicon":"icon_tribe_abunakki.png",
            "streamTitle":"q_wm3_streamtitle",
            "streamDescription":"q_wm3_streamdescription",
            "streamImage":"quests/tribe-abunakki.v2.png",
            "rules":{"destroy_tribe3":1}
         },{
            "order":50,
            "list":true,
            "reward":[40000,40000,40000,40000,0],
            "id":"WM4",
            "group":2,
            "name":"q_wm4_name",
            "description":"q_wm4_description",
            "hint":"q_wm4_hint",
            "questimage":"tribe_dreadnaut.v2.png",
            "questicon":"icon_tribe_deadnaut.png",
            "streamTitle":"q_wm4_streamtitle",
            "streamDescription":"q_wm4_streamdescription",
            "streamImage":"quests/tribe-dreadnaut.v2.png",
            "rules":{"destroy_tribe4":1}
         },{
            "order":67,
            "list":true,
            "reward":[0,0,0,10000,0],
            "id":"HG1",
            "group":1,
            "name":"q_cm1_name",
            "description":"q_cm1_description",
            "hint":"q_cm1_hint",
            "questimage":"G1_L1-150.png",
            "questicon":"icon_G1-L1.png",
            "streamTitle":"q_cm1_streamtitle",
            "streamDescription":"q_cm1_streamdescription",
            "streamImage":"quests/champ_1_1.png",
            "rules":{"hatch_champ1":1}
         },{
            "order":52,
            "list":true,
            "reward":[0,0,0,800000,0],
            "id":"UG1",
            "group":1,
            "name":"q_cm2_name",
            "description":"q_cm2_description",
            "hint":"q_cm2_hint",
            "questimage":"G1_L6-150.png",
            "questicon":"icon_G1-L6.png",
            "streamTitle":"q_cm2_streamtitle",
            "streamDescription":"q_cm2_streamdescription",
            "streamImage":"quests/champ_1_6.png",
            "prereq":"HG1",
            "rules":{"upgrade_champ1":1}
         },{
            "order":68,
            "list":true,
            "reward":[0,0,0,10000,0],
            "id":"HG2",
            "group":1,
            "name":"q_cm3_name",
            "description":"q_cm3_description",
            "hint":"q_cm3_hint",
            "questimage":"G2_L1-150.png",
            "questicon":"icon_G2-L1.png",
            "streamTitle":"q_cm3_streamtitle",
            "streamDescription":"q_cm3_streamdescription",
            "streamImage":"quests/champ_2_1.png",
            "rules":{"hatch_champ2":1}
         },{
            "order":53,
            "list":true,
            "reward":[0,0,0,800000,0],
            "id":"UG2",
            "group":1,
            "name":"q_cm4_name",
            "description":"q_cm4_description",
            "hint":"q_cm4_hint",
            "questimage":"G2_L6-150.png",
            "questicon":"icon_G2-L6.png",
            "streamTitle":"q_cm4_streamtitle",
            "streamDescription":"q_cm4_streamdescription",
            "streamImage":"quests/champ_2_6.png",
            "prereq":"HG2",
            "rules":{"upgrade_champ2":1}
         },{
            "order":69,
            "list":true,
            "reward":[0,0,0,10000,0],
            "id":"HG3",
            "group":1,
            "name":"q_cm5_name",
            "description":"q_cm5_description",
            "hint":"q_cm5_hint",
            "questimage":"G3_L1-150.png",
            "questicon":"icon_G3-L1.png",
            "streamTitle":"q_cm5_streamtitle",
            "streamDescription":"q_cm5_streamdescription",
            "streamImage":"quests/champ_3_1.png",
            "rules":{"hatch_champ3":1}
         },{
            "order":57,
            "list":true,
            "reward":[0,0,0,800000,0],
            "id":"UG3",
            "group":1,
            "name":"q_cm6_name",
            "description":"q_cm6_description",
            "hint":"q_cm6_hint",
            "questimage":"G3_L6-150.png",
            "questicon":"icon_G3-L6.png",
            "streamTitle":"q_cm6_streamtitle",
            "streamDescription":"q_cm6_streamdescription",
            "streamImage":"quests/champ_3_6.png",
            "prereq":"HG3",
            "rules":{"upgrade_champ3":1}
         },{
            "order":72,
            "list":true,
            "priority":1,
            "reward":[1000,1000,1000,1000,0],
            "id":"GA1",
            "group":3,
            "name":"q_ga1_name",
            "description":"q_ga1_description",
            "hint":"q_ga1_hint",
            "questimage":"brasscoin.png",
            "questicon":"icon_brasscoin.png",
            "streamTitle":"q_ga1_streamtitle",
            "streamDescription":"q_ga1_streamdescription",
            "streamImage":"quests/brasscoin.png",
            "rules":{"gift_accept":5}
         },{
            "order":73,
            "list":true,
            "priority":1,
            "reward":[10000,10000,10000,10000,0],
            "id":"GA2",
            "group":3,
            "name":"q_ga2_name",
            "description":"q_ga2_description",
            "hint":"q_ga2_hint",
            "questimage":"silvercoin.png",
            "questicon":"icon_silvercoin.png",
            "streamTitle":"q_ga2_streamtitle",
            "streamDescription":"q_ga2_streamdescription",
            "streamImage":"quests/silvercoin.png",
            "prereq":"GA1",
            "rules":{"gift_accept":25}
         },{
            "order":73,
            "list":true,
            "priority":1,
            "reward":[20000,20000,20000,20000,0],
            "id":"GA3",
            "group":3,
            "name":"q_ga3_name",
            "description":"q_ga3_description",
            "hint":"q_ga3_hint",
            "questimage":"goldcoin.png",
            "questicon":"icon_goldcoin.png",
            "streamTitle":"q_ga3_streamtitle",
            "streamDescription":"q_ga3_streamdescription",
            "streamImage":"quests/goldcoin.png",
            "prereq":"GA2",
            "rules":{"gift_accept":50}
         }];
         if(!GLOBAL._flags.kongregate && !GLOBAL._flags.viximo)
         {
            _quests.push({
               "order":70,
               "list":true,
               "priority":1,
               "reward":[0,0,0,0,50],
               "id":"FAN",
               "group":3,
               "name":"q_fan_name",
               "description":"q_fan_description",
               "hint":"q_fan_hint",
               "questimage":"fantastic.v2.png",
               "questicon":"icon_fantastic.png",
               "streamTitle":"q_fan_streamtitle",
               "streamDescription":"q_fan_streamdescription",
               "streamImage":"quests/fantastic.r3.png",
               "rules":{"bonus_fan":1}
            });
            _quests.push({
               "order":71,
               "list":true,
               "priority":1,
               "reward":[0,0,0,0,25],
               "id":"INVITE1",
               "group":3,
               "name":"q_invite1_name",
               "description":"q_invite1_description",
               "hint":"q_invite1_hint",
               "questimage":"friendlymonster.png",
               "questicon":"icon_shiny.png",
               "streamTitle":"q_invite1_streamtitle",
               "streamDescription":"q_invite1_streamdescription",
               "streamImage":"quests/friendlymonster.png",
               "rules":{"bonus_invites":1}
            });
            _quests.push({
               "order":74,
               "list":true,
               "priority":1,
               "reward":[0,0,0,0,45],
               "id":"INVITE5",
               "group":3,
               "name":"q_invite5_name",
               "description":"q_invite5_description",
               "hint":"q_invite5_hint",
               "questimage":"bandofmonsters.png",
               "questicon":"icon_shiny.png",
               "streamTitle":"q_invite5_streamtitle",
               "streamDescription":"q_invite5_streamdescription",
               "streamImage":"quests/bandofmonsters.png",
               "prereq":"INVITE1",
               "rules":{"bonus_invites":5}
            });
            _quests.push({
               "order":76,
               "list":true,
               "priority":1,
               "reward":[0,0,0,0,65],
               "id":"INVITE10",
               "group":3,
               "name":"q_invite10_name",
               "description":"q_invite10_description",
               "hint":"q_invite10_hint",
               "questimage":"monsterparty.png",
               "questicon":"icon_shiny.png",
               "streamTitle":"q_invite10_streamtitle",
               "streamDescription":"q_invite10_streamdescription",
               "streamImage":"quests/monsterparty.png",
               "prereq":"INVITE5",
               "rules":{"bonus_invites":10}
            });
            _quests.push({
               "order":17,
               "list":true,
               "priority":1,
               "reward":[20000,20000,20000,20000,0],
               "id":"EM1",
               "group":0,
               "name":"q_em1_name",
               "description":"q_em1_description",
               "hint":"q_em1_hint",
               "questimage":"radiotower.png",
               "questicon":"icon_radiotower.png",
               "streamTitle":"q_em1_streamtitle",
               "streamDescription":"q_em1_streamdescription",
               "streamImage":"quests/build-radio.png",
               "prereq":"C13",
               "rules":{"b113lvl":1}
            });
         }
         var _loc1_:Array = [0,0,10,10,10,2,15,15,15,20,20,5,2,5,5,1];
         _loc2_ = CREATURELOCKER._creatures["C" + 2];
         _quests.push({
            "order":20,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC2",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 2,
            "questimage":"monster" + 2 + ".v2.png",
            "questicon":"icon_C" + 2 + ".png",
            "reward_creatureid":"C" + 2,
            "monster_reward":_loc1_[2],
            "prereq":"CR1",
            "rules":{"UNLOCK":"C" + 2}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 3];
         _quests.push({
            "order":21,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC3",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 3,
            "questimage":"monster" + 3 + ".v2.png",
            "questicon":"icon_C" + 3 + ".png",
            "reward_creatureid":"C" + 3,
            "monster_reward":_loc1_[3],
            "prereq":"UC" + 2,
            "rules":{"UNLOCK":"C" + 3}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 4];
         _quests.push({
            "order":22,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC4",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 4,
            "questimage":"monster" + 4 + ".v2.png",
            "questicon":"icon_C" + 4 + ".png",
            "reward_creatureid":"C" + 4,
            "monster_reward":_loc1_[4],
            "prereq":"UC" + 3,
            "rules":{"UNLOCK":"C" + 4}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 5];
         _quests.push({
            "order":39,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC5",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 5,
            "questimage":"monster" + 5 + ".v2.png",
            "questicon":"icon_C" + 5 + ".png",
            "reward_creatureid":"C" + 5,
            "monster_reward":_loc1_[5],
            "prereq":"C" + 14,
            "rules":{"UNLOCK":"C" + 5}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 6];
         _quests.push({
            "order":40,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC6",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 6,
            "questimage":"monster" + 6 + ".v2.png",
            "questicon":"icon_C" + 6 + ".png",
            "reward_creatureid":"C" + 6,
            "monster_reward":_loc1_[6],
            "prereq":"UC" + 5,
            "rules":{"UNLOCK":"C" + 6}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 7];
         _quests.push({
            "order":41,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC7",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 7,
            "questimage":"monster" + 7 + ".v2.png",
            "questicon":"icon_C" + 7 + ".png",
            "reward_creatureid":"C" + 7,
            "monster_reward":_loc1_[7],
            "prereq":"UC" + 6,
            "rules":{"UNLOCK":"C" + 7}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 8];
         _quests.push({
            "order":42,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC8",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 8,
            "questimage":"monster" + 8 + ".v2.png",
            "questicon":"icon_C" + 8 + ".png",
            "reward_creatureid":"C" + 8,
            "monster_reward":_loc1_[8],
            "prereq":"UC" + 7,
            "rules":{"UNLOCK":"C" + 8}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 9];
         _quests.push({
            "order":47,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC9",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 9,
            "questimage":"monster" + 9 + ".v2.png",
            "questicon":"icon_C" + 9 + ".png",
            "reward_creatureid":"C" + 9,
            "monster_reward":_loc1_[9],
            "prereq":"C" + 15,
            "rules":{"UNLOCK":"C" + 9}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 10];
         _quests.push({
            "order":48,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC10",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 10,
            "questimage":"monster" + 10 + ".v2.png",
            "questicon":"icon_C" + 10 + ".png",
            "reward_creatureid":"C" + 10,
            "monster_reward":_loc1_[10],
            "prereq":"UC" + 9,
            "rules":{"UNLOCK":"C" + 10}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 11];
         _quests.push({
            "order":49,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC11",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 11,
            "questimage":"monster" + 11 + ".v2.png",
            "questicon":"icon_C" + 11 + ".png",
            "reward_creatureid":"C" + 11,
            "monster_reward":_loc1_[11],
            "prereq":"UC" + 10,
            "rules":{"UNLOCK":"C" + 11}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 12];
         _quests.push({
            "order":56,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC12",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 12,
            "questimage":"monster" + 12 + ".v2.png",
            "questicon":"icon_C" + 12 + ".png",
            "reward_creatureid":"C" + 12,
            "monster_reward":_loc1_[12],
            "prereq":"UC" + 13,
            "rules":{"UNLOCK":"C" + 12}
         });
         _loc2_ = CREATURELOCKER._creatures["C" + 13];
         _quests.push({
            "order":55,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"UC13",
            "group":1,
            "name":"q_unlock_name",
            "description":"q_unlock_description",
            "keyvars":{"v1":KEYS.Get(_loc2_.name)},
            "hint":"q_unlock_hint",
            "creatureid":"C" + 13,
            "questimage":"monster" + 13 + ".v2.png",
            "questicon":"icon_C" + 13 + ".png",
            "reward_creatureid":"C" + 13,
            "monster_reward":_loc1_[13],
            "prereq":"UC" + 11,
            "rules":{"UNLOCK":"C" + 13}
         });
         _quests.push({
            "order":59,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW4",
            "group":2,
            "name":"q_unlockweapon_name",
            "description":"q_unlockweapon_desc",
            "keyvars":{"v1":SiegeWeapons.getWeapon(Decoy.ID).name},
            "hint":"q_unlockweapon_hint",
            "questimage":"siegeweapon_decoy.jpg",
            "questicon":"icon_siegeweapon_decoy.v2.png",
            "streamImage":"siegebuild_decoy.png",
            "streamTitle":"q_unlockdecoy_streamtitle",
            "streamDescription":"q_unlockdecoy_streambody",
            "prereq":"C16",
            "siegeweapon_reward":"decoy",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_decoy_level":1}
         });
         _quests.push({
            "order":60,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW5",
            "group":2,
            "name":"q_unlockweapon_name",
            "description":"q_unlockweapon_desc",
            "keyvars":{"v1":SiegeWeapons.getWeapon(Vacuum.ID).name},
            "hint":"q_unlockweapon_hint",
            "questimage":"siegeweapon_vacuum.jpg",
            "questicon":"icon_siegeweapon_vacuum.v2.png",
            "streamImage":"siegebuild_vacuum.png",
            "streamTitle":"q_unlockvacuum_streamtitle",
            "streamDescription":"q_unlockvacuum_streambody",
            "prereq":"C16",
            "siegeweapon_reward":"vacuum",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_vacuum_level":1}
         });
         _quests.push({
            "order":61,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW6",
            "group":2,
            "name":"q_unlockweapon_name",
            "description":"q_unlockweapon_desc",
            "keyvars":{"v1":SiegeWeapons.getWeapon(Jars.ID).name},
            "hint":"q_unlockweapon_hint",
            "questimage":"siegeweapon_jars.jpg",
            "questicon":"icon_siegeweapon_jars.v2.png",
            "streamImage":"siegebuild_jars.png",
            "streamTitle":"q_unlockjars_streamtitle",
            "streamDescription":"q_unlockjars_streambody",
            "prereq":"C16",
            "siegeweapon_reward":"jars",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_jars_level":1}
         });
         _quests.push({
            "order":62,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW7",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Decoy.ID).name,
               "v2":5
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_decoy.jpg",
            "questicon":"icon_siegeweapon_decoy.v2.png",
            "streamImage":"siegebuild_decoy.png",
            "streamTitle":"q_upgradedecoy_streamtitle_5",
            "streamDescription":"q_upgradedecoy_streambody",
            "prereq":"SW4",
            "siegeweapon_reward":"decoy",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_decoy_level":5}
         });
         _quests.push({
            "order":63,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW8",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Vacuum.ID).name,
               "v2":5
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_vacuum.jpg",
            "questicon":"icon_siegeweapon_vacuum.v2.png",
            "streamImage":"siegebuild_vacuum.png",
            "streamTitle":"q_upgradevacuum_streamtitle_5",
            "streamDescription":"q_upgradevacuum_streambody",
            "prereq":"SW5",
            "siegeweapon_reward":"vacuum",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_vacuum_level":5}
         });
         _quests.push({
            "order":64,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW9",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Jars.ID).name,
               "v2":5
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_jars.jpg",
            "questicon":"icon_siegeweapon_jars.v2.png",
            "streamImage":"siegebuild_jars.png",
            "streamTitle":"q_upgradejars_streamtitle_5",
            "streamDescription":"q_upgradejars_streambody",
            "prereq":"SW6",
            "siegeweapon_reward":"jars",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_jars_level":5}
         });
         _quests.push({
            "order":65,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW10",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Decoy.ID).name,
               "v2":10
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_decoy.jpg",
            "questicon":"icon_siegeweapon_decoy.v2.png",
            "streamImage":"siegebuild_decoy.png",
            "streamTitle":"q_upgradedecoy_streamtitle_10",
            "streamDescription":"q_upgradedecoy_streambody",
            "prereq":"SW7",
            "siegeweapon_reward":"decoy",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_decoy_level":10}
         });
         _quests.push({
            "order":66,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW11",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Vacuum.ID).name,
               "v2":10
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_vacuum.jpg",
            "questicon":"icon_siegeweapon_vacuum.v2.png",
            "streamImage":"siegebuild_vacuum.png",
            "streamTitle":"q_upgradevacuum_streamtitle_10",
            "streamDescription":"q_upgradevacuum_streambody",
            "prereq":"SW8",
            "siegeweapon_reward":"vacuum",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_vacuum_level":10}
         });
         _quests.push({
            "order":67,
            "list":true,
            "reward":[0,0,0,0,0],
            "id":"SW12",
            "group":2,
            "name":"q_upgradeweapon_name",
            "description":"q_upgradeweapon_desc",
            "keyvars":{
               "v1":SiegeWeapons.getWeapon(Jars.ID).name,
               "v2":10
            },
            "hint":"q_upgradeweapon_hint",
            "questimage":"siegeweapon_jars.jpg",
            "questicon":"icon_siegeweapon_jars.v2.png",
            "streamImage":"siegebuild_jars.png",
            "streamTitle":"q_upgradejars_streamtitle_10",
            "streamDescription":"q_upgradejars_streambody",
            "prereq":"SW9",
            "siegeweapon_reward":"jars",
            "siegeweapon_rewardcount":1,
            "rules":{"siege_jars_level":10}
         });
      }
      
      public static function setupInfernoQuests() : void
      {
         _infernoQuests = INFERNO_QUESTS._infernoQuests;
      }
      
      public static function Data(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         _completed = param1;
         if(_completed.UC100)
         {
            _completed.UC12 = _completed.UC100;
            delete _completed.UC100;
         }
      }
      
      public static function Check(param1:String = "", param2:int = 0) : void
      {
         var fail:Boolean = false;
         var i:int = 0;
         var q:Object = null;
         var block:Boolean = false;
         var n:String = param1;
         var v:int = param2;
         try
         {
            if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && MapRoomManager.instance.isInMapRoom3 && BASE.isMainYardOrInfernoMainYard || GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD && !MapRoomManager.instance.isInMapRoom3)
            {
               if(Boolean(n) && _global[n] < v)
               {
                  _global[n] = v;
               }
               if(!_completed)
               {
                  _completed = {};
               }
               i = 0;
               while(i < _quests.length)
               {
                  q = _quests[i];
                  block = false;
                  if(q.id == "BOOKMARK" && !GLOBAL._flags.fanfriendbookmarkquests)
                  {
                     block = true;
                  }
                  if(q.id.substr(0,6) == "INVITE" && !GLOBAL._flags.fanfriendbookmarkquests)
                  {
                     block = true;
                  }
                  if(q.id == "FAN" && !GLOBAL._flags.fanfriendbookmarkquests)
                  {
                     block = true;
                  }
                  if(q.block)
                  {
                     block = true;
                  }
                  if(TUTORIAL._stage < 200 && (q.id == "BOOKMARK" || q.id == "FAN"))
                  {
                     block = true;
                  }
                  if(q.group != 99 && !block)
                  {
                     if(!_completed[q.id])
                     {
                        fail = false;
                        for(n in q.rules)
                        {
                           if(n == "UNLOCK")
                           {
                              if(!CREATURELOCKER._lockerData[q.rules.UNLOCK] || CREATURELOCKER._lockerData[q.rules.UNLOCK].t == 1)
                              {
                                 fail = true;
                              }
                           }
                           else if(q.rules[n] > _global[n])
                           {
                              fail = true;
                           }
                        }
                        if(Boolean(_completed[q.id]) && _completed[q.id] == 2)
                        {
                           fail = true;
                        }
                        if(!fail)
                        {
                           _completed[q.id] = 1;
                           if(BASE.isInfernoMainYardOrOutpost)
                           {
                              ACHIEVEMENTS.Check(ACHIEVEMENTS.INFERNO_QUESTS_COMPLETED,amountCompleted);
                           }
                        }
                     }
                  }
                  i++;
               }
            }
         }
         catch(e:Error)
         {
            LOGGER.Log("err","Quests.Check: " + e.message + " | " + e.getStackTrace());
         }
      }
      
      public static function TutorialCheck() : void
      {
      }
      
      public static function GetQuestByID(param1:String) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in _quests)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public static function get _quests() : Array
      {
         return BASE.isInfernoMainYardOrOutpost ? _infernoQuests : _mainQuests;
      }
      
      public static function QuestPopup(param1:String, param2:String, param3:String, param4:String, param5:String) : void
      {
         var _loc6_:popup_quest;
         (_loc6_ = new popup_quest()).tA.autoSize = TextFieldAutoSize.LEFT;
         _loc6_.tA.htmlText = KEYS.Get("pop_questcomplete_body",{
            "v1":param2,
            "v2":param3
         });
         _loc6_.bAction.SetupKey("pop_questcomplete_collect_btn");
         _loc6_.bAction.addEventListener(MouseEvent.CLICK,Collect(param1,true));
         _loc6_.bAction.Highlight = true;
         var _loc7_:int = _loc6_.tA.height + 60;
         if(param4 != "")
         {
            _loc7_ += 175;
            _loc6_.mcImage.y = _loc6_.tA.y + _loc6_.tA.height + 10;
         }
         _loc6_.mcBG.height = _loc7_;
         _loc6_.bAction.y = _loc6_.mcBG.y + _loc7_ - 40;
         if(TUTORIAL._stage < 200)
         {
            _loc6_.bClose.visible = false;
         }
         POPUPS.Push(_loc6_,null,null,null,param4);
      }
      
      public static function Collect(param1:String, param2:Boolean = false) : Function
      {
         var questID:String = param1;
         var popup:Boolean = param2;
         return function(param1:MouseEvent = null):void
         {
            CollectB(questID,popup);
         };
      }
      
      public static function CollectB(param1:String, param2:Boolean = false) : Boolean
      {
         var Brag:Function;
         var questGroup:int = 0;
         var reward:Array = null;
         var title:String = null;
         var streamTitle:String = null;
         var streamDescription:String = null;
         var found:Boolean = false;
         var q:Object = null;
         var value:int = 0;
         var collectedArr:Array = null;
         var saveOK:Boolean = false;
         var r:int = 0;
         var storage:int = 0;
         var quantity:int = 0;
         var hasRoom:Boolean = false;
         var z:int = 0;
         var popupMC:popup_quest = null;
         var h:int = 0;
         var questID:String = param1;
         var popup:Boolean = param2;
         if(GLOBAL.mode != GLOBAL.e_BASE_MODE.BUILD)
         {
            return false;
         }
         if(BASE._pendingPurchase.length == 0)
         {
            found = false;
            for each(q in QUESTS._quests)
            {
               if(q.id == questID)
               {
                  if(_completed[questID] != 1)
                  {
                     return false;
                  }
                  questGroup = int(q.group);
                  reward = q.reward;
                  title = String(q.name);
                  streamTitle = String(q.streamTitle);
                  streamDescription = String(q.streamDescription);
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               GLOBAL.Message(KEYS.Get("q_errorcollecting"));
               Hide();
               return false;
            }
            if(q.monster_reward != undefined)
            {
               HOUSING.HousingSpace();
               storage = int(CREATURES.GetProperty(q.reward_creatureid,"cStorage"));
               if(HOUSING._housingSpace.Get() < storage * q.monster_reward)
               {
                  if(HOUSING._housingSpace.Get() < storage)
                  {
                     GLOBAL.Message(KEYS.Get(BASE.isInfernoMainYardOrOutpost ? "msg_questi_housing" : "msg_quest_housing"),KEYS.Get("btn_collect"),CollectSpecial,[questID]);
                     return false;
                  }
                  quantity = HOUSING._housingSpace.Get() / storage;
                  GLOBAL.Message(KEYS.Get(BASE.isInfernoMainYardOrOutpost ? "inf_msg_housinglimited" : "msg_housinglimited",{"v1":quantity}),KEYS.Get("btn_collect"),CollectSpecial,[questID]);
                  return false;
               }
            }
            if(q.siegeweapon_reward)
            {
               hasRoom = Boolean(GLOBAL._bSiegeFactory) && !GLOBAL._bSiegeFactory.upgradingWeapon && !GLOBAL._bSiegeFactory.hasBuiltWeapon;
               if(!hasRoom)
               {
                  GLOBAL.Message(KEYS.Get("msg_quest_noroomsiegeweapon",{"v1":SiegeWeapons.getWeapon(q.siegeweapon_reward).name}));
                  return false;
               }
            }
            value = 0;
            collectedArr = [];
            saveOK = true;
            r = 0;
            while(r < reward.length)
            {
               if(reward[r] > 0)
               {
                  collectedArr.push([r,reward[r]]);
                  if(r < 4)
                  {
                     BASE.Fund(r + 1,reward[r],true);
                  }
                  else
                  {
                     _completed[questID] = 2;
                     BASE._credits.Add(reward[r]);
                     BASE._hpCredits += reward[r];
                     BASE.Purchase("Q" + questID,1,"quest");
                     saveOK = false;
                  }
                  value += reward[r];
               }
               r++;
            }
            if(q.monster_reward != undefined)
            {
               z = 0;
               while(z < q.monster_reward)
               {
                  if(q.id.substr(0,2) == "UC" && Boolean(GLOBAL._bLocker))
                  {
                     HOUSING.HousingStore(q.reward_creatureid,GLOBAL._bLocker._position);
                  }
                  else
                  {
                     HOUSING.HousingStore(q.reward_creatureid,GLOBAL.townHall._position);
                  }
                  value += CREATURES.GetProperty(q.reward_creatureid,"cResource");
                  z++;
               }
            }
            if(Boolean(q.siegeweapon_reward) && Boolean(q.siegeweapon_rewardcount))
            {
               GLOBAL._bSiegeFactory.CompleteUpgradingWeapon(q.siegeweapon_reward,false);
            }
            _completed[questID] = 2;
            BASE.PointsAdd(Math.ceil(value / 50));
            if(questID == "C0")
            {
               BASE.PointsAdd(100);
            }
            if(saveOK)
            {
               BASE.Save();
            }
            Check();
            if(TUTORIAL._stage >= 200 && Boolean(q.streamTitle))
            {
               Brag = function():void
               {
                  var _loc1_:Array = [];
                  if(q.reward[0] > 0)
                  {
                     _loc1_.push([q.reward[0],KEYS.Get(GLOBAL._resourceNames[0])]);
                  }
                  if(q.reward[1] > 0)
                  {
                     _loc1_.push([q.reward[1],KEYS.Get(GLOBAL._resourceNames[1])]);
                  }
                  if(q.reward[2] > 0)
                  {
                     _loc1_.push([q.reward[2],KEYS.Get(GLOBAL._resourceNames[2])]);
                  }
                  if(q.reward[3] > 0)
                  {
                     _loc1_.push([q.reward[3],KEYS.Get(GLOBAL._resourceNames[3])]);
                  }
                  if(q.reward[4] > 0)
                  {
                     _loc1_.push([q.reward[4],KEYS.Get(GLOBAL._resourceNames[4])]);
                  }
                  if(q.monster_reward != undefined)
                  {
                     _loc1_.push([q.monster_reward,KEYS.Get(CREATURELOCKER._creatures[q.reward_creatureid].name)]);
                  }
                  if(q.siegeweapon_reward)
                  {
                     _loc1_.push([q.siegeweapon_rewardcount,SiegeWeapons.getWeapon(q.siegeweapon_reward).name]);
                  }
                  var _loc2_:String = GLOBAL.Array2String(_loc1_);
                  var _loc3_:String = KEYS.Get(q.streamTitle).replace("#questname#",KEYS.Get(q.name,q.keyvars)).replace("#collected#",_loc2_);
                  var _loc4_:String = KEYS.Get(q.streamDescription).replace("#questname#",KEYS.Get(q.name,q.keyvars)).replace("#collected#",_loc2_);
                  var _loc5_:String = String(q.streamImage);
                  GLOBAL.CallJS("sendFeed",["quest-collected",_loc3_,_loc4_,_loc5_,0]);
                  POPUPS.Next();
               };
               popupMC = new popup_quest();
               popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_questcollected_body",{"v1":KEYS.Get(q.name,q.keyvars)}) + "</b>";
               popupMC.bAction.SetupKey("btn_brag");
               popupMC.bAction.addEventListener(MouseEvent.CLICK,Brag);
               popupMC.bAction.Highlight = true;
               h = popupMC.tA.height + 80;
               if(q.questimage != "")
               {
                  h += 190;
                  popupMC.mcImage.y = popupMC.tA.y + popupMC.tA.height + 20;
               }
               popupMC.mcBG.height = h;
               (popupMC.mcBG as frame).Setup();
               popupMC.bAction.y = popupMC.mcBG.y + h - 45;
               POPUPS.Push(popupMC,null,null,null,q.questimage);
            }
         }
         return true;
      }
      
      public static function CollectSpecial(param1:String) : void
      {
         var Brag:Function;
         var questGroup:int = 0;
         var reward:Array = null;
         var title:String = null;
         var streamTitle:String = null;
         var streamDescription:String = null;
         var found:Boolean = false;
         var q:Object = null;
         var value:int = 0;
         var z:int = 0;
         var popupMC:popup_quest = null;
         var h:int = 0;
         var questID:String = param1;
         if(BASE._pendingPurchase.length == 0)
         {
            found = false;
            for each(q in QUESTS._quests)
            {
               if(q.id == questID)
               {
                  if(_completed[questID] != 1)
                  {
                     return;
                  }
                  questGroup = int(q.group);
                  reward = q.reward;
                  title = String(q.name);
                  streamTitle = String(q.streamTitle);
                  streamDescription = String(q.streamDescription);
                  found = true;
                  break;
               }
            }
            if(!found)
            {
               GLOBAL.Message(KEYS.Get("q_errorcollecting"));
               Hide();
               return;
            }
            value = 0;
            if(q.monster_reward != undefined)
            {
               z = 0;
               while(z < q.monster_reward)
               {
                  if(q.id.substr(0,2) == "UC" && Boolean(GLOBAL._bLocker))
                  {
                     HOUSING.HousingStore(q.reward_creatureid,GLOBAL._bLocker._position);
                  }
                  else
                  {
                     HOUSING.HousingStore(q.reward_creatureid,GLOBAL.townHall._position);
                  }
                  value += CREATURES.GetProperty(q.reward_creatureid,"cResource");
                  z++;
               }
            }
            if(Boolean(q.siegeweapon_reward) && Boolean(q.siegeweapon_rewardcount))
            {
               GLOBAL._bSiegeFactory.CompleteUpgradingWeapon(q.siegeweapon_reward,false);
            }
            _completed[questID] = 2;
            BASE.PointsAdd(Math.ceil(value / 50));
            BASE.Save();
            Check();
            if(TUTORIAL._stage >= 200 && Boolean(q.streamTitle))
            {
               Brag = function():void
               {
                  var _loc1_:Array = [];
                  if(q.reward[0] > 0)
                  {
                     _loc1_.push([q.reward[0],KEYS.Get(GLOBAL._resourceNames[0])]);
                  }
                  if(q.reward[1] > 0)
                  {
                     _loc1_.push([q.reward[1],KEYS.Get(GLOBAL._resourceNames[1])]);
                  }
                  if(q.reward[2] > 0)
                  {
                     _loc1_.push([q.reward[2],KEYS.Get(GLOBAL._resourceNames[2])]);
                  }
                  if(q.reward[3] > 0)
                  {
                     _loc1_.push([q.reward[3],KEYS.Get(GLOBAL._resourceNames[3])]);
                  }
                  if(q.reward[4] > 0)
                  {
                     _loc1_.push([q.reward[4],KEYS.Get(GLOBAL._resourceNames[4])]);
                  }
                  if(q.monster_reward != undefined)
                  {
                     _loc1_.push([q.monster_reward,KEYS.Get(CREATURELOCKER._creatures[q.reward_creatureid].name)]);
                  }
                  if(q.siegeweapon_reward != undefined)
                  {
                     _loc1_.push([q.siegeweapon_rewardcount,SiegeWeapons.getWeapon(q.siegeweapon_reward).name]);
                  }
                  var _loc2_:String = GLOBAL.Array2String(_loc1_);
                  var _loc3_:String = KEYS.Get(q.streamTitle).replace("#questname#",KEYS.Get(q.name,q.keyvars)).replace("#collected#",_loc2_);
                  var _loc4_:String = KEYS.Get(q.streamDescription).replace("#questname#",KEYS.Get(q.name,q.keyvars)).replace("#collected#",_loc2_);
                  var _loc5_:String = String(q.streamImage);
                  GLOBAL.CallJS("sendFeed",["quest-collected",_loc3_,_loc4_,_loc5_,0]);
                  POPUPS.Next();
               };
               popupMC = new popup_quest();
               popupMC.tA.htmlText = "<b>" + KEYS.Get("pop_questcollected_body",{"v1":KEYS.Get(q.name,q.keyvars)}) + "</b>";
               popupMC.bAction.SetupKey("btn_brag");
               popupMC.bAction.addEventListener(MouseEvent.CLICK,Brag);
               popupMC.bAction.Highlight = true;
               h = popupMC.tA.height + 80;
               if(q.questimage != "")
               {
                  h += 190;
                  popupMC.mcImage.y = popupMC.tA.y + popupMC.tA.height + 20;
               }
               popupMC.mcBG.height = h;
               (popupMC.mcBG as frame).Setup();
               popupMC.bAction.y = popupMC.mcBG.y + h - 45;
               POPUPS.Push(popupMC,null,null,null,q.questimage);
            }
            QUESTS.Hide();
         }
      }
      
      public static function Show(param1:MouseEvent = null) : void
      {
         if(GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
         {
            if(GLOBAL._newBuilding)
            {
               GLOBAL._newBuilding.Cancel();
            }
            if(!_open)
            {
               SOUNDS.Play("click1");
               _open = true;
               BASE.BuildingDeselect();
               GLOBAL.BlockerAdd();
               _mc = GLOBAL._layerWindows.addChild(new QUESTSPOPUP()) as QUESTSPOPUP;
               _mc.Center();
               _mc.ScaleUp();
            }
         }
      }
      
      public static function Hide(param1:MouseEvent = null) : void
      {
         if(_open)
         {
            _open = false;
            POPUPS.Next();
            if(_mc)
            {
               GLOBAL.BlockerRemove();
               GLOBAL._layerWindows.removeChild(_mc);
               _mc = null;
            }
         }
      }
      
      public static function CheckB() : String
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < _quests.length)
         {
            _loc3_ = _quests[_loc2_];
            _loc1_.push([_loc3_.reward,_loc3_.id,_loc3_.group]);
            _loc4_ = 1;
            while(_loc4_ <= 21)
            {
               if(_loc3_.rules["b" + _loc4_ + "lvl"])
               {
                  _loc1_.push(_loc3_.rules["b" + _loc4_ + "lvl"]);
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return md5(JSON.encode(_loc1_));
      }
      
      public static function Completed() : void
      {
      }
   }
}
