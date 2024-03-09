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

// ======================

// 

// =====================================
// [CHEEV_PROG] Progression Achievements
// =====================================

achievement(
    title = "What Do I Look Like, a Nanny?!",
    description = "Complete Level 1",
    points = 2,
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
        Gameplay_Active() // Checks whether gameplay is paused.
        && none_of(CheatFlag, cheat => cheat == 1) // Disables achievement if any cheat is active.
        && (Lives_Baudway() > prev(Lives_Baudway()) // Starting here, checks for extra life increment in the different sectors.
            || Lives_CitE() > prev(Lives_CitE())
            || Lives_BevHills() > prev(Lives_BevHills())
            || Lives_Kits() > prev(Lives_Kits())
            || Lives_FPP() > prev(Lives_FPP())
            || Lives_GPrime() > prev(Lives_GPrime())
            || Lives_Hex() > prev(Lives_Hex()) // Sectors end here
        )
    )
   
achievement (
    title = "My 10 Bobs",
    description = "Have 10 Lives in Stock. Remember to backup your files!",
    points = 10,
    trigger =
        Gameplay_Active() // Checks whether gameplay is paused.
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

// I had thought of a 20-life achievement, but that would require a perfect no-death run. Might be potential in a subset.

// =====================================
// [CHEEV_FUN] Just For Fun Achievements
// =====================================

achievement(
    title = "Codemaster",
    description = "Congratulations! You've activated a Cheat Code! All other achievements are locked until you reset. Have fun!",
    points = 0,
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


// ==========================================
// [CHEEV-BAUD] Baudway-Specific Achievements
// ==========================================

    // =========================================
    // [CHEEV-LV1] Level 1 Specific Achievements
    // =========================================

EnemyHP_Lv1_ABC = word(0x15a7f6)

achievement( title = "Where DOES He Get Those ABCs?",
    description = "Destroy the Armored Binome Carrier in Level 1",
    points = 2,
    trigger =
        once(sector_ID() == Baudway) && (level_ID() == Lv1) // Check for correct Sector and Level IDs
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && Gameplay_Active()
        && (EnemyHP_Lv1_ABC == 0x0 || EnemyHP_Lv1_ABC > 0x8000 ) // Due to occasionally underflowing HP, it is set to trigger on either 0 or underflow.
    )
 
achievement( title = "Log Off, Mike!",
    description = "Complete Level 1 without taking damage", // The achievement is set so that once the player's HP decreases, it is locked unless the player resets the level. This is necessary due to the auto-saving checkpoints.
    points = 10,
    trigger =
        once(sector_ID() == Baudway) && once(level_ID() == Lv1) // Check for correct Sector and Level IDs
        && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
        && unless(once(HP_Baudway() < HP_Full))
        && trigger_when(Cutscenes_Baudway() == LevelEnd)
        && (always_false() || never(Frames_Level() == 0x0))
    )

 // =========================================
 // [CHEEV-LV2] Level 2 Specific Achievements
 // =========================================
 
 // Specific addresses
 
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
function EnemyHP_Lv3_Squidboy() => word(0x15ef66)

achievement(
    title = "Garbage In, Garbage Out",
    points = 5,
    description = "Mend the Second Tear in Level 3 before destroying the Sewer Creature",
    trigger = once(once(sector_ID() == 0x01) && level_ID() == 0x03)
    && unless(once(once(EnemyHP_Lv3_Squidboy() == 0x00) || EnemyHP_Lv3_Squidboy() > 0x7FFF)) // Pauses if Squidboy has been destroyed
    && trigger_when((once(TearHP_Lv3_Tear2() == 0x00 || TearHP_Lv3_Tear2() > 0x7FFF))) // Triggers when Tear is Mended.
    && Frames_Gameplay() != prev(Frames_Gameplay())
    && (always_false() || (never(Frames_Level() == 0x00))) // Resets when level is restarted
    && none_of(CheatFlag, cheat => cheat == 1) // Disables Achievement if any Cheat Active
    )
     

// =========================================
// [CHEEV_CITE] Cit E-Specific achievements
// =========================================

// Relevant memory addresses

  // ==========================================
  // [CHEEV-LV4] Level 4 Specific Achievements
  // ==========================================

// They Look Like Game Pucks From Phong's Favorite Game!
 // Complete Level 4 without setting off any Mines

// Do Not Taunt
  // Find the hidden rockets in Level 4
    // This will require setting a Delta to increment the Rocket value. This is thankfully made easier due to the fact that this is the first opportunity for the player to get rockets.
    // This will likely trigger alongside the Obtain Rockets achievement, but I figure this one is so out-of-the-way that it's fine.
 
 
 // =========================================
 // [CHEEV-LV5] Level 5 Specific Achievements
 // =========================================
 
 // Our Zip-Boards Aren't Doing So Well
  // Complete Level 5 without falling off the stage
    // This unfortunately requires some juggling of the cutscene timer, as although voiding out activates the Cutscene Timer, so does using the Vidwindow warps

 // ==========================================
 // [CHEEV-LV6] Level 6 Specific Achievements
 // ==========================================
 
 // Treacherous Dogs!
  // Complete Level 6 without destroying the MEG-ABC 
   // It should be a simple check if the HP is within 'active' zones. The tricky part might be making sure that 0x8000 isn't recognized as being above 0x1.
  
// ====================================================
// [CHEEV_BEVHILLS] Beverly Hills-Specific achievements
// ====================================================
  

  // ==========================================
  // [CHEEV-LV7] Level 7 Specific Achievements
  // ==========================================
  
  
  
  // ==========================================
  // [CHEEV-LV8] Level 8 Specific Achievements
  // ==========================================
  
  // I Don't Believe in Deletion (This Time)
   // Mend the First Tear in Level 8 without destroying any of the guards
    // A simple check to see if the Tear is mended (made simpler that it's the first Tear of the level), while the three guards are still active.
  
  // ==========================================
  // [CHEEV-LV9] Level 9 Specific Achievements
  // ==========================================
  
  
  
  // ===========================================
  // [CHEEV-LV10] Level 10 Specific Achievements
  // ===========================================
  
  // A Piggyback Function?! No!
   // In Level 10, don't let your health drop to Yellow
    // Code-wise, simple enough. Gameplay-wise, when you're in 'outdoor areas', you're constantly bombarded by Web Spores. You'll have to avoid them and pick up health packs if you want this.
  
// =======================================
// [CHEEV_KITS] Kits-Specific achievements
// =======================================
  
  
  // ===========================================
  // [CHEEV-LV11] Level 11 Specific Achievements
  // ===========================================
  
  // Luxo Jr., But Evil
   // Destroy the Springing Tank in Level 11
    // Hopefully a simple 'active/destroyed' check.
  
  // ===========================================
  // [CHEEV-LV12] Level 12 Specific Achievements
  // ===========================================
  
  // Oh No! I Just Redecorated!
   // Complete Level 12 without Destroying any Turrets
    // Turrets are mapped, I just need to have a hit counter to pop if NONE of the turrets are destroyed.
  
// =====================================================
// [CHEEV_FPP] Floating Point Park-Specific achievements
// =====================================================



  // ===========================================
  // [CHEEV-LV13] Level 13 Specific Achievements
  // ===========================================

  // How's Your Back, Nine?
   // Complete Level 13 without falling off the stage
    // This is hopefully ultimately a copy-and-paste from Level 5's achievement.
   
  // Be Seeing You!
   // Destroy the fast-moving ABC in Level 13
    // Hopefully a simple active check. It DOES respawn, but as most people would only see the unlock once, it shouldn't be a problem.

    // ===========================================
    // [CHEEV-LV14] Level 14 Specific Achievements
    // ===========================================


// ============================================
// [CHEEV_GPRIME] G-Prime-Specific achievements
// ============================================


    // ===========================================
    // [CHEEV-LV15] Level 15 Specific Achievements
    // ===========================================

    // Into Mega-Breath's Lair
        // Complete Level 15 without losing a life (Must restart level to try again!)
        // I have this one because of the insta-death crushing things. Players will have to reset the entire level if they want to try again. It will still be a challenge because they'll have to mend all three Tears in one life.
  
    // ===========================================
    // [CHEEV-LV16] Level 16 Specific Achievements
    // ===========================================

    // ===========================================
    // [CHEEV-LV17] Level 17 Specific Achievements
    // ===========================================

    // I'm Outta Here! This Place is Too Hot!
        // Complete Level 17 without falling on the lava
        // I do hope this is possible. I will have to analyze values in the level. Be prepared to replace this.

    // ===========================================
    // [CHEEV-LV18] Level 18 Specific Achievements
    // ===========================================
  
    // Royally Kicked Megabyte's ASCII
        // Complete Level 18 without letting your health drop to Danger Level.
        // It SHOULD be nothing more than a simple HP > 0x12B
  
// =============================================
// [CHEEV_HEX] Lost Angles Specific achievements
// =============================================

  // ===========================================
  // [CHEEV-LV19] Level 19 Specific Achievements
  // ===========================================
  
  // Chaos Will Always Triumph Over Order
   // Complete Level 19 without letting your health drop to Danger Level.
    // It SHOULD be nothing more than a simple HP > 0x12B
  
