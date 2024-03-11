// ReBoot
// #ID = 19792
// Hash: 652c90e4d6be2305655287c8f3545d11
// No way! This isn't a game! It's a torture device!

// Initial set by Talz. All comments and opinions in this version are my own. As this is my very first set, code is very unoptimized.

// Table of Contents
    // [CONSTANT] Constant values
        // [FRAMES] Frames
        // [SEC_ID] Sector ID
        // [LEV_ID] Level ID
        // [TIMER] The on-screen timer for Tears
        // [CUTSCENES] Status of Tears and End-of-Level states
        // [END_STATE] Status of individual level endings
        // [CHEAT] Naughty little cheater.
        // [CHARS] Secret Character Flags
    // [VARIABLE] Functions that change by Sector
        // [HEALTH] Information on HP values
        // [LIVES] How much of your life you're wasting on this game
        // [AMMO] The stuff you throw at the things you want to die
    // [CHEEVS] Where the achievements are
        // [CHEEV_PROG] Progression
        // [CHEEV_GOOD_END] Level Good Endings
        // [CHEEV_VICT] Victory Conditions (any of these = beat)
        // [CHEEV_COLLECT] Collectables - General obtaining Lives, Weapons, Upgrades, etc.
        // [CHEEV_FUN] Just-for-Fun, includes bad endings, etc.
        // [CHEEV_CHALLENGE] Challenge Achievements through the whole game
        // [CHEEV_BAUD] Baudway Specific Achievements
            // [CHEEV_LV1]
            // [CHEEV_LV2]
            // [CHEEV_LV3]
    // [CHEEV_CITE] Cit-E Specific Achievements
            // [CHEEV_LV4]
            // [CHEEV_LV5]
            // [CHEEV_LV6] (Meg-ABC Boss)
    // [CHEEV_BEVHILLS] Beverly Hills Specific Achievements
            // [CHEEV_LV7]
            // [CHEEV_LV8]
            // [CHEEV_LV9]
            // [CHEEV_LV10] (Web Creature Boss)
    // [CHEEV_KITS] Kits Specific Achievements
            // [CHEEV_LV11]
            // [CHEEV_LV12] (Giant Binome Boss)
    // [CHEEV_FPP] Floating Point Park Specific Achievements
            // [CHEEV_LV13]
            // [CHEEV_LV14] (Clash Boss)
    // [CHEEV_GPRIME] G-Prime Specific Achievements
            // [CHEEV_LV15]
            // [CHEEV_LV16]
            // [CHEEV_LV17]
            // [CHEEV_LV18] (Megabyte Boss)
    // [CHEEV_HEX] Lost Angles Specific Achievements
            // [CHEEV_LV19] (Hexadecimal Boss)


// =======================
// [CNST] Constant Values 
// =======================

 // These addresses are static no matter where you are in the game.

// ======================
// [FRAMES] Frame Timers
// ======================

// These 32-bit timers measure frames. They all do so in different ways, and will be crucial for achievement logic.

function Gameplay_Paused() => byte(0x46e40) == 0
function Gameplay_Active() => byte(0x46e40) == 1
  // A quick check for some achievements for when the gameplay is active. Bugs out sometimes on achievements with a Measured/Trigger icon.

function Frames_Idle() => dword(0x4619c)
  // Value increases while no key is pressed. Resets to 0 when any key is pressed.

function Frames_Gameplay() => dword(0x4639c)
  // Value increases when level is active. Pauses on Game Pause, and continues during in-game cutscenes

function Frames_Cutscene() => dword(0x463a0)
  // Value increases during cutscenes, and resets during gameplay. 
  // Unfortunately, during gameplay, the value flickers every frame between $0 and $100 (256).
    End_Primer = 0x3000 // To get around this, the Primer is set to activate ONLY if it goes to a designated point.
    End_Trigger = 0x0 // This will work with the End_Trigger function to trigger the achievement.

function Frames_GameplayOnly() => dword(0x463b0)   
  // Similar to Frames_Gameplay, but it does freeze during cutscenes.

function Frames_Level() => dword(0x463b4)
  // Similar to the previous trackers, but it resets on every level and continues while paused. Unlike the others, this one runs at the gameplay speed of 30 fps as opposed to the system's 60.

// ===================
// [SEC_ID] Sector ID
// ===================

// A 32-bit flag to determine which 'Sector' of the game you're in.

  // In the TV show's lore, each sector was a district of the city. There were six of them, all equal size, plus the small island off the coast, Lost Angles.
  // Due to the game's unoptimized code, each sector has its own variables, meaning I had to find health values and such for all seven of them. Fun.
  // In level-specific achievements, I'll be using this in concert with the Level ID to add a level of redundant protection.

function sector_ID() => dword(0x45ec4)

  Menu = 0x0 // The Main Menu. Self explanatory.
  Baudway = 0x1 // Baudway: The business and shopping district, and home of Dot's Diner. In Level 3, you travel into the deepest levels of the city, where crime is rampant, and the home of Al's Wait and Eat, the slowest restaurant in Mainframe.
  CitE = 0x2 // Cit E: The downtown business sector, filled with skyscrapers and roads. Was never featured in the show, and most supplimental material lists this as "Wall Street".
  BevHills = 0x3 // Beverly Hills: The Rich Side of Town. All fancy-like. Was never featured in the show.
  Kits = 0x4 // Kits: The main residential district. Bob lives in an apartment building topped by a large 8-ball, as seen in Level 11. This building has met an unfortunate fate several times in the series.
  FPP = 0x5 // Floating Point Park: A nice big park. The name is apt, as it consists of many floating islands. Normally, zip-boards are able to easily navigate between them, but for whatever reason, in this game, Bob's zip-board is broken. 
  GPrime = 0x6 // G-Prime: The heavy industrial sector. Factories and pollution galore. Megabyte has his headquarters here in the towering Silicon Tor.
  Hex = 0x7 // Lost Angles: The ruins of what was once a thriving city, the only resident is the reclusive and insane virus, Hexadecimal. Connected by a twisted bridge, most Mainframers know to stay away.

// =============================
// [LEV_ID] The level identifier
// =============================

function level_ID() => dword(0x45ec8)

 MM = 0x0 // Main Menu
 Lv1 = 0x1 // Baudway 1 (Level 1)
 Lv2 = 0x2 // Baudway 2 (Level 2)
 Lv3 = 0x3 // Baudway 3 (Level 3)
 Lv4 = 0x4 // Cit E 1 (Level 4)
 Lv5 = 0x5 // Cit E 2 (Level 5)
 Lv6 = 0x6 // Cit E 3 (Level 6) (MEG-ABC Boss)
 Lv7 = 0x7 // Beverly Hills 1 (Level 7)
 Lv8 = 0x8 // Beverly Hills 2 (Level 8)
 Lv9 = 0x9 // Beverly Hills 3 (Level 9)
 Lv10 = 0xA // Beverly Hills 4 (Level 10) (Web Creature Boss)
 Lv11 = 0xB // Kits 1 (Level 11)
 Lv12 = 0xC // Kits 2 (Level 12) (Giant Binome Boss)
 Lv13 = 0xD // Floating Point 1 (Level 13)
 Lv14 = 0xE // Floating Point 2 (Level 14) (Clash Boss)
 Lv15 = 0xF // G-Prime 1 (Level 15)
 Lv16 = 0x10 // G-Prime 2 (Level 16)
 Lv17 = 0x11 // G-Prime 3 (Level 17)
 Lv18 = 0x12 // G-Prime 4 (Level 18) (Megabyte Boss)
 Lv19 = 0x13 // Lost Angles (Level 19) (Hexadecimal Boss)

// ========================
// [TIMER] On-Screen Timers
// ========================

ScreenTimers = [
ScreenTimer_Baudway => dword(0x1131d8),
ScreenTimer_CitE => dword(0x112348),
ScreenTimer_BevHills => dword(0x11329c),
ScreenTimer_Kits => dword(0x114c80),
ScreenTimer_FPP => dword(0x11232c),
ScreenTimer_GPrime => dword(0x1196a0)
]

// ================================
// [CUTSCENES] Tear/Cutscene Values
// ================================

// These are often used to measure the state of Tears and/or Level Ending.
// These do not work in Boss levels.

function Cutscenes_Baudway() => byte(0x112228)
function Cutscenes_CitE() => byte(0x111390)
function Cutscenes_BevHills() => byte(0x112314)
function Cutscenes_Kits() => byte(0x113bc8) 
function Cutscenes_FPP() => byte(0x111440) 
function Cutscenes_GPrime() => byte(0x118614)

  TearForm = 0x1 // Tear Begins to Form (Triggers cutscene) - Note that if you skip the cutscene, the value flips to $2 for the rest of the form time. Tear is not mendable until $3.
  TearBegin = 0x3 // Tear has formed, is mendable, countdown begins
  Dead = 0x4 // Player has died, lose a life, respawn
  TearMend = 0x7 // Tear is Mended. Resets to $1 when the next Tear forms
  LevelEnd = 0xF // Level Complete
  
  TearStatus = [
  Cutscenes_Baudway(),
  Cutscenes_CitE(),  
  Cutscenes_BevHills(),
  Cutscenes_Kits(),
  Cutscenes_FPP(),
  Cutscenes_GPrime(),
  ]

// ==========================
// [END_STATE] Ending States 
// ==========================

// Flags that check the individual level ending states for Good/Bad endings.

// The game has multiple endings. The only way to get the best ending is to mend all the Tears in the levels without letting any of them explode.
// Letting Tears explode in 1-5 levels triggers the Bad Ending.
// Letting Tears explode in more than 5 triggers the Ugly Ending.

// Each level is only counted once. Letting several Tears explode in a single level still only counts as once.

// All are 32-bit flags for the purposes of mapping, though only one byte is used, making the others pretty much wasted space.
// As far as level ending cutscenes are concerned, it checks the status for the rest of the Sector at the end of said sector. 

// There is no ending cutscene in Level 2, so failure in Level 2 means a bad cutscene in Level 3's ending, and so on.

// $2 Good Ending
// $1 Bad Ending
// $0 Uncleared

// I am aware this can be compressed, but that is beyond my current knowledge. It all reads the same in the logic interpreter anyway.

EndingState_Lv1 = dword(0x45ee0)
EndingState_Lv2 = dword(0x45ee4)
EndingState_Lv3 = dword(0x45ee8)
EndingState_Lv4 = dword(0x45eec)
EndingState_Lv5 = dword(0x45ef0)
EndingState_Lv6 = dword(0x45ef4)
EndingState_Lv7 = dword(0x45ef8)
EndingState_Lv8 = dword(0x45efc)
EndingState_Lv9 = dword(0x45f00)
EndingState_Lv10 = dword(0x45f04)
EndingState_Lv11 = dword(0x45f08)
EndingState_Lv12 = dword(0x45f0c)
EndingState_Lv13 = dword(0x45f10)
EndingState_Lv14 = dword(0x45f14)
EndingState_Lv15 = dword(0x45f18)
EndingState_Lv16 = dword(0x45f1c)
EndingState_Lv17 = dword(0x45f20)
EndingState_Lv18 = dword(0x45f24)
EndingState_Lv19 = dword(0x45f28)

  EndGood = 0x2
  EndBad = 0x1

 // A collection of the ending states for the purpose of Good Ending achievements.
    
    EndingState_Baudway = [
    EndingState_Lv1, EndingState_Lv2, EndingState_Lv3
]
    EndingState_CitE = [
    EndingState_Lv4, EndingState_Lv5, EndingState_Lv6
]
    EndingState_BevHills = [
    EndingState_Lv7, EndingState_Lv8, EndingState_Lv9, EndingState_Lv10
]
    EndingState_Kits = [
    EndingState_Lv11, EndingState_Lv12
]
    EndingState_FPP = [
    EndingState_Lv13, EndingState_Lv14
]
    EndingState_GPrime = [
    EndingState_Lv15, EndingState_Lv16, EndingState_Lv17, EndingState_Lv18
]
    EndingState_Final = [
    EndingState_Lv1, EndingState_Lv2, EndingState_Lv3, EndingState_Lv4, EndingState_Lv5, 
    EndingState_Lv6, EndingState_Lv7, EndingState_Lv8, EndingState_Lv9, EndingState_Lv10,
    EndingState_Lv11, EndingState_Lv12, EndingState_Lv13, EndingState_Lv14, EndingState_Lv15,
    EndingState_Lv16, EndingState_Lv17, EndingState_Lv18, EndingState_Lv19
    
]

// =====================
// [CHEAT] Cheater Flags
// =====================

// Naughty, naughty, using these. No, I didn't use these extensively during development, why would you ask such a thing?!
// Codes are entered in the main menu.

 CheatFlag = [
    bit4(0x45ed0), // < v > < ^ R2 L1 ^ < >   Flight Mode, press Square to Hover
    bit0(0x45ed2), // > L1 ^ > v L1 R1 ^ v <  Unlimited Glitch Energy
    bit1(0x45ed2), // ^ L1 v ^ < R1 L2 v < >  All Weapons and Glitch Upgrades
    bit2(0x45ed2) // v R1 < > v L2 R2 < > ^  Free Shield with Every Glitch Pickup
]
        True = 0x1
        False = 0x0

// ==============================
// [CHARS] Secret Character Flags
// ==============================

// For some reason that I just can't figure out, (/s) only one of these can be active at once. 
// Interestingly, these Character models ONLY appear in this way.
// Codes are entered in the main menu.

function Char_Dot() => bit0(0x45ed0) == 1 // < R1 > ^ v R2 L1 > ^ v  Play as Dot
function Char_Enzo() => bit1(0x45ed0) == 1 // ^ < v < v L1 R1 > v >  Play as Enzo

// ===================================
// [HEALTH] Player Health Information 
// ===================================

// Legit Maximum HP is $3E8 (1000)
    // (On a side-tangent, the address is 32-bit, and can be increased to 0x7FFFFFF (134217727).

// HP Displays are as follows:
    // $3E8 (1000) - GREEN
    // $29A (666) - YELLOW
    // $14D (333) - RED   
        // (Begins giving a warning beep at $12B (299))

function HP_Baudway() => word(0x106ea2)
function HP_CitE() => word(0x1061e6)
function HP_BevHills() => word(0x106d7e)
function HP_Kits() => word(0x108a0e)
function HP_FPP() => word(0x15338a)
function HP_GPrime() => word(0x10ce4a)
function HP_Hex() => word(0xfb32a)

    HP_Full = 0x3E8
    HP_Yellow = 0x29A
    HP_Danger = 0x12B // Danger zone is when an audible alarm starts beeping.

// ========================================================
// [LIVES] How much of your life you've wasted on this game
// ========================================================

function Lives_Baudway() => word(0x112f50)
function Lives_CitE() => word(0x1120c0) 
function Lives_BevHills() => word(0x113014) 
function Lives_Kits() => word(0x1149fc) 
function Lives_FPP() => word(0x1120a4) 
function Lives_GPrime() => word(0x11941c) 
function Lives_Hex() => word(0x106cbc) 

// =========================================================
// [WEAPONS] The thing you point at whatever you want to die
// =========================================================

// Baudway

    // Primaries
function Weapon_Pistol1_Baudway() => bit0(0x112f38)
function Weapon_Pistol2_Baudway() => bit1(0x112f38)
function Weapon_Pistol3_Baudway() => bit2(0x112f38)
function Weapon_Blaster1_Baudway() => bit3(0x112f38)
function Weapon_Blaster2_Baudway() => bit4(0x112f38)
function Weapon_Blaster3_Baudway() => bit5(0x112f38)
function Weapon_Rocket1_Baudway() => bit6(0x112f38)
function Weapon_Rocket2_Baudway() => bit7(0x112f38)
function Weapon_Rocket3_Baudway() => bit0(0x112f39)

    // Glitch Powers
function Weapon_Mortar_Baudway() => bit2(0x112f39)
function Weapon_Flame_Baudway() => bit3(0x112f39)
function Weapon_Box_Baudway() => bit6(0x112f39)
function Weapon_Vamp_Baudway() => bit7(0x112f39)
function Weapon_AV_Baudway() => bit1(0x112f3a)

Weapons_Baudway = [
Weapon_Pistol3_Baudway(),
Weapon_Blaster3_Baudway(),
Weapon_Rocket3_Baudway(),
Weapon_Mortar_Baudway(),
Weapon_Flame_Baudway(),
Weapon_Box_Baudway(),
Weapon_Vamp_Baudway(),
Weapon_AV_Baudway()
]

// Cit E

    // Primaries
function Weapon_Pistol1_CitE() => bit0(0x1120a8)
function Weapon_Pistol2_CitE() => bit1(0x1120a8)
function Weapon_Pistol3_CitE() => bit2(0x1120a8)
function Weapon_Blaster1_CitE() => bit3(0x1120a8)
function Weapon_Blaster2_CitE() => bit4(0x1120a8)
function Weapon_Blaster3_CitE() => bit5(0x1120a8)
function Weapon_Rocket1_CitE() => bit6(0x1120a8)
function Weapon_Rocket2_CitE() => bit7(0x1120a8)
function Weapon_Rocket3_CitE() => bit0(0x1120a9)

    // Glitch Powers
function Weapon_Mortar_CitE() => bit2(0x1120a9)
function Weapon_Flame_CitE() => bit3(0x1120a9)
function Weapon_Box_CitE() => bit6(0x1120a9)
function Weapon_Vamp_CitE() => bit7(0x1120a9)
function Weapon_AV_CitE() => bit1(0x1120aa)

Weapons_CitE = [
Weapon_Pistol3_CitE(),
Weapon_Blaster3_CitE(),
Weapon_Rocket3_CitE(),
Weapon_Mortar_CitE(),
Weapon_Flame_CitE(),
Weapon_Box_CitE(),
Weapon_Vamp_CitE(),
Weapon_AV_CitE()
]

// Beverly Hills

    // Primaries
function Weapon_Pistol1_BevHills() => bit0(0x112ffc)
function Weapon_Pistol2_BevHills() => bit1(0x112ffc)
function Weapon_Pistol3_BevHills() => bit2(0x112ffc)
function Weapon_Blaster1_BevHills() => bit3(0x112ffc)
function Weapon_Blaster2_BevHills() => bit4(0x112ffc)
function Weapon_Blaster3_BevHills() => bit5(0x112ffc)
function Weapon_Rocket1_BevHills() => bit6(0x112ffc)
function Weapon_Rocket2_BevHills() => bit7(0x112ffc)
function Weapon_Rocket3_BevHills() => bit0(0x112ffd)

    // Glitch Powers
function Weapon_Mortar_BevHills() => bit2(0x112ffd)
function Weapon_Flame_BevHills() => bit3(0x112ffd)
function Weapon_Box_BevHills() => bit6(0x112ffd)
function Weapon_Vamp_BevHills() => bit7(0x112ffd)
function Weapon_AV_BevHills() => bit1(0x112ffe)

Weapons_BevHills = [
Weapon_Pistol3_BevHills(),
Weapon_Blaster3_BevHills(),
Weapon_Rocket3_BevHills(),
Weapon_Mortar_BevHills(),
Weapon_Flame_BevHills(),
Weapon_Box_BevHills(),
Weapon_Vamp_BevHills(),
Weapon_AV_BevHills()
]

// Kits

    // Primaries
function Weapon_Pistol1_Kits() => bit0(0x1149e4)
function Weapon_Pistol2_Kits() => bit1(0x1149e4)
function Weapon_Pistol3_Kits() => bit2(0x1149e4)
function Weapon_Blaster1_Kits() => bit3(0x1149e4)
function Weapon_Blaster2_Kits() => bit4(0x1149e4)
function Weapon_Blaster3_Kits() => bit5(0x1149e4)
function Weapon_Rocket1_Kits() => bit6(0x1149e4)
function Weapon_Rocket2_Kits() => bit7(0x1149e4)
function Weapon_Rocket3_Kits() => bit0(0x1149e5)

    // Glitch Powers
function Weapon_Mortar_Kits() => bit2(0x1149e5)
function Weapon_Flame_Kits() => bit3(0x1149e5)
function Weapon_Box_Kits() => bit6(0x1149e5)
function Weapon_Vamp_Kits() => bit7(0x1149e5)
function Weapon_AV_Kits() => bit1(0x1149e6)

Weapons_Kits = [
Weapon_Pistol3_Kits(),
Weapon_Blaster3_Kits(),
Weapon_Rocket3_Kits(),
Weapon_Mortar_Kits(),
Weapon_Flame_Kits(),
Weapon_Box_Kits(),
Weapon_Vamp_Kits(),
Weapon_AV_Kits()
]

// Floating Point Park

    // Primaries
function Weapon_Pistol1_FPP() => bit0(0x11208c)
function Weapon_Pistol2_FPP() => bit1(0x11208c)
function Weapon_Pistol3_FPP() => bit2(0x11208c)
function Weapon_Blaster1_FPP() => bit3(0x11208c)
function Weapon_Blaster2_FPP() => bit4(0x11208c)
function Weapon_Blaster3_FPP() => bit5(0x11208c)
function Weapon_Rocket1_FPP() => bit6(0x11208c)
function Weapon_Rocket2_FPP() => bit7(0x11208c)
function Weapon_Rocket3_FPP() => bit0(0x11208d)

    // Glitch Powers
function Weapon_Mortar_FPP() => bit2(0x11208d)
function Weapon_Flame_FPP() => bit3(0x11208d)
function Weapon_Box_FPP() => bit6(0x11208d)
function Weapon_Vamp_FPP() => bit7(0x11208d)
function Weapon_AV_FPP() => bit1(0x11208e)

Weapons_FPP = [
Weapon_Pistol3_FPP(),
Weapon_Blaster3_FPP(),
Weapon_Rocket3_FPP(),
Weapon_Mortar_FPP(),
Weapon_Flame_FPP(),
Weapon_Box_FPP(),
Weapon_Vamp_FPP(),
Weapon_AV_FPP()
]

// G-Prime

    // Primaries
function Weapon_Pistol1_GPrime() => bit0(0x119404)
function Weapon_Pistol2_GPrime() => bit1(0x119404)
function Weapon_Pistol3_GPrime() => bit2(0x119404)
function Weapon_Blaster1_GPrime() => bit3(0x119404)
function Weapon_Blaster2_GPrime() => bit4(0x119404)
function Weapon_Blaster3_GPrime() => bit5(0x119404)
function Weapon_Rocket1_GPrime() => bit6(0x119404)
function Weapon_Rocket2_GPrime() => bit7(0x119404)
function Weapon_Rocket3_GPrime() => bit0(0x119405)

    // Glitch Powers
function Weapon_Mortar_GPrime() => bit2(0x119405)
function Weapon_Flame_GPrime() => bit3(0x119405)
function Weapon_Box_GPrime() => bit6(0x119405)
function Weapon_Vamp_GPrime() => bit7(0x119405)
function Weapon_AV_GPrime() => bit1(0x119406)

Weapons_GPrime = [
Weapon_Pistol3_GPrime(),
Weapon_Blaster3_GPrime(),
Weapon_Rocket3_GPrime(),
Weapon_Mortar_GPrime(),
Weapon_Flame_GPrime(),
Weapon_Box_GPrime(),
Weapon_Vamp_GPrime(),
Weapon_AV_GPrime()
]
// Lost Angles

    // Primaries
function Weapon_Pistol1_Hex() => bit0(0x106ca4)
function Weapon_Pistol2_Hex() => bit1(0x106ca4)
function Weapon_Pistol3_Hex() => bit2(0x106ca4)
function Weapon_Blaster1_Hex() => bit3(0x106ca4)
function Weapon_Blaster2_Hex() => bit4(0x106ca4)
function Weapon_Blaster3_Hex() => bit5(0x106ca4)
function Weapon_Rocket1_Hex() => bit6(0x106ca4)
function Weapon_Rocket2_Hex() => bit7(0x106ca4)
function Weapon_Rocket3_Hex() => bit0(0x106ca5)

    // Glitch Powers
function Weapon_Mortar_Hex() => bit2(0x106ca5)
function Weapon_Flame_Hex() => bit3(0x106ca5)
function Weapon_Box_Hex() => bit6(0x106ca5)
function Weapon_Vamp_Hex() => bit7(0x106ca5)
function Weapon_AV_Hex() => bit1(0x106ca6)

Weapons_Hex = [
Weapon_Pistol3_Hex(),
Weapon_Blaster3_Hex(),
Weapon_Rocket3_Hex(),
Weapon_Mortar_Hex(),
Weapon_Flame_Hex(),
Weapon_Box_Hex(),
Weapon_Vamp_Hex(),
Weapon_AV_Hex()
]

Weapons_Mortar = [
Weapon_Mortar_Baudway(),
Weapon_Mortar_CitE(),
Weapon_Mortar_BevHills(),
Weapon_Mortar_Kits(),
Weapon_Mortar_FPP(),
Weapon_Mortar_GPrime(),
Weapon_Mortar_Hex()
]

Weapons_Flame = [
Weapon_Flame_Baudway(),
Weapon_Flame_CitE(),
Weapon_Flame_BevHills(),
Weapon_Flame_Kits(),
Weapon_Flame_FPP(),
Weapon_Flame_GPrime(),
Weapon_Flame_Hex()
]

Weapons_Box = [
Weapon_Box_Baudway(),
Weapon_Box_CitE(),
Weapon_Box_BevHills(),
Weapon_Box_Kits(),
Weapon_Box_FPP(),
Weapon_Box_GPrime(),
Weapon_Box_Hex()
]

Weapons_Vamp = [
Weapon_Vamp_Baudway(),
Weapon_Vamp_CitE(),
Weapon_Vamp_BevHills(),
Weapon_Vamp_Kits(),
Weapon_Vamp_FPP(),
Weapon_Vamp_GPrime(),
Weapon_Vamp_Hex()
]
Weapons_AV = [
Weapon_AV_Baudway(),
Weapon_AV_CitE(),
Weapon_AV_BevHills(),
Weapon_AV_Kits(),
Weapon_AV_FPP(),
Weapon_AV_GPrime(),
Weapon_AV_Hex()
]
Weapons_Blaster = [
Weapon_Blaster1_Baudway(),
Weapon_Blaster1_CitE(),
Weapon_Blaster1_BevHills(),
Weapon_Blaster1_Kits(),
Weapon_Blaster1_FPP(),
Weapon_Blaster1_GPrime(),
Weapon_Blaster1_Hex()
]

Weapons_Rocket = [
Weapon_Rocket1_CitE(),
Weapon_Rocket1_BevHills(),
Weapon_Rocket1_Kits(),
Weapon_Rocket1_FPP(),
Weapon_Rocket1_GPrime(),
Weapon_Rocket1_Hex()
]

// ========================================================
// [AMMO] The things you throw at whatever you want to die
// ========================================================

// Baudway
function Ammo_Prime_Baudway() => byte(0x11319c) // Blaster, Rockets, Grapple
function Ammo_Mortar_Baudway() => byte(0x112d7c) // Mortar: Essentially Grenades
function Ammo_Flame_Baudway() => byte(0x112da4) // Flamethrower
function Ammo_Box_Baudway() => byte(0x112e1c) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_Baudway() => byte(0x112e44) // Vampire: Drains HP from enemies
function Ammo_AV_Baudway()  => byte(0x112e94) // Anti-Virus Causes 

// Cit-E
function Ammo_Prime_CitE()  => byte(0x11230c) // Blaster, Rockets, Grapple
function Ammo_Mortar_CitE() => byte(0x111eed) // Mortar: Essentially Grenades
function Ammo_Flame_CitE() => byte(0x111f14) // Flamethrower
function Ammo_Box_CitE() => byte(0x111f8c) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_CitE() => byte(0x111fb4) // Vampire: Drains HP from enemies
function Ammo_AV_CitE()  => byte(0x112004) // Anti-Virus Causes turrets to attack other enemies

// Beverly Hills
function Ammo_Prime_BevHills()  => byte(0x113260) // Blaster, Rockets, Grapple
function Ammo_Mortar_BevHills() => byte(0x112e40) // Mortar: Essentially Grenades
function Ammo_Flame_BevHills() => byte(0x112e69) // Flamethrower
function Ammo_Box_BevHills() => byte(0x112ee0) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_BevHills() => byte(0x112f09) // Vampire: Drains HP from enemies
function Ammo_AV_BevHills()  => byte(0x112f58) // Anti-Virus Causes turrets to attack other enemies

// Kits
function Ammo_Prime_Kits()  => byte(0x114c48) // Shared between Blaster, Rockets, Grapple
function Ammo_Mortar_Kits() => byte(0x114828) // Mortar: Essentially Grenades
function Ammo_Flame_Kits() => byte(0x114850) // Flamethrower
function Ammo_Box_Kits() => byte(0x1148c9) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_Kits() => byte(0x1148f0) // Vampire: Drains HP from enemies
function Ammo_AV_Kits()  => byte(0x114940) // Anti-Virus Causes turrets to attack other enemies

// Floating Point Park
function Ammo_Prime_FPP()  => byte(0x1122f0) // Shared between Blaster, Rockets, Grapple
function Ammo_Mortar_FPP() => byte(0x111ed0) // Mortar: Essentially Grenades
function Ammo_Flame_FPP() => byte(0x111ef8) // Flamethrower
function Ammo_Box_FPP() => byte(0x111f70) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_FPP() => byte(0x111f98) // Vampire: Drains HP from enemies
function Ammo_AV_FPP()  => byte(0x111fe8) // Anti-Virus Causes turrets to attack other enemies

// G-Prime
function Ammo_Prime_GPrime()  => byte(0x119668) // Shared between Blaster, Rockets, Grapple
function Ammo_Mortar_GPrime() => byte(0x119248) // Mortar: Essentially Grenades
function Ammo_Flame_GPrime() => byte(0x119270) // Flamethrower
function Ammo_Box_GPrime() => byte(0x1192e8) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_GPrime() => byte(0x119310) // Vampire: Drains HP from enemies
function Ammo_AV_GPrime()  => byte(0x119360) // Anti-Virus Causes turrets to attack other enemies

// Lost Angles
function Ammo_Prime_Hex()  => byte(0x106f08) // Shared between Blaster, Rockets, Grapple
function Ammo_Mortar_Hex() => byte(0x106ae8) // Mortar: Essentially Grenades
function Ammo_Flame_Hex() => byte(0x106b10) // Flamethrower
function Ammo_Box_Hex() => byte(0x106b88) // Box Gun: Temporarily freezes enemies. They cannot attack nor be attacked while frozen.
function Ammo_Vamp_Hex() => byte(0x106bb0) // Vampire: Drains HP from enemies
function Ammo_AV_Hex()  => byte(0x106c00) // Anti-Virus Causes turrets to attack other enemies

// =====================================
// [CHEEV_PROG] Progression Achievements
// =====================================

achievement(
    title = "What Do I Look Like, a Nanny?!",
    description = "Complete Level 1",
    points = 2,
    id = 403312,
    badge = "456249",
    trigger =
        sector_ID() == Baudway // Checks if Sector is correct
        && level_ID() == Lv1 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer)) // Checks if the Cutscene Timer has begun to increment past its false-positive safety zone
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
 
achievement(
    title = "Level 31?! No Way!",
    description = "Complete Baudway Sector",
    points = 5,
    id = 403313,
    badge = "456258",
    trigger =
        sector_ID() == Baudway // Checks if Sector is correct
        && level_ID() == Lv3 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer)) // Checks if the Cutscene Timer has begun to increment past its false-positive safety zone
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && (never(Frames_Level() == 0x0)) // To prevent the achievement from popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )

achievement(
    title = "It's the ABCs! They've turned on us!",
    description = "Complete Cit E",
    points = 5,
    id = 403314,
    badge = "456251",
    trigger =
        sector_ID() == CitE // Checks if Sector is correct
        && level_ID() == Lv6 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer has begun to increment past its false-positive safety zone
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && (never(Frames_Level() == 0x0)) // Resets when level is resets (to fix a bug)
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
 
achievement(
    title = "Don't Let Turbo Find Out",
    description = "Complete Beverly Hills",
    points = 5,
    id = 403315,
    badge = "457229",
    trigger =
        sector_ID() == BevHills // Checks if Sector is correct
        && level_ID() == Lv10 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D  && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
 
achievement(
    title = "Bride of Frankenome",
    description = "Complete Kits Sector",
    points = 5,
    id = 403311,
    badge = "456257",
    trigger =
        sector_ID() == Kits // Checks if Sector is correct
        && level_ID() == Lv12 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )

achievement(
    title = "And That’s Their (Non-Canon) Origin Story",
    description = "Complete Floating Point Park",
    points = 10,
    id = 403316,
    badge = "456253",
    trigger =
        sector_ID() == FPP // Checks if Sector is correct
        && level_ID() == Lv14 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )

achievement(
    title = "Not a Guitar This Time",
    description = "Complete G-Prime",
    points = 10,
    id = 403317,
    badge = "456254",
    trigger =
        sector_ID() == GPrime// Checks if Sector is correct
        && level_ID() == Lv18 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && (never(Frames_Level() == 0x0))
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
 
// =========================================
// [CHEEV_GOOD_END] Good Ending Achievements
// =========================================

// These require the player to Mend all Tears without them exploding.
// Players can get Good Endings in most sectors by clearing them in this way.
// But the only way to get the good final ending is to get the good ending in EVERY stage.
// If Ending Status for any level is anything other than $2, then they are destined for the Bad Ending or worse.
   
achievement(
    title = "Dot's Diner: Fastest Food in Mainframe",
    description = "Complete Level 1 without letting any Tears explode",
    points = 5,
    id = 403748,
    badge = "457034",
    trigger =
        sector_ID() == Baudway // Checks if Sector is correct
        && level_ID() == Lv1 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer))// Checks if the Cutscene Timer has begun to increment
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && (EndingState_Lv1 == EndGood) // Checks Ending Status
    )

achievement(
    title = "Slow Food Doesn’t Go Fast. That’s Why It’s Slow",
    description = "Complete Baudway Sector without letting any Tears explode",
    points = 5,
    id = 403751,
    badge = "457037",
    trigger = 
        sector_ID() == Baudway // Checks if Sector is correct
        && level_ID() == Lv3 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer))// Checks if the Cutscene Timer has begun to increment
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && (never(Frames_Level() == 0x0)) // To prevent the achievement from popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_Baudway, end => end == EndGood) // Checks Ending Status
    )
 
achievement(
    title = "I Say, Binky! Bob's on the Job!",
    description = "Complete Cit E without letting any Tears explode",
    points = 10,
    id = 403750,
    badge = "457036",
    trigger =
        sector_ID() == CitE // Checks if Sector is correct
        && level_ID() == Lv6 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer))// Checks if the Cutscene Timer has begun to increment
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && (never(Frames_Level() == 0x0)) // To prevent the achievement from popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_CitE, end => end == EndGood) // Checks Ending Status
    )
 
achievement(
    title = "Trust No One",
    description = "Complete Beverly Hills without letting any Tears explode",
    points = 10,
    id = 403752,
    badge = "457038",
    trigger = sector_ID() == BevHills // Checks if Sector is correct
        && level_ID() == Lv10 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_BevHills, end => end == EndGood) // Checks Ending Status
    )
 
achievement(
    title = "NOT Approved by the BS&P",
    description = "Complete Kits Sector without letting any Tears explode",
    points = 10,
    id = 403753,
    badge = "457039",
    trigger =
        sector_ID() == Kits // Checks if Sector is correct
        && level_ID() == Lv12 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_Kits, end => end == EndGood) // Checks Ending Status
    )
 
achievement(
    title = "C'mon! Just One More Circuit",
    description = "Complete Floating Point Park without letting any Tears explode",
    points = 10,
    trigger =
        sector_ID() == FPP // Checks if Sector is correct
        && level_ID() == Lv14 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_FPP, end => end == EndGood) // Checks Ending Status
    )
 
achievement(
    title = "You Owe Me One, Megabyte!",
    description = "Complete G-Prime without letting any Tears explode",
    points = 10,
    trigger =
        sector_ID() == GPrime// Checks if Sector is correct
        && level_ID() == Lv18 // Checks if Level is correct
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && all_of(EndingState_Kits, end => end == EndGood) // Checks Ending Status
    )

// ===============================
// [CHEEV_VICT] Victory Conditions
// ===============================

// Special thanks to BoomEX for the heavy assistance in coding this one!
// It was a bit complicated trying to figure out how to set the Bad Ending achievement in particular to trigger ONLY with 1-5 failed levels. 

achievement(
    title = "Everything is Alphanumeric!",
    description = "Win the game with the Good Ending. Wait, did you just nullify everyone?",
    type = "win_condition",
    points = 25,
    id = 403754,
    badge = "457040",
    trigger = 
        never(sum_of(EndingState_Final,ending=>prev(ending)) != sum_of(EndingState_Final,ending=>ending)) // Resets whenever a level is cleared
        && tally_of(EndingState_Final,19,ending=>once(ending == EndGood)) // Only triggers when EVERY level has a value of 2 (Good Ending)
        && none_of(EndingState_Final,ending=>ending==0) // Makes sure all levels are cleared.
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused()// Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D
        && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1)// Disables Achievement if any Cheat Active
    )
 
achievement( title = "Prepare Yourselves... For the Hunt",
    description = "Win the game with the Bad Ending. It sure would be awful if the game ended on a cliffhanger, huh?",
    id = 403318,
    badge = "456255",
    type = "win_condition",
    points = 10,
    trigger =
        never(sum_of(EndingState_Final,ending=>prev(ending)) != sum_of(EndingState_Final,ending=>ending)) // Resets whenever a level is cleared.
        && tally_of(EndingState_Final,14,ending=>once(ending == EndGood)) // Checks if number of 'failed' levels is more than 0, but less than 6
        && never(tally_of(EndingState_Final,19,ending=>once(ending == EndGood))) // Blocks the achievement if the number of 'failed' levels is 6 or above - in that case, Ugly Ending triggers.
        && none_of(EndingState_Final,ending=>ending==0) // Makes sure all levels are cleared.
        && (once(Frames_Cutscene() > End_Primer) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger) // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused()// Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1)// Disables Achievement if any Cheat Active
    )

achievement(
    title = "This is Bad. Very Bad",
    description = "Win the game with the Ugly Ending. Gotta mend those Tears a lot faster!",
    type = "win_condition",
    points = 10,
    trigger =
        never(sum_of(EndingState_Final,ending=>prev(ending)) != sum_of(EndingState_Final,ending=>ending)) // Resets whenever a level is cleared.
        && tally_of(EndingState_Final,6,ending=>once(ending != EndGood))  // Checks if number of 'failed' levels is 6 or above
        && none_of(EndingState_Final,ending=>ending==0) // Makes sure all levels are cleared.
        && (once(Frames_Cutscene() > End_Primer)) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused() // Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D && (never(Frames_Level() == 0x0)) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )

// ========================================
// [CHEEV_COLLECT] Collectable Achievements
// ========================================

achievement(
    title = "My Two Bobs",
    description = "Collect an Extra Life.",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && (never(Frames_Level() == 0x00)) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat is active.
        && (Lives_Baudway() > prev(Lives_Baudway()) // Starting here, checks for extra life increment in the different sectors.
            || Lives_CitE() > prev(Lives_CitE())
            || Lives_BevHills() > prev(Lives_BevHills())
            || Lives_Kits() > prev(Lives_Kits())
            || Lives_FPP() > prev(Lives_FPP())
            || Lives_GPrime() > prev(Lives_GPrime())
            || Lives_Hex() > prev(Lives_Hex()) // Sectors end here
        ))
   
achievement (
    title = "My 10 Bobs",
    description = "Have 10 Lives in Stock. Remember to backup your files!",
    points = 10,
    trigger =
        Frames_Gameplay() != prev(Frames_Gameplay())
        && (never(Frames_Level() == 0x00)) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat is active.
        && ((Lives_Baudway() > prev(Lives_Baudway()) && Lives_Baudway() >= 0x0A ) // Starting here, checks for both extra life increment and triggers when life counter hits 10. Just in case, it can trigger at values higher than 10.
            || Lives_CitE() > prev(Lives_CitE()) && Lives_CitE() >= 0x0A
            || Lives_BevHills() > prev(Lives_BevHills()) && Lives_BevHills() >= 0x0A
            || Lives_Kits() > prev(Lives_Kits()) && Lives_Kits() >= 0x0A
            || Lives_FPP() > prev(Lives_FPP()) && Lives_FPP() >= 0x0A
            || Lives_GPrime() > prev(Lives_GPrime()) && Lives_GPrime() >= 0x0A
            || Lives_Hex() > prev(Lives_Hex()) && Lives_Hex() >= 0x0A
        )
    )

achievement (
    title = "Grenades of Courage, Wisdom, and Power",
    description = "Obtain Mortar.",
    points = 2,
    trigger =
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Mortar, boom => boom == 1)
    )
    
achievement (
    title = "I Vant to Leech Your Data!",
    description = "Obtain Vampire.",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Vamp, bleh => bleh == 1)
    )
    
achievement (
    title = "His Only Hope: A Firewall!",
    description = "Obtain Flamethrower",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Flame, whoosh => whoosh == 1)
    )
    
achievement (
    title = "I Can't Believe It! Trapped in a Stupid Bubble!",
    description = "Obtain Box Gun",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Box, boing => boing == 1)
    )
    
achievement (
    title = "Virus Erase Command",
    description = "Obtain Anti-Virus",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_AV, antique => antique == 1)
    )
    
achievement (
    title = "Groovy",
    description = "Obtain Blaster",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Blaster, bang => bang == 1)
    )
    
achievement (
    title = "You Guys Are Toast!",
    description = "Obtain Rockets",
    points = 2,
    trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && any_of(Weapons_Rocket, woof => woof == 1)
    )

achievement (
    title = "It's Only Fun Until Someone Loses an Eye",
    description = "Obtain all weapons, upgrades, and Glitch items.",
    points = 10,
    trigger =
        Frames_Gameplay() != prev(Frames_Gameplay())
        && never(Frames_Level() == 0x00) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat is active.
        && (all_of(Weapons_Baudway, blam => blam == 1)
        || all_of(Weapons_CitE, blam => blam == 1)
        || all_of(Weapons_BevHills, blam => blam == 1)
        || all_of(Weapons_Kits, blam => blam == 1)
        || all_of(Weapons_FPP, blam => blam == 1)
        || all_of(Weapons_GPrime, blam => blam == 1)
        || all_of(Weapons_Hex, blam => blam == 1))
    )

// =====================================
// [CHEEV_FUN] Just For Fun Achievements
// =====================================

achievement(
    title = "Codemaster",
    description = "Congratulations! You've activated a Cheat Code! All other achievements are locked until you reset. Have fun!",
    points = 0,
    id = 403755,
    badge = "457041",
    trigger =
        sector_ID() == Menu && level_ID() == MM // Verifies the user is on the main menu
        && any_of(CheatFlag, cheat => cheat == 1) // Checks if ANY cheat is enabled.)
    )
 
achievement(
    title = "COMMAND.COM",
    description = "Beat the game as Dot Matrix",
    points = 10,
    trigger = once(Char_Dot())
        && none_of(EndingState_Final,ending=>ending==0) // Makes sure all levels are cleared.
        && (once(Frames_Cutscene() > End_Primer)) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused()// Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D && (never(Frames_Level() == 0x0 )) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1)// Disables Achievement if any Cheat Active
    )
 
achievement( title = "Alphanumeric!",
    description = "Beat the game as Enzo Matrix",
    points = 10,
    trigger = once(Char_Enzo())
        && none_of(EndingState_Final,ending=>ending==0) // Makes sure all levels are cleared.
        && (once(Frames_Cutscene() > End_Primer)) // Checks if the Cutscene Timer is incrementing past its 'safe zone'.
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && Gameplay_Paused()// Checks to see if gameplay is paused. (Using this combination shouldn't cause the achievement to pop when in the pause menu)
        && Frames_Level() > 0x22D && (never(Frames_Level() == 0x0 )) // A quick flag to fix an issue of the achievement popping in the level's opening cutscene
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )

achievement ( title = "Dot's Diner: HOTTEST Food in Mainframe...?",
description = "Witness Level 1's Bad Ending. See what other canon breaking endings you can find!",
points = 1,
trigger = 
sector_ID() == Baudway // Checks if Sector is correct
        && level_ID() == Lv1 // Checks if Level is correct
        && (once(Frames_Cutscene() >= End_Primer))// Checks if the Cutscene Timer has begun to increment
        && Frames_Cutscene() == End_Trigger // Checks if the Cutscene Timer has reset to 0.
        && never(Gameplay_Active()) // Checks that gameplay is inactive
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && (EndingState_Lv1 == EndBad) // Checks Ending Status
    )
// =====================================================================
// [CHEEV_CHALLENGE] - Challenges that don't fit in any specific sector
// =====================================================================

achievement (
title = "To Mend and Defend",
points = 10,
description = "Mend a Tear within one second of its forming.",
trigger = 
        Frames_Gameplay() != prev(Frames_Gameplay())
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && any_of(TearStatus, tear => tear == 0x7) // Checks for Tear status.
        && never(TearStatus, tear => tear == 0x1) // Resets when a Tear spawns
        && tally,(30(any_of(ScreenTimers, tick => tick == (prev(Frames_Gameplay())))))
)

// ==========================================
// [CHEEV_BAUD] Baudway-Specific Achievements
// ==========================================

    // =========================================
    // [CHEEV_LV1] Level 1 Specific Achievements
    // =========================================

EnemyHP_Lv1_ABC = word(0x15a7f6)

achievement( title = "Where DOES He Get Those ABCs?",
    description = "Destroy the Armored Binome Carrier in Level 1",
    points = 2,
    id = 403749,
    badge = "457035",
    trigger =
        once(sector_ID() == Baudway) && (level_ID() == Lv1) // Check for correct Sector and Level IDs
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && (EnemyHP_Lv1_ABC == 0x0 || EnemyHP_Lv1_ABC > 0x8000 ) // Due to occasionally underflowing HP, it is set to trigger on either 0 or underflow.
    )
 
achievement( title = "Log Off, Mike!",
    description = "Complete Level 1 without taking damage", // The achievement is set so that once the player's HP decreases, it is locked unless the player resets the level. This is necessary due to the auto-saving checkpoints.
    points = 10,
    trigger =
        once(sector_ID() == Baudway) && once(level_ID() == Lv1) // Check for correct Sector and Level IDs
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && never(once(HP_Baudway() < HP_Full))
        && trigger_when(Cutscenes_Baudway() == LevelEnd)
        && once(Frames_Level() == 0x0)
    )

 // =========================================
 // [CHEEV-LV2] Level 2 Specific Achievements
 // =========================================
 
 // HP for the enemies for the 'destroy all enemies in level 2' achievement.
 function Enemy_HP_Lv2_ZeroBinome1() => word(0x15e26e)
 function Enemy_HP_Lv2_ZeroBinome2() => word(0x15e362)
 function Enemy_HP_Lv2_Turret1() => word(0x15e456)
 function Enemy_HP_Lv2_Turret2() => word(0x15e536)
 function Enemy_HP_Lv2_Turret3() => word(0x15e616)
 function Enemy_HP_Lv2_Turret4() => word(0x15e6f6)
 function Enemy_HP_Lv2_Turret5() => word(0x15e7d6)
 function Enemy_HP_Lv2_Turret6() => word(0x15e8b6)
 function Enemy_HP_Lv2_Turret7() => word(0x15e996)
 function Enemy_HP_Lv2_Turret8() => word(0x15ea76)
 function Enemy_HP_Lv2_Turret9() => word(0x15eb56)
 function Enemy_HP_Lv2_Turret10() => word(0x15ec36)
 function Enemy_HP_Lv2_Turret11() => word(0x15ed16)
 function Enemy_HP_Lv2_Forklift1() => word(0x15edf6)
 function Enemy_HP_Lv2_Forklift2() => word(0x15eeea)

// =========================================
// [CHEEV-LV2] Level 2 Specific Achievements
// =========================================

achievement(
    title = "To Delete and Defend...?",
    points = 5,
    description = "Destroy All Enemies in Level 2", // There are 15 enemies in this stage.
    trigger = 
        once(once(sector_ID() == 0x01) && level_ID() == 0x02)
        && (never(Frames_Level() == 0x0))
        && (never(Frames_Cutscene() > 0x1000))
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && (unless(once(level_ID() != Lv2))) // Added because the stupid thing flickers in the wrong level sometimes.
        && measured(tally(15,
            (once(once(Enemy_HP_Lv2_ZeroBinome1() == 0x00) || Enemy_HP_Lv2_ZeroBinome1() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_ZeroBinome2() == 0x00) || Enemy_HP_Lv2_ZeroBinome2() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret1() == 0x00) || Enemy_HP_Lv2_Turret1() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret2() == 0x00) || Enemy_HP_Lv2_Turret2() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret3() == 0x00) || Enemy_HP_Lv2_Turret3() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret4() == 0x00) || Enemy_HP_Lv2_Turret4() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret5() == 0x00) || Enemy_HP_Lv2_Turret5() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret6() == 0x00) || Enemy_HP_Lv2_Turret6() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret7() == 0x00) || Enemy_HP_Lv2_Turret7() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret8() == 0x00) || Enemy_HP_Lv2_Turret8() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret9() == 0x00) || Enemy_HP_Lv2_Turret9() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret10() == 0x00) || Enemy_HP_Lv2_Turret10() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Turret11() == 0x00) || Enemy_HP_Lv2_Turret11() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Forklift1() == 0x00) || Enemy_HP_Lv2_Forklift1() >= 0x8000)),
            (once(once(Enemy_HP_Lv2_Forklift2() == 0x00) || Enemy_HP_Lv2_Forklift2() >= 0x8000)))
        )
    )

// =========================================
// [CHEEV-LV3] Level 3 Specific achievements
// =========================================

function TearHP_Lv3_Tear2() => word(0x15f4aa)
function EnemyHP_Lv3_Squidface() => word(0x15ef66)

achievement(
    title = "Garbage In, Garbage Out",
    points = 5,
    description = "Mend the Second Tear in Level 3 before destroying the Sewer Creature",
    trigger = once(once(sector_ID() == 0x01) && level_ID() == 0x03)
    && never(once(once(EnemyHP_Lv3_Squidface() == 0x00) || EnemyHP_Lv3_Squidface() > 0x7FFF)) // Pauses if Squidface has been destroyed
    && trigger_when((once(TearHP_Lv3_Tear2() == 0x00 || TearHP_Lv3_Tear2() > 0x7FFF))) // Triggers when Tear is Mended.
    && Frames_Gameplay() != prev(Frames_Gameplay())
    && (always_false() || (never(Frames_Level() == 0x00))) // Resets when level is restarted
    && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
     

// =========================================
// [CHEEV_CITE] Cit E-Specific achievements
// =========================================

  // ==========================================
  // [CHEEV-LV4] Level 4 Specific Achievements
  // ==========================================

 Mines_Lv4 = [
    byte(0x150dc1),
    byte(0x150ea1),
    byte(0x150f81),
    byte(0x151061),
    byte(0x151141),
    byte(0x151221),
    byte(0x15122c),
    byte(0x151301),
    byte(0x1513e1),
    byte(0x1514c1),
    byte(0x1515a1),
    byte(0x151681),
    byte(0x151761),
    byte(0x151841),
    byte(0x151921),
    byte(0x151a01),
    byte(0x151ae1),
    byte(0x151bc1),
    byte(0x151ca1),
    byte(0x151d81),
    byte(0x151e61),
    byte(0x151f41),
    byte(0x152021),
]
        MineActive = 0x6
        MineDestroyed = 0x3
        
achievement(
    title = "They Look Like Game Pucks From Phong's Favorite Game!",
    points = 10,
    description = "Finish Level 4 without detonating any mines",
    trigger =
        once(once(sector_ID() == 0x02) && level_ID() == 0x04)
        && none_of(Mines_Lv4, mines => mines == MineDestroyed)
        && Frames_Gameplay() != prev(Frames_Gameplay())
        && trigger_when(Cutscenes_CitE() == LevelEnd)
        && (always_false() || (never(Frames_Level() == 0x00))) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
    // So I was absolutely DETERMINED to make this achievement work. It took going through the level and finding the memory location of EVERY SINGLE MINE.

achievement(
    title = "Do Not Taunt",
    points = 5,
    description = "Find the hidden Rockets in Level 4",
    trigger = 
        once(once(sector_ID() == 0x02) && level_ID() == 0x04)
        && Frames_Gameplay() != prev(Frames_Gameplay())
        && (always_false() || (never(Frames_Level() == 0x00))) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && Weapon_Rocket1_CitE() != prev(Weapon_Rocket1_CitE()) // Checks for new Rockets acquired. Note that this is the EARLIEST point one can obtain the Rockets. If I DID miss one somehow, and it comes up in tickets, this can be fixed by adding an OR statement (alt groups) to this line for Weapon_Rocket2_CitE() and Weapon_Rocket3_CitE().
    )
    // This will likely trigger alongside the general Obtain Rockets achievement, but I figure this one is so out-of-the-way that it's fine.
 
 
 // =========================================
 // [CHEEV-LV5] Level 5 Specific Achievements
 // =========================================
 
 
 achievement(
    title = "Our Zip-Boards Aren't Doing So Well",
    points = 10,
    description = "Complete Level 5 without falling off the stage",
    trigger = 
        once(once(sector_ID() == 0x02 && once(level_ID() == 0x05))) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once(Frames_Level() == 0x00) // Sets flag when starting level
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && trigger_when(Cutscenes_CitE() == LevelEnd) // Trigger achievement when ending level (icon)
        && never(Frames_Cutscene() >= 0x8000)
    )
    // This unfortunately requires some juggling of the cutscene timer, as although voiding out activates the Cutscene Timer, so does using the Vidwindow warps. The number has to be high enough to only be triggered by voiding out. Thankfully the Vidwindow warps take far less time. But if there are tickets for this achievement, that may be the issue.

 // ==========================================
 // [CHEEV-LV6] Level 6 Specific Achievements
 // ==========================================
 
function BossHP_MegABC() => word(0x166f96)
function BossTear_MegABC() => word(0x166eaa)
 
 achievement(
    title = "Treacherous Dogs!",
    points = 10,
    description = "Complete Level 6 without destroying the Meg-ABC.",
    trigger = 
        once(once(sector_ID() == 0x02 && once(level_ID() == 0x06))) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once(Frames_Level() == 0x00) // Sets flag when starting level
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && never(BossHP_MegABC() == 0x00 || BossHP_MegABC() > 0x8000)
        && trigger_when((once(BossTear_MegABC() == 0x00 || BossTear_MegABC() > 0x8000))) // Triggers when Tear is Mended.
    )
 // Treacherous Dogs!
  // Complete Level 6 without destroying the MEG-ABC 
   // I can hopefully copy-paste the code from the Squidface achievement
  
// ====================================================
// [CHEEV_BEVHILLS] Beverly Hills-Specific achievements
// ====================================================
  
  // ==========================================
  // [CHEEV-LV7] Level 7 Specific Achievements
  // ==========================================
  
  // ==========================================
  // [CHEEV-LV8] Level 8 Specific Achievements
  // ==========================================
  
 function TearHP_Lv8_Tear1() => word(0x159786)
 function EnemyHP_Lv8_Guard1() => word(0x15b532)
 function EnemyHP_Lv8_Guard2() => word(0x15b626)
 function EnemyHP_Lv8_Guard3() => word(0x15b71a)

achievement(
    title = "I Don't Believe In Deletion (This Time)",
    points = 5,
    description = "Mend the first Tear in Level 8 without destroying any of the guards",
    trigger = once(once(sector_ID() == 0x03) && level_ID() == 0x08)
        && never(once(once(EnemyHP_Lv8_Guard1() == 0x00) || EnemyHP_Lv8_Guard1() > 0x7FFF)) // Deactivates if any guard is destroyed
        && never(once(once(EnemyHP_Lv8_Guard2() == 0x00) || EnemyHP_Lv8_Guard2() > 0x7FFF)) 
        && never(once(once(EnemyHP_Lv8_Guard3() == 0x00) || EnemyHP_Lv8_Guard3() > 0x7FFF))
        && trigger_when((once(TearHP_Lv8_Tear1() == 0x00 || TearHP_Lv8_Tear1() > 0x7FFF))) // Triggers when Tear is Mended.
        && Frames_Gameplay() != prev(Frames_Gameplay())
        && (always_false() || (never(Frames_Level() == 0x00))) // Resets when level is restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
      
  
    // A simple check to see if the Tear is mended (made simpler that it's the first Tear of the level), while the three guards are still active.
  
  // ==========================================
  // [CHEEV-LV9] Level 9 Specific Achievements
  // ==========================================
  
  
  
  // ===========================================
  // [CHEEV-LV10] Level 10 Specific Achievements
  // ===========================================
 
 function BossTear_Web() => word(0x14dfd2) 
  
 achievement(
    title = "Do You Know What the Guardian Protocol Is for Finding a Web Creature in a System like Mainframe?",
    points = 10,
    description = "Finish Level 10 without letting your health drop to yellow",
    trigger = 
        once(once(sector_ID() == 0x03) && level_ID() == 0x0a)
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && (never(Frames_Level() == 0x00)) // Resets when level is restarted
        && trigger_when((once(BossTear_Web() == 0x00 || BossTear_Web() > 0x8000))) // Tear Status (Web Creature's HP has no bearing. Do fix if someone manages to glitch past the Web Creature.) 
        && none_of(CheatFlag, cheat => cheat == 1) // Cheat Flags
        && never(once(HP_BevHills() <= HP_Yellow)) // Make sure HP doesn't drop to yellow (666)
    )
  
  
// =======================================
// [CHEEV_KITS] Kits-Specific achievements
// =======================================
  
  
  // ===========================================
  // [CHEEV-LV11] Level 11 Specific Achievements
  // ===========================================

function EnemyHP_Lv11_Spring() => word(0x169e9a) // Fun fact, this is the last relevant address noted in Code Notes. Isn't this game's memory laid out so perfectly?

 achievement(
    title = "Luxo Jr., But Evil",
    points = 5,
    description = "Destroy the springing tank in Level 11",
    trigger =
        (once(once(sector_ID() == 0x04) && level_ID() == 0xb)) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && (never(Frames_Level() == 0x00))
        && ((EnemyHP_Lv11_Spring() == 0x00) || EnemyHP_Lv11_Spring() >= 0x8000)
    )

  
  // ===========================================
  // [CHEEV-LV12] Level 12 Specific Achievements
  // ===========================================
  function TearHP_Lv12() => word(0x154576)
  
  Turrets_Lv12 = [
    word(0x154662),
    word(0x154742),
    word(0x154822),
    word(0x154902),
    word(0x1549e2),
    word(0x154ac2),
    word(0x154ba2),
    word(0x154c82),
    word(0x154d62),
    word(0x154e42),
    ]

 achievement(
    title = "Oh No...! I Just Redecorated!",
    points = 5,
    description = "Complete Level 12 without destroying any turrets.",
    trigger = 
        once(once(sector_ID() == Kits) && level_ID() == Lv12) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && (never(Frames_Level() == 0x00)) // Reset if Level Restarted
        && trigger_when((TearHP_Lv12() == 0x00 || TearHP_Lv12() > 0x8000)) // Triggers when Tear is mended
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && none_of(Turrets_Lv12, turret => turret == 0x00)
        && none_of(Turrets_Lv12, turret => turret > 0x8000)
    )

// =====================================================
// [CHEEV_FPP] Floating Point Park-Specific achievements
// =====================================================



  // ===========================================
  // [CHEEV-LV13] Level 13 Specific Achievements
  // ===========================================

   
   function EnemyHP_Lv13_Golf1() => word(0x153226)
   function EnemyHP_Lv13_Golf2() => word(0x15331a)
   function EnemyHP_Lv13_Golf3() => word(0x15340e)
   function EnemyHP_Lv13_Golf4() => word(0x153502)
   function EnemyHP_Lv13_Golf5() => word(0x1535f6)
   function EnemyHP_Lv13_Golf6() => word(0x1536ea)
   
   function EnemyHP_Lv13_ABC() => word(0x153132)
   

achievement(
    title = "How's Your Back, Nine?",
    points = 10,
    description = "Complete Level 13 without falling off the stage.",
    trigger = 
        once(once(sector_ID() == FPP && once(level_ID() == Lv13))) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once(Frames_Level() == 0x00) // Sets flag when starting level
        && (never(Frames_Level() == 0x00)) // Reset if Level Restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && trigger_when(Cutscenes_FPP() == LevelEnd) // Trigger achievement when ending level (icon)
        && never(Frames_Cutscene() >= 0x8000)
    )
    
achievement(
    title = "Oh, Great. Another Golf Game",
    points = 5,
    description = "Destroy all the Golf Carts in Level 13",
    trigger = 
        once(once(sector_ID() == FPP && once(level_ID() == Lv13))) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && (never(Frames_Level() == 0x00)) // Reset if Level Restarted
        && none_of(CheatFlag, cheat => cheat == 1)
        && unless(once(level_ID() != Lv13)) // Added because the stupid thing flickers in the wrong level sometimes.
        && measured(tally(6,
            (once(once(EnemyHP_Lv13_Golf1() == 0x00) || EnemyHP_Lv13_Golf1() >= 0x8000)),
            (once(once(EnemyHP_Lv13_Golf2() == 0x00) || EnemyHP_Lv13_Golf2() >= 0x8000)),
            (once(once(EnemyHP_Lv13_Golf3() == 0x00) || EnemyHP_Lv13_Golf3() >= 0x8000)),
            (once(once(EnemyHP_Lv13_Golf4() == 0x00) || EnemyHP_Lv13_Golf4() >= 0x8000)),
            (once(once(EnemyHP_Lv13_Golf5() == 0x00) || EnemyHP_Lv13_Golf5() >= 0x8000)),
            (once(once(EnemyHP_Lv13_Golf6() == 0x00) || EnemyHP_Lv13_Golf6() >= 0x8000)))
            ))

achievement(
    title = "Be Seeing You!",
    points = 5,
    description = "Destroy the fast-moving ABC in Level 13.",
    trigger =
        once(once(sector_ID() == FPP && once(level_ID() == Lv13))) // Level Check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && (never(Frames_Level() == 0x00)) // Reset if Level Restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && once(once(EnemyHP_Lv13_ABC() == 0x00) || EnemyHP_Lv13_ABC() >= 0x8000)
    )
   
    // ===========================================
    // [CHEEV-LV14] Level 14 Specific Achievements
    // ===========================================

// ============================================
// [CHEEV_GPRIME] G-Prime-Specific achievements
// ============================================

    // ===========================================
    // [CHEEV-LV15] Level 15 Specific Achievements
    // ===========================================

    // ===========================================
    // [CHEEV-LV16] Level 16 Specific Achievements
    // ===========================================

achievement(
    title = "Into Mega-Breath's Lair",
    points = 10,
    description = "Complete Level 16 without losing a life. (Restarts allowed!)",
    trigger = 
        once(once(sector_ID() == GPrime && once(level_ID() == Lv16))) // Level check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && once (Frames_Level() == 0x01) // Sets flag when starting level
        && never (Frames_Level() == 0x00) // Reset if Level Restarted
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat active
        && trigger_when(Cutscenes_GPrime() == LevelEnd) // Trigger achievement when ending level (icon)
        && never(once(Lives_GPrime() < prev(Lives_GPrime()))) // Make sure lives don't decrement
        )

// This is a challenge because of the instant-death crushers. Players will have to get through the ENTIRE level without dying. Restarting level is permitted.

    // ===========================================
    // [CHEEV-LV17] Level 17 Specific Achievements
    // ===========================================

achievement(
    title = "I'm Outta Here! This Place is Too Hot!",
    points = 10,
    description = "Complete Level 17 without letting your health drop to Yellow.",
    trigger = 
        once(once(sector_ID() == GPrime && once(level_ID() == Lv17))) // Level check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat active
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && never(Frames_Level() == 0x00) // Reset on Level Restart
        && trigger_when(Cutscenes_GPrime() == LevelEnd) // Trigger achievement when level ends
        && never(once(HP_GPrime() <= HP_Yellow)) // Make sure HP doesn't drop to yellow (666)
    )
    

    // ===========================================
    // [CHEEV-LV18] Level 18 Specific Achievements
    // ===========================================
function EnemyHP_Megabyte() => word(0x13c052)

achievement(
    title = "Royally Kicked Megabyte's ASCII",
    points = 25,
    description = "Complete Level 18 without letting your health drop to Danger.",
    trigger = 
        once(once(sector_ID() == GPrime && once(level_ID() == Lv18))) // Level check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat active
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && never(Frames_Level() == 0x00) // Reset on Level Restart
        && trigger_when((once(EnemyHP_Megabyte() == 0x00 || EnemyHP_Megabyte() > 0x8000)))//Megabyte ded // Trigger achievement when level ends
        && never(once(HP_GPrime() <= HP_Danger)) // Make sure HP doesn't drop to Danger
    )

    
TurretHack = [
    byte(0x13c860),
    byte(0x13c940),
    byte(0x13ca20),
    byte(0x13cb00)
    ]
 
        Hacked = 0x98
        
// This is the closest I could figure out to having an apparent consistent value for this status. If this achievement breaks, you know who and what to blame. --Talz

achievement(
    title = "All Evidence Points to Mouse",
    points = 5,
    description = "Turn one of Megabyte's turrets against him.",
    trigger = 
        once(once(sector_ID() == GPrime && once(level_ID() == Lv18))) // Level check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay check
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat active
        && trigger_when(any_of(TurretHack, mouse => mouse == Hacked))
        && never(once(Ammo_AV_GPrime() == 0x00)) // Hides trigger if you have no Anti-Virus in stock
    )
// =============================================
// [CHEEV_HEX] Lost Angles Specific achievements
// =============================================

  // ===========================================
  // [CHEEV-LV19] Level 19 Specific Achievements
  // ===========================================

function EnemyHP_Hexadecimal() => word(0x135122)

achievement(
    title = "Chaos Will Always Triumph Over Order!",
    points = 25,
    description = "Complete Level 19 without letting your health drop to Danger.",
    trigger = 
        once(once(sector_ID() == Hex && once(level_ID() == Lv19))) // Level check
        && Frames_Gameplay() != prev(Frames_Gameplay()) // Gameplay Check
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat active
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && never(Frames_Level() == 0x00) // Reset on Level Restart
        && trigger_when((once(EnemyHP_Hexadecimal() == 0x00 || EnemyHP_Hexadecimal() > 0x8000)))// Trigger achievement when level ends
        && never(once(HP_Hex() <= HP_Danger)) // Make sure HP doesn't drop to Danger
    )
    
achievement(
    title = "Prime Guardian",
    points = 50,
    description = "Beat the game with 20 Lives. You are the true Guardian of Mainframe!",
    trigger = 
        once(once(sector_ID() == Hex && once(level_ID() == Lv19)))
        && Frames_Gameplay() != prev(Frames_Gameplay())
        && none_of(CheatFlag, cheat => cheat == 1)
        && once(Frames_Level() == 0x01) // Sets flag when starting level
        && never(Frames_Level() == 0x00) // Reset on Level Restart
        && Lives_Hex() == 0x14 // Checks if lives are 20 at the time of Hex's defeat.
        && trigger_when((once(EnemyHP_Hexadecimal() == 0x00 || EnemyHP_Hexadecimal() > 0x8000)))
    )