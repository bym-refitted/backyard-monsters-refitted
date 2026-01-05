import Event from 'openfl/events/Event';
import MouseEvent from 'openfl/events/MouseEvent';
import SoundChannel from 'openfl/media/SoundChannel';
import SoundTransform from 'openfl/media/SoundTransform';
import { GLOBAL } from './GLOBAL';
import { UI2 } from './UI2';

/**
 * SOUNDS - Audio Management System
 * Handles playing sounds, music, and volume control
 */
export class SOUNDS {
    public static _muted: number = 0;
    public static _mutedMusic: number = 0;
    public static _soundAssets: any[] = [];
    public static _setup: boolean = false;
    private static _currentMusic: string | null = null;
    private static _queuedMusic: string | null = "musicbuild";
    private static _musicVolume: number = 0.7;
    private static _musicPan: number = 0;
    private static _musicTime: number = 0;
    public static _concurrent: Record<string, number> = {};
    public static _musicChannel: any = null; // HTML5 Audio or SoundChannel
    
    // Sound directories
    public static attacksounds: string = "attacksounds/";
    public static othersounds: string = "othersounds/";
    public static uisounds: string = "uisounds/";
    public static infernosounds: string = "infernosounds/";
    public static mainmusic: string = "music/";
    public static infernomusic: string = "infernomusic/";

    public static _sounds: Record<string, any> = {
        click1: null, // embedded
        laser: SOUNDS.attacksounds + "sound_laser.mp3",
        wmbstart: SOUNDS.othersounds + "sound_monsterbaiterloop.mp3",
        wmbhorn: SOUNDS.othersounds + "sound_monsterbaiterhorn.mp3",
        purchasepopup: SOUNDS.uisounds + "sound_purchasepop.mp3",
        bankfire: SOUNDS.uisounds + "sound_bankfire.mp3",
        bankland: SOUNDS.uisounds + "sound_bankland.mp3",
        repair1: SOUNDS.uisounds + "sound_repair1.mp3",
        error1: SOUNDS.uisounds + "sound_error1.mp3",
        levelup: SOUNDS.othersounds + "sound_levelup.mp3",
        shotgun: SOUNDS.uisounds + "sound_shotgun.mp3",
        clock1: SOUNDS.uisounds + "sound_clock1.mp3",
        warcry1: SOUNDS.attacksounds + "sound_warcry1.mp3",
        splat1: SOUNDS.attacksounds + "sound_splat1.mp3",
        splat2: SOUNDS.attacksounds + "sound_splat2.mp3",
        splat3: SOUNDS.attacksounds + "sound_splat3.mp3",
        splat4: SOUNDS.attacksounds + "sound_splat4.mp3",
        splat5: SOUNDS.attacksounds + "sound_splat5.mp3",
        snipe1: SOUNDS.attacksounds + "sound_snipe1.mp3",
        magma1: SOUNDS.infernosounds + "sound_magma_attack1.mp3",
        magma2: SOUNDS.infernosounds + "sound_magma_attack2.mp3",
        quake: SOUNDS.infernosounds + "sound_quake_attack.mp3",
        railgun1: SOUNDS.attacksounds + "sound_railgun1.mp3",
        splash1: SOUNDS.attacksounds + "sound_splash1.mp3",
        juice: SOUNDS.othersounds + "sound_juice.mp3",
        close: SOUNDS.uisounds + "sound_close.mp3",
        buildingplace: SOUNDS.uisounds + "sound_buildingplace.mp3",
        lightningstart: SOUNDS.attacksounds + "sound_lightningstart.mp3",
        lightningfire: SOUNDS.attacksounds + "sound_lightningfire.mp3",
        lightningend: SOUNDS.attacksounds + "sound_lightningend.mp3",
        chaching: SOUNDS.uisounds + "sound_chaching.mp3",
        pebblebomb: SOUNDS.attacksounds + "sound_pebblebomb.mp3",
        twigbomb: SOUNDS.attacksounds + "sound_twigbomb.mp3",
        puttybomb: SOUNDS.attacksounds + "sound_puttybomb.mp3",
        trap: SOUNDS.attacksounds + "sound_trap.mp3",
        damage1: SOUNDS.attacksounds + "building_damage_1.mp3",
        damage2: SOUNDS.attacksounds + "building_damage_2.mp3",
        damage3: SOUNDS.attacksounds + "building_damage_3.mp3",
        destroy1: SOUNDS.attacksounds + "building_destroy_1.mp3",
        destroy2: SOUNDS.attacksounds + "building_destroy_2.mp3",
        destroy3: SOUNDS.attacksounds + "building_destroy_3.mp3",
        destroy4: SOUNDS.attacksounds + "building_destroy_4.mp3",
        destroytownhall: SOUNDS.attacksounds + "town_hall_destroy.mp3",
        monsterland1: SOUNDS.attacksounds + "monster_land_1.mp3",
        monsterland2: SOUNDS.attacksounds + "monster_land_2.mp3",
        monsterland3: SOUNDS.attacksounds + "monster_land_3.mp3",
        monsterlanddave: SOUNDS.attacksounds + "monster_land_dave.mp3",
        hit1: SOUNDS.attacksounds + "sound_hit1.mp3",
        hit2: SOUNDS.attacksounds + "sound_hit2.mp3",
        hit3: SOUNDS.attacksounds + "sound_hit3.mp3",
        hit4: SOUNDS.attacksounds + "sound_hit4.mp3",
        hit5: SOUNDS.attacksounds + "sound_hit5.mp3",
        ihit1: SOUNDS.infernosounds + "sound_ihit1.mp3",
        ihit2: SOUNDS.infernosounds + "sound_ihit2.mp3",
        ihit3: SOUNDS.infernosounds + "sound_ihit3.mp3",
        ihit4: SOUNDS.infernosounds + "sound_ihit4.mp3",
        ihit5: SOUNDS.infernosounds + "sound_ihit5.mp3",
        ihit6: SOUNDS.infernosounds + "sound_ihit6.mp3",
        ihit7: SOUNDS.infernosounds + "sound_ihit7.mp3",
        ihit8: SOUNDS.infernosounds + "sound_ihit8.mp3",
        imonster1: SOUNDS.infernosounds + "inferno_monster1.mp3",
        imonster2: SOUNDS.infernosounds + "inferno_monster2.mp3",
        imonster3: SOUNDS.infernosounds + "inferno_monster3.mp3",
        imonster4: SOUNDS.infernosounds + "inferno_monster4.mp3",
        iquestshow: SOUNDS.infernosounds + "inferno_questshow.mp3",
        iquesthide: SOUNDS.infernosounds + "inferno_questhide.mp3",
        inf_buildingplace: SOUNDS.infernosounds + "sound_infernoplace.mp3",
        ibankfire: SOUNDS.infernosounds + "sound_ibankfire.mp3",
        ibankland: SOUNDS.infernosounds + "sound_ibankland.mp3",
        icannon: SOUNDS.infernosounds + "inferno_cannonfire.mp3",
        isniper: SOUNDS.infernosounds + "inferno_sniperfire.mp3",
        arise: SOUNDS.attacksounds + "wormzer_arise.mp3",
        dig: SOUNDS.attacksounds + "wormzer_dig.mp3",
        bunkerdoor: SOUNDS.attacksounds + "bunkerdoor.mp3",
        pumpkintreat: SOUNDS.othersounds + "sound_pumpkin_treat.mp3",
        musicattack: SOUNDS.mainmusic + "Music_Attack.mp3",
        musicbuild: SOUNDS.mainmusic + "Music_Building.mp3",
        musicpanic: SOUNDS.mainmusic + "Music_UnderAttack.mp3",
        musiciattack: SOUNDS.infernomusic + "Music_IAttack.mp3",
        musicibuild: SOUNDS.infernomusic + "Music_IBuild.mp3",
        musicipanic: SOUNDS.infernomusic + "Music_IDefense.mp3"
    };

    public static music_volumes: Record<string, number> = {
        musicattack: 0.7,
        musicbuild: 0.6,
        musicpanic: 0.7,
        musicibuild: 0.6,
        musicipanic: 0.7,
        musiciattack: 0.7
    };

    constructor() {}

    public static Setup(): void {
        if (!SOUNDS._setup) {
            SOUNDS._setup = true;
            SOUNDS._musicVolume = SOUNDS._mutedMusic === 0 ? 0.7 : 0;
            if (GLOBAL.StatGet("mute") === 1) {
                SOUNDS.MuteUnmute(true);
            }
            if (GLOBAL.StatGet("mutemusic") === 1) {
                SOUNDS.MuteUnmute(true, "music");
            }
            try {
                for (const key in SOUNDS._sounds) {
                    if (key === "click1") continue;
                    // Preload audio using HTML5 Audio
                    const audio = new Audio(GLOBAL._soundPathURL + SOUNDS._sounds[key]);
                    SOUNDS._sounds[key] = audio;
                }
            } catch (e: any) {
                GLOBAL.Message("There was a problem setting up audio " + e.message);
            }
        }
    }

    public static DamageSoundIDForLevel(level: number): string {
        if (level < 3) return "damage1";
        if (level < 6) return "damage2";
        return "damage3";
    }

    public static DestroySoundIDForLevel(level: number): string {
        if (level < 2) return "destroy1";
        if (level < 5) return "destroy2";
        if (level < 8) return "destroy3";
        return "destroy4";
    }

    public static PlayMusic(musicName: string = ""): void {
        SOUNDS._queuedMusic = musicName;
        if (!SOUNDS._mutedMusic) {
            SOUNDS._musicVolume = SOUNDS.music_volumes[musicName] || 0.7;
        }
    }

    public static PlayMusicB(musicName: string = "", volume: number = 0.7, pan: number = 0, startTime: number = 0): void {
        if (SOUNDS._currentMusic === musicName) return;
        if (!SOUNDS._concurrent[musicName]) {
            SOUNDS._concurrent[musicName] = 1;
        }
        if (SOUNDS._concurrent[musicName] <= 2) {
            SOUNDS._concurrent[musicName] += 1;
            const sound = SOUNDS._sounds[musicName];
            if (sound instanceof Audio) {
                if (SOUNDS._musicChannel) {
                    SOUNDS._musicChannel.pause();
                    SOUNDS._musicChannel.currentTime = 0;
                }
                sound.volume = volume;
                sound.loop = true;
                sound.currentTime = startTime;
                sound.play().catch(() => {});
                SOUNDS._musicChannel = sound;
                SOUNDS._currentMusic = musicName;
            }
        }
    }

    public static Play(soundPath: string = "", volume: number = 0.8, pan: number = 0, loop: number = 1): any {
        if (!GLOBAL._catchup && !SOUNDS._muted) {
            if (!SOUNDS._concurrent[soundPath] || SOUNDS._concurrent[soundPath] <= 2) {
                SOUNDS._concurrent[soundPath] = (SOUNDS._concurrent[soundPath] || 0) + 1;
                const sound = SOUNDS._sounds[soundPath];
                if (sound instanceof Audio) {
                    const clone = sound.cloneNode() as HTMLAudioElement;
                    clone.volume = volume;
                    clone.play().catch(() => {});
                    return clone;
                }
            }
        }
        return null;
    }

    public static Tick(): void {
        for (const soundName in SOUNDS._concurrent) {
            if (SOUNDS._concurrent[soundName] > 0) {
                SOUNDS._concurrent[soundName]--;
            }
        }
        if (SOUNDS._currentMusic !== SOUNDS._queuedMusic) {
            if (SOUNDS._currentMusic && SOUNDS._musicChannel) {
                let currentVolume: number = SOUNDS._musicChannel.volume || 0;
                currentVolume -= 0.05;
                if (currentVolume <= 0) {
                    SOUNDS.PlayMusicB(SOUNDS._queuedMusic || "", SOUNDS._musicVolume, SOUNDS._musicPan);
                } else if (SOUNDS._musicChannel) {
                    SOUNDS._musicChannel.volume = currentVolume;
                }
            } else {
                SOUNDS.PlayMusicB(SOUNDS._queuedMusic || "", SOUNDS._musicVolume, SOUNDS._musicPan);
            }
        }
    }

    public static TutorialStopMusic(): void {
        SOUNDS.MuteUnmute(true, "music");
        SOUNDS._queuedMusic = null;
        SOUNDS._currentMusic = null;
    }

    public static StopAll(): void {
        if (SOUNDS._musicChannel) {
            SOUNDS._musicChannel.pause();
            SOUNDS._musicChannel.currentTime = 0;
        }
    }

    public static Toggle(event: MouseEvent | null = null): void {
        try {
            if (SOUNDS._muted === 0) {
                SOUNDS.MuteUnmute(true);
            } else {
                SOUNDS.MuteUnmute(false);
            }
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
                GLOBAL.StatSet("mute", SOUNDS._muted);
            }
        } catch (e) {
            GLOBAL.Message("There was a problem turning sounds on");
        }
    }

    public static ToggleMusic(event: MouseEvent | null = null): void {
        try {
            if (SOUNDS._mutedMusic === 0) {
                SOUNDS.MuteUnmute(true, "music");
            } else {
                SOUNDS.MuteUnmute(false, "music");
            }
            if (GLOBAL.mode === GLOBAL.e_BASE_MODE.BUILD) {
                GLOBAL.StatSet("mutemusic", SOUNDS._mutedMusic);
            }
        } catch (e) {
            GLOBAL.Message("There was a problem turning the music on");
        }
    }

    public static MuteUnmute(mute: boolean = true, type: string = "snd"): void {
        if (type === "snd") {
            if (mute) {
                const frame = (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) ? 4 : 2;
                if (UI2._top?.mcSound) UI2._top.mcSound.gotoAndStop(frame);
                SOUNDS._muted = 1;
            } else {
                const frame = (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) ? 3 : 1;
                if (UI2._top?.mcSound) UI2._top.mcSound.gotoAndStop(frame);
                SOUNDS._muted = 0;
            }
        } else if (type === "music") {
            if (mute) {
                const frame = (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) ? 4 : 2;
                if (UI2._top?.mcMusic) UI2._top.mcMusic.gotoAndStop(frame);
                SOUNDS._musicVolume = 0;
                SOUNDS._mutedMusic = 1;
            } else {
                const frame = (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) ? 3 : 1;
                if (UI2._top?.mcMusic) UI2._top.mcMusic.gotoAndStop(frame);
                SOUNDS._musicVolume = 0.7;
                SOUNDS._mutedMusic = 0;
                if (SOUNDS._currentMusic === null && SOUNDS._queuedMusic === null) {
                    if (GLOBAL.mode === GLOBAL.e_BASE_MODE.ATTACK || GLOBAL.mode === GLOBAL.e_BASE_MODE.WMATTACK) {
                        SOUNDS.PlayMusic("musicattack");
                    } else {
                        SOUNDS.PlayMusic("musicbuild");
                    }
                }
            }
            if (SOUNDS._musicChannel) {
                SOUNDS._musicChannel.volume = SOUNDS._musicVolume;
            }
        }
    }
}
