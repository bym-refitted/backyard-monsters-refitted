import { BUILDINGSARROW } from './BUILDINGSARROW';
import { creatureBar } from './creatureBar';
import { Button_CLIP } from './Button_CLIP';
import { frame_CLIP } from './frame_CLIP';

/**
 * ACADEMYPOPUP_CLIP - Base UI clip class for Academy popup
 * Contains all UI element declarations
 * Converted from ActionScript to TypeScript
 */
export class ACADEMYPOPUP_CLIP {
    public bNext!: BUILDINGSARROW;
    public tResourceA: any; // TextField
    public bDamageA!: creatureBar;
    public bA: any; // MovieClip
    public tResourceB: any; // TextField
    public bB: any; // MovieClip
    public tStorageB: any; // TextField
    public tHealthB: any; // TextField
    public time_txt: any; // TextField
    public tName: any; // TextField
    public tHealthA: any; // TextField
    public bStorageB!: creatureBar;
    public tDamageB: any; // TextField
    public tTimeA: any; // TextField
    public bStorageA!: creatureBar;
    public bSpeedA!: creatureBar;
    public bPrevious!: BUILDINGSARROW;
    public tTimeB: any; // TextField
    public tDamageA: any; // TextField
    public bSpeedB!: creatureBar;
    public bContinue!: Button_CLIP;
    public health_txt: any; // TextField
    public txtGuide: any; // TextField
    public housing_txt: any; // TextField
    public after_txt: any; // TextField
    public bHealthB!: creatureBar;
    public bResourceA!: creatureBar;
    public mcImage: any; // MovieClip
    public bResourceB!: creatureBar;
    public mcFrame!: frame_CLIP;
    public tSpeedA: any; // TextField
    public before_txt: any; // TextField
    public bDamageB!: creatureBar;
    public bTimeA!: creatureBar;
    public tSpeedB: any; // TextField
    public bTimeB!: creatureBar;
    public bHealthA!: creatureBar;
    public tStorageA: any; // TextField
    public cost_txt: any; // TextField
    public damage_txt: any; // TextField
    public speed_txt: any; // TextField
    
    constructor() {
        this.frame1();
    }
    
    protected frame1(): void {
        this.stop();
    }
    
    // MovieClip-like methods
    public stop(): void {
        // Implementation for stopping animation
    }
    
    public gotoAndStop(frame: number | string): void {
        // Implementation for going to frame
    }
    
    public addChild(child: any): any {
        // Implementation for adding child
        return child;
    }
    
    public removeChild(child: any): void {
        // Implementation for removing child
    }
}
