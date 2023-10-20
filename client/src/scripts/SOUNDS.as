package
{
   import com.monsters.display.ImageCache;
   import com.monsters.siege.weapons.Decoy;
   import com.monsters.siege.weapons.Jars;
   import com.monsters.sound.SoundLibrary;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.events.IOErrorEvent;

   public class SOUNDS
   {

      public static var _muted:int = 0;

      public static var _mutedMusic:int = 0;

      public static var _soundAssets:Array;

      private static var soundLibraries:Vector.<SoundLibrary>;

      public static var _setup:Boolean = false;

      public static var _loadState:int = 0;

      private static var _currentMusic:String = null;

      private static var _queuedMusic:String = "musicbuild";

      private static var _musicVolume:Number = 0.7;

      private static var _musicPan:Number = 0;

      private static var _musicTime:Number;

      public static var _concurrent:Object = {};

      public static var _musicChannel:SoundChannel;

      // Sound paths
      public static var attacksounds = "attacksounds/";
      public static var othersounds = "othersounds/";
      public static var uisounds = "uisounds/";
      public static var infernosounds = "infernosounds/";
      public static var mainmusic = "music/";
      public static var infernomusic = "infernomusic/";

      public static var _sounds:Object = {
            "click1": new sound_click1(),
            "laser": attacksounds + "sound_laser.wav",
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
            "damage2": attacksounds + "building_damage_2.wav",
            "damage3": attacksounds + "building_damage_3.mp3",
            "destroy1": attacksounds + "building_destroy_1.wav",
            "destroy2": attacksounds + "building_destroy_2.wav",
            "destroy3": attacksounds + "building_destroy_3.wav",
            "destroy4": attacksounds + "building_destroy_4.wav",
            "destroytownhall": attacksounds + "town_hall_destroy.mp3",
            "monsterland1": attacksounds + "monster_land_1.wav",
            "monsterland2": attacksounds + "monster_land_2.mp3",
            "monsterland3": attacksounds + "monster_land_3.mp3",
            "monsterlanddave": attacksounds + "monster_land_dave.mp3",
            "hit1": attacksounds + "sound_hit1.wav",
            "hit2": attacksounds + "sound_hit2.wav",
            "hit3": attacksounds + "sound_hit3.wav",
            "hit4": attacksounds + "sound_hit4.wav",
            "hit5": attacksounds + "sound_hit5.wav",
            "ihit1": attacksounds + "sound_ihit1.mp3",
            "ihit2": attacksounds + "sound_ihit2.mp3",
            "ihit3": attacksounds + "sound_ihit3.mp3",
            "ihit4": attacksounds + "sound_ihit4.mp3",
            "ihit5": attacksounds + "sound_ihit5.mp3",
            "ihit6": attacksounds + "sound_ihit6.mp3",
            "ihit7": attacksounds + "sound_ihit7.mp3",
            "ihit8": attacksounds + "sound_ihit8.mp3",
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

      public static function Setup():void
      {
         var s:String = null;
         var uiSounds:String = null;
         var otherSounds:String = null;
         var attackSounds:String = null;
         var musicSounds:String = null;
         var infernoSounds:String = null;
         var infernoMusic:String = null;
         var i:int = 0;
         if (!_setup)
         {
            _setup = true;
            try
            {
               _muted = 0;
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
            }
            catch (e:Error)
            {
               GLOBAL.Message("There was a problem setting up audio ", e);
            }
            // ToDo: What is this? We probably should preload and cache all our sounds
            var musicBuilding = GLOBAL._soundPathURL + "music/Music_Building.mp3";
            _soundAssets = [musicBuilding];
            soundLibraries = new Vector.<SoundLibrary>();
            i = 0;
            while (i < _soundAssets.length)
            {
               soundLibraries.push(new SoundLibrary(_soundAssets[i]));
               i++;
            }
            i = 0;
            while (i < _soundAssets.length - 1)
            {
               soundLibraries[i].next = soundLibraries[i + 1];
               i++;
            }
         }
         else
         {
            if (_muted == 1)
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcSound.gotoAndStop(2 + 2);
               }
               else
               {
                  UI2._top.mcSound.gotoAndStop(2);
               }
            }
            else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               UI2._top.mcSound.gotoAndStop(1 + 2);
            }
            else
            {
               UI2._top.mcSound.gotoAndStop(1);
            }
            if (_musicVolume == 0)
            {
               if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
               {
                  UI2._top.mcMusic.gotoAndStop(2 + 2);
               }
               else
               {
                  UI2._top.mcMusic.gotoAndStop(2);
               }
            }
            else if (GLOBAL.mode == GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode == GLOBAL.e_BASE_MODE.WMATTACK)
            {
               UI2._top.mcMusic.gotoAndStop(1 + 2);
            }
            else
            {
               UI2._top.mcMusic.gotoAndStop(1);
            }
         }
         for each (s in Jars.CRACKING_SOUNDS)
         {
            _sounds[s] = s;
         }
         for each (s in Jars.EXPLODE_SOUNDS)
         {
            _sounds[s] = s;
         }
         for each (s in Jars.LAND_SOUNDS)
         {
            _sounds[s] = s;
         }
         _sounds[Decoy.LAND_SOUND] = Decoy.LAND_SOUND;
         _sounds[Decoy.EXPLOSION_SOUND] = Decoy.EXPLOSION_SOUND;
         _sounds[Decoy.LOOPING_SOUND] = Decoy.LOOPING_SOUND;
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

         try
         {
            if (!_concurrent[param1])
            {
               _concurrent[param1] = 1;
            }

            if (_concurrent[param1] <= 2)
            {
               _concurrent[param1] += 1;
               var sound:Sound = new Sound();
               sound.addEventListener(IOErrorEvent.IO_ERROR, function(event:IOErrorEvent):void
                  {
                     GLOBAL.Message("Error loading music: " + event.text);
                  });

               if (_sounds[param1] is String)
               {
                  var soundURLRequest:URLRequest = new URLRequest(GLOBAL._soundPathURL + _sounds[param1] as String);
                  sound.load(soundURLRequest);
               }
               else if (_sounds[param1] is Sound)
               {
                  sound = _sounds[param1] as Sound;
               }

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
         catch (e:Error)
         {
            GLOBAL.Message("Audio error: " + e.getStackTrace());
         }
      }

      private static function replayMusic(param1:Event):void
      {
         _queuedMusic = _currentMusic;
         _currentMusic = null;
         PlayMusicB(_queuedMusic);
      }
      private static var _soundChannel:SoundChannel;

      public static function Play(param1:String = "", param2:Number = 0.8, param3:Number = 0, param4:int = 1):SoundChannel
      {
         var id:String = param1;
         var volume:Number = param2;
         var pan:Number = param3;
         var loops:int = param4;

         if (!GLOBAL._catchup && !_muted)
         {
            try
            {
               if (!_concurrent[id])
               {
                  _concurrent[id] = 1;
               }

               if (_concurrent[id] <= 2)
               {
                  _concurrent[id] += 1;
                  var sound:Sound = null;

                  // If you're storing audio file paths in the _sounds object:
                  if (_sounds[id] is String)
                  {
                     var soundURLRequest:URLRequest = new URLRequest(GLOBAL._soundPathURL + _sounds[id] as String);
                     sound = new Sound();
                     sound.addEventListener(Event.COMPLETE, function(e:Event):void
                        {
                           playSound(sound, volume, pan, loops);
                        });

                     sound.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
                        {
                           GLOBAL.Message("Error loading sound: " + event.text);
                        });

                     sound.load(soundURLRequest);
                  }
                  else if (_sounds[id] is Sound)
                  {
                     sound = _sounds[id] as Sound;
                     playSound(sound, volume, pan, loops);
                  }
               }
            }
            catch (e:Error)
            {
               // Handle any errors here
               GLOBAL.Message("SOUNDS.Play error" + e.getStackTrace());
            }
         }

         return null;
      }

      private static function playSound(sound:Sound, volume:Number, pan:Number, loops:int):SoundChannel
      {
         // Stop any currently playing sound
         if (_soundChannel)
         {
            _soundChannel.stop();
         }

         // Play the new audio file
         _soundChannel = sound.play(0, loops, new SoundTransform(volume, pan));
         return _soundChannel;
      }

      // ------- OLD Implementation -------- //

      // public static function Play(param1:String = "", param2:Number = 0.8, param3:Number = 0, param4:int = 1):SoundChannel
      // {
      // var soundLinkName:String = null;
      // var s:SoundLibrary = null;
      // var sndC:Class = null;
      // var sndO:Sound = null;
      // var id:String = param1;
      // var volume:Number = param2;
      // var pan:Number = param3;
      // var loops:int = param4;
      // if (!GLOBAL._catchup && !_muted)
      // {
      // try
      // {
      // if (!_concurrent[id])
      // {
      // _concurrent[id] = 1;
      // }
      // if (_concurrent[id] <= 2)
      // {
      // _concurrent[id] += 1;
      // soundLinkName = id;
      // if (_sounds[id] is String)
      // {
      // soundLinkName = String(_sounds[id]);
      // }
      // else if (_sounds[id])
      // {
      // return _sounds[id].play(0, loops, new SoundTransform(volume, pan));
      // }
      // for each (s in soundLibraries)
      // {
      // if (s.loaded && s.li.applicationDomain.hasDefinition(soundLinkName))
      // {
      // sndC = s.li.applicationDomain.getDefinition(soundLinkName) as Class;
      // sndO = new sndC() as Sound;
      // return sndO.play(0, loops, new SoundTransform(volume, pan));
      // }
      // }
      // }
      // }
      // catch (e:Error)
      // {
      // LOGGER.Log("err", "SOUNDS.Play error", Boolean(e.getStackTrace()));
      // }
      // }
      // return null;
      // }

      public static function Tick():void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         for (_loc1_ in _concurrent)
         {
            if (_concurrent[_loc1_] > 0)
            {
               -- _concurrent[_loc1_];
            }
         }
         if (_setup && _loadState == 0 && ImageCache.load.length == 0)
         {
            _loadState = 1;
            // Comment: Loads the audio from here
            (soundLibraries[0] as SoundLibrary).Load();
         }
         if (_currentMusic != _queuedMusic)
         {
            if (_currentMusic)
            {
               _loc2_ = _musicChannel.soundTransform.volume;
               _loc2_ -= 0.05;
               if (_loc2_ <= 0)
               {
                  PlayMusicB(_queuedMusic, _musicVolume, _musicPan);
               }
               else
               {
                  _musicChannel.soundTransform = new SoundTransform(_loc2_, _musicPan);
               }
            }
            else
            {
               // Comment: Call is made here to play audio
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
            GLOBAL.Message("There was a problem turning sounds on ", e);
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
            GLOBAL.Message("There was a problem turning the music on ", e);
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
