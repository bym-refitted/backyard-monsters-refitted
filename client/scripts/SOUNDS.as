package
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;

   public class SOUNDS
   {

      public static var _muted:int = 0;

      public static var _mutedMusic:int = 0;

      public static var _soundAssets:Array;

      public static var _setup:Boolean = false;

      private static var _currentMusic:String = null;

      private static var _queuedMusic:String = "musicbuild";

      private static var _musicVolume:Number = 0.7;

      private static var _musicPan:Number = 0;

      private static var _musicTime:Number;

      public static var _concurrent:Object = {};

      public static var _musicChannel:SoundChannel;

      // Sound directories
      public static var attacksounds:String = "attacksounds/";

      public static var othersounds:String = "othersounds/";

      public static var uisounds:String = "uisounds/";

      public static var infernosounds:String = "infernosounds/";

      public static var mainmusic:String = "music/";

      public static var infernomusic:String = "infernomusic/";

      public static var _sounds:Object = {
            "click1": new sound_click1(),
            "laser": attacksounds + "sound_laser.mp3",
            "wmbstart": othersounds + "sound_monsterbaiterloop.mp3",
            "wmbhorn": othersounds + "sound_monsterbaiterhorn.mp3",
            "purchasepopup": uisounds + "sound_purchasepop.mp3",
            "bankfire": uisounds + "sound_bankfire.mp3",
            "bankland": uisounds + "sound_bankland.mp3",
            "repair1": uisounds + "sound_repair1.mp3",
            "error1": uisounds + "sound_error1.mp3",
            "levelup": othersounds + "sound_levelup.mp3",
            "shotgun": uisounds + "sound_shotgun.mp3",
            "clock1": uisounds + "sound_clock1.mp3",
            "warcry1": attacksounds + "sound_warcry1.mp3",
            "splat1": attacksounds + "sound_splat1.mp3",
            "splat2": attacksounds + "sound_splat2.mp3",
            "splat3": attacksounds + "sound_splat3.mp3",
            "splat4": attacksounds + "sound_splat4.mp3",
            "splat5": attacksounds + "sound_splat5.mp3",
            "snipe1": attacksounds + "sound_snipe1.mp3",
            "magma1": infernosounds + "sound_magma_attack1.mp3",
            "magma2": infernosounds + "sound_magma_attack2.mp3",
            "quake": infernosounds + "sound_quake_attack.mp3",
            "railgun1": attacksounds + "sound_railgun1.mp3",
            "splash1": attacksounds + "sound_splash1.mp3",
            "juice": othersounds + "sound_juice.mp3",
            "close": uisounds + "sound_close.mp3",
            "buildingplace": uisounds + "sound_buildingplace.mp3",
            "lightningstart": attacksounds + "sound_lightningstart.mp3",
            "lightningfire": attacksounds + "sound_lightningfire.mp3",
            "lightningend": attacksounds + "sound_lightningend.mp3",
            "chaching": uisounds + "sound_chaching.mp3",
            "pebblebomb": attacksounds + "sound_pebblebomb.mp3",
            "twigbomb": attacksounds + "sound_twigbomb.mp3",
            "puttybomb": attacksounds + "sound_puttybomb.mp3",
            "trap": attacksounds + "sound_trap.mp3",
            "damage1": attacksounds + "building_damage_1.mp3",
            "damage2": attacksounds + "building_damage_2.mp3",
            "damage3": attacksounds + "building_damage_3.mp3",
            "destroy1": attacksounds + "building_destroy_1.mp3",
            "destroy2": attacksounds + "building_destroy_2.mp3",
            "destroy3": attacksounds + "building_destroy_3.mp3",
            "destroy4": attacksounds + "building_destroy_4.mp3",
            "destroytownhall": attacksounds + "town_hall_destroy.mp3",
            "monsterland1": attacksounds + "monster_land_1.mp3",
            "monsterland2": attacksounds + "monster_land_2.mp3",
            "monsterland3": attacksounds + "monster_land_3.mp3",
            "monsterlanddave": attacksounds + "monster_land_dave.mp3",
            "hit1": attacksounds + "sound_hit1.mp3",
            "hit2": attacksounds + "sound_hit2.mp3",
            "hit3": attacksounds + "sound_hit3.mp3",
            "hit4": attacksounds + "sound_hit4.mp3",
            "hit5": attacksounds + "sound_hit5.mp3",
            "ihit1": infernosounds + "sound_ihit1.mp3",
            "ihit2": infernosounds + "sound_ihit2.mp3",
            "ihit3": infernosounds + "sound_ihit3.mp3",
            "ihit4": infernosounds + "sound_ihit4.mp3",
            "ihit5": infernosounds + "sound_ihit5.mp3",
            "ihit6": infernosounds + "sound_ihit6.mp3",
            "ihit7": infernosounds + "sound_ihit7.mp3",
            "ihit8": infernosounds + "sound_ihit8.mp3",
            "imonster1": infernosounds + "inferno_monster1.mp3",
            "imonster2": infernosounds + "inferno_monster2.mp3",
            "imonster3": infernosounds + "inferno_monster3.mp3",
            "imonster4": infernosounds + "inferno_monster4.mp3",
            "iquestshow": infernosounds + "inferno_questshow.mp3",
            "iquesthide": infernosounds + "inferno_questhide.mp3",
            "inf_buildingplace": infernosounds + "sound_infernoplace.mp3",
            "ibankfire": infernosounds + "sound_ibankfire.mp3",
            "ibankland": infernosounds + "sound_ibankland.mp3",
            "icannon": infernosounds + "inferno_cannonfire.mp3",
            "isniper": infernosounds + "inferno_sniperfire.mp3",
            "arise": attacksounds + "wormzer_arise.mp3",
            "dig": attacksounds + "wormzer_dig.mp3",
            "bunkerdoor": attacksounds + "bunkerdoor.mp3",
            "pumpkintreat": othersounds + "sound_pumpkin_treat.mp3",
            "musicattack": mainmusic + "Music_Attack.mp3",
            "musicbuild": mainmusic + "Music_Building.mp3",
            "musicpanic": mainmusic + "Music_UnderAttack.mp3",
            "musiciattack": infernomusic + "Music_IAttack.mp3",
            "musicibuild": infernomusic + "Music_IBuild.mp3",
            "musicipanic": infernomusic + "Music_IDefense.mp3"
         };

      public static var music_volumes:Object = {
            "musicattack": 0.7,
            "musicbuild": 0.6,
            "musicpanic": 0.7,
            "musicibuild": 0.6,
            "musicipanic": 0.7,
            "musiciattack": 0.7
         };

      public function SOUNDS()
      {
         super();
      }

      public static function Setup():void
      {
         var key:String;
         if (!_setup)
         {
            _setup = true;
            if (_mutedMusic == 0)
            {
               _musicVolume = 0.7;
            }
            else
            {
               _musicVolume = 0;
            }
            if (GLOBAL.StatGet("mute") == 1)
            {
               MuteUnmute(true);
            }
            if (GLOBAL.StatGet("mutemusic") == 1)
            {
               MuteUnmute(true, "music");
            }
            try
            {
               for (key in _sounds)
               {
                  if (key == "click1")
                     continue;

                  // Comment: Preload the audio from the server
                  _sounds[key] = new Sound(new URLRequest(GLOBAL._soundPathURL + _sounds[key]));
               }
            }
            catch (e:Error)
            {
               GLOBAL.Message("There was a problem setting up audio " + e.message);
            }
         }
      }

      public static function DamageSoundIDForLevel(param1:int):String
      {
         var _loc2_:String = "";
         if (param1 < 3)
         {
            _loc2_ = "damage1";
         }
         else if (param1 < 6)
         {
            _loc2_ = "damage2";
         }
         else
         {
            _loc2_ = "damage3";
         }
         return _loc2_;
      }

      public static function DestroySoundIDForLevel(param1:int):String
      {
         var _loc2_:String = "";
         if (param1 < 2)
         {
            _loc2_ = "destroy1";
         }
         else if (param1 < 5)
         {
            _loc2_ = "destroy2";
         }
         else if (param1 < 8)
         {
            _loc2_ = "destroy3";
         }
         else
         {
            _loc2_ = "destroy4";
         }
         return _loc2_;
      }

      public static function PlayMusic(param1:String = ""):void
      {
         _queuedMusic = param1;
         if (!_mutedMusic)
         {
            _musicVolume = music_volumes[param1];
         }
      }

      public static function PlayMusicB(param1:String = "", param2:Number = 0.7, param3:Number = 0, param4:Number = 0):void
      {
         if (_currentMusic == param1)
         {
            return;
         }
         if (!_concurrent[param1])
         {
            _concurrent[param1] = 1;
         }
         if (_concurrent[param1] <= 2)
         {
            _concurrent[param1] += 1;

            // Retrieve music from preloaded assets
            var sound:Sound = _sounds[param1] as Sound;
            if (sound)
            {
               if (_musicChannel)
               {
                  _musicChannel.stop();
                  _musicChannel.removeEventListener(Event.SOUND_COMPLETE, replayMusic);
               }
               _musicChannel = sound.play(param4, int.MAX_VALUE, new SoundTransform(param2, param3));
               _currentMusic = param1;
               _musicChannel.addEventListener(Event.SOUND_COMPLETE, replayMusic);
            }
         }
      }

      private static function replayMusic(param1:Event):void
      {
         _queuedMusic = _currentMusic;
         _currentMusic = null;
         PlayMusicB(_queuedMusic);
      }

      public static function Play(soundPath:String = "", volume:Number = 0.8, pan:Number = 0, loop:int = 1):SoundChannel
      {
         if (!GLOBAL._catchup && !_muted)
         {
            if (!_concurrent[soundPath] || _concurrent[soundPath] <= 2)
            {
               _concurrent[soundPath] = (_concurrent[soundPath] || 0) + 1;

               // Retrieve sound from preloaded assets
               var sound:Sound = _sounds[soundPath] as Sound;
               if (sound)
               {
                  return sound.play(0, loop, new SoundTransform(volume, pan));
               }
            }
         }
         return null;
      }

      public static function Tick():void
      {
         for (var soundName:String in _concurrent)
         {
            if (_concurrent[soundName] > 0)
            {
               _concurrent[soundName]--;
            }
         }
         if (_currentMusic != _queuedMusic)
         {
            if (_currentMusic)
            {
               var currentMusicVolume:Number = _musicChannel.soundTransform.volume;
               currentMusicVolume -= 0.05;
               if (currentMusicVolume <= 0)
               {
                  PlayMusicB(_queuedMusic, _musicVolume, _musicPan);
               }
               else
               {
                  _musicChannel.soundTransform = new SoundTransform(currentMusicVolume, _musicPan);
               }
            }
            else
            {
               PlayMusicB(_queuedMusic, _musicVolume, _musicPan);
            }
         }
      }

      public static function TutorialStopMusic():void
      {
         MuteUnmute(true, "music");
         _queuedMusic = null;
         _currentMusic = null;
      }

      public static function StopAll():void
      {
         SoundMixer.stopAll();
      }

      public static function Toggle(param1:MouseEvent = null):void
      {
         var e:MouseEvent = param1;
         try
         {
            if (_muted == 0)
            {
               MuteUnmute(true);
            }
            else
            {
               MuteUnmute(false);
            }
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.StatSet("mute", _muted);
            }
         }
         catch (e:Error)
         {
            GLOBAL.Message("There was a problem turning sounds on ");
         }
      }

      public static function ToggleMusic(param1:MouseEvent = null):void
      {
         var e:MouseEvent = param1;
         try
         {
            if (_mutedMusic == 0)
            {
               MuteUnmute(true, "music");
            }
            else
            {
               MuteUnmute(false, "music");
            }
            if (GLOBAL.mode == GLOBAL.e_BASE_MODE.BUILD)
            {
               GLOBAL.StatSet("mutemusic", _mutedMusic);
            }
         }
         catch (e:Error)
         {
            GLOBAL.Message("There was a problem turning the music on ");
         }
      }

      public static function MuteUnmute(param1:Boolean = true, param2:String = "snd"):void
      {
         var _loc3_:SoundTransform = null;
         if (param2 == "snd")
         {
            if (param1)
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcSound.gotoAndStop(2 + 2);
               }
               else
               {
                  UI2._top.mcSound.gotoAndStop(2);
               }
               _muted = 1;
            }
            else
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcSound.gotoAndStop(1 + 2);
               }
               else
               {
                  UI2._top.mcSound.gotoAndStop(1);
               }
               _muted = 0;
            }
         }
         else if (param2 == "music")
         {
            _loc3_ = new SoundTransform();
            if (param1)
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcMusic.gotoAndStop(2 + 2);
               }
               else
               {
                  UI2._top.mcMusic.gotoAndStop(2);
               }
               _musicVolume = 0;
               _mutedMusic = 1;
            }
            else
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcMusic.gotoAndStop(1 + 2);
               }
               else
               {
                  UI2._top.mcMusic.gotoAndStop(1);
               }
               _musicVolume = 0.7;
               _mutedMusic = 0;
               if (_currentMusic == null && _queuedMusic == null)
               {
                  switch (GLOBAL.mode)
                  {
                     case GLOBAL.e_BASE_MODE.ATTACK:
                     case GLOBAL.e_BASE_MODE.WMATTACK:
                        PlayMusic("musicattack");
                        break;
                     case GLOBAL.e_BASE_MODE.BUILD:
                     case GLOBAL.e_BASE_MODE.HELP:
                     case GLOBAL.e_BASE_MODE.VIEW:
                     default:
                        PlayMusic("musicbuild");
                  }
               }
            }
            _loc3_.volume = _musicVolume;
            if (_musicChannel)
            {
               _musicChannel.soundTransform = _loc3_;
            }
         }
      }
   }
}
