/**
 * Enum representing Base mode types for processing base states
 * @enum {string}
 */
export enum BaseMode {
  BUILD = "build",              // Build main yard
  ATTACK = "attack",            // Attack main yard
  WMATTACK = "wmattack",        // Wild monster attack
  VIEW = "view",                // Viewing main yard
  HELP = "help",                // Main yard help

  IBUILD = "ibuild",            // Build inferno yard
  IATTACK = "iattack",          // Attack inferno yard
  IWMATTACK = "iwmattack",      // Inferno wild monster attack
  IDESCENT = "idescent",        // Inferno descent yards
  IVIEW = "iview",              // Viewing inferno yard
  IHELP = "ihelp",              // Inferno help

  WMVIEW = "wmview",            // Viewing wild monsters
  IWMVIEW = "iwmview"           // Viewing wild monsters in the inferno
}

/** 
 * Enum representing base types 
 * @enum {string}
 */
export enum BaseType {
  MAIN = "main",                // Main yard
  OUTPOST = "outpost",          // Outpost yard
  WILDMONSTER = "wildmonster",  // Wild monster yard
  INFERNO = "inferno"           // Inferno yard
}
