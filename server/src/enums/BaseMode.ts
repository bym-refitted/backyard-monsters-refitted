/** Base mode types for processing base states */
export enum BaseMode {
    // Main Yard
    BUILD = "build",        // Build main yard
    ATTACK = "attack",      // Attack main yard
    WMATTACK = "wmattack",  // Wild monster attack
    VIEW = "view",          // Viewing main yard
    HELP = "help",          // Main yard help
  
    // Inferno Yard
    IBUILD = "ibuild",      // Build inferno yard
    IATTACK = "iattack",    // Attack inferno yard
    IWMATTACK = "iwmattack",// Inferno wild monster attack
    IDESCENT = "idescent",  // Inferno descent yards
    IVIEW = "iview",        // Viewing inferno yard
    IHELP = "ihelp",        // Inferno help
  
    // Wild Monster
    WMVIEW = "wmview",      // Viewing wild monsters
    IWMVIEW = "iwmview"     // Viewing wild monsters in the inferno
  }
  