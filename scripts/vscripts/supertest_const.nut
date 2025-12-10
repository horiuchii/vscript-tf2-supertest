::CONTRACKER_HUD <- "vgui/contracker_hud/";
::CHAT_PREFIX <- "\x07" + "66B2B2" + "[SUPER TEST] " + "\x07" + "DAFFF9";

::OPEN_MENU_DOUBLEPRESS_TIME <- 0.35;
::MENU_HINT_COOLDOWN_TIME <- 30;

::TF_CLASSES <- [
    "scout"
    "sniper"
    "soldier"
    "demo"
    "medic"
    "heavy"
    "pyro"
    "spy"
    "engie"
]

::TF_CLASS_REMAP <- {
    [TF_CLASS_SCOUT] = 0,
    [TF_CLASS_SOLDIER] = 1,
    [TF_CLASS_PYRO] = 2,
    [TF_CLASS_DEMOMAN] = 3,
    [TF_CLASS_HEAVY] = 4,
    [TF_CLASS_ENGINEER] = 5,
    [TF_CLASS_MEDIC] = 6,
    [TF_CLASS_SNIPER] = 7,
    [TF_CLASS_SPY] = 8
}

::TF_CLASS_REMAP_INV <- {
    [0] = TF_CLASS_SCOUT,
    [1] = TF_CLASS_SOLDIER,
    [2] = TF_CLASS_PYRO,
    [3] = TF_CLASS_DEMOMAN,
    [4] = TF_CLASS_HEAVY,
    [5] = TF_CLASS_ENGINEER,
    [6] = TF_CLASS_MEDIC,
    [7] = TF_CLASS_SNIPER,
    [8] = TF_CLASS_SPY
}

enum WeaponSlot
{
    Primary
    Secondary
    Melee
    DisguiseKit
    InvisWatch
    MAX
}

::LOADOUT_SLOT_NAMES <- ["primary", "secondary", "melee"];
::LOADOUT_SLOT_IDS <- [WeaponSlot.Primary, WeaponSlot.Secondary, WeaponSlot.Melee];
::LOADOUT_SLOT_NAMES_SPY <- ["secondary", "melee", "watch", "sapper"];
::LOADOUT_SLOT_IDS_SPY <- [WeaponSlot.Primary, WeaponSlot.Melee, WeaponSlot.InvisWatch, WeaponSlot.Secondary];

::TF_AMMO_PRIMARY <- 1
::TF_AMMO_SECONDARY <- 2
::TF_AMMO_METAL <- 3
::TF_AMMO_GRENADES1 <- 4
::TF_AMMO_GRENADES2 <- 5
::TF_AMMO_GRENADES3 <- 6

::CLASS_AMMO <- {
    [TF_CLASS_SCOUT] = {
        [TF_AMMO_PRIMARY] = 32,
        [TF_AMMO_SECONDARY] = 36,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 1,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_SOLDIER] = {
        [TF_AMMO_PRIMARY] = 20,
        [TF_AMMO_SECONDARY] = 32,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 1,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_PYRO] = {
        [TF_AMMO_PRIMARY] = 200,
        [TF_AMMO_SECONDARY] = 32,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 0,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_DEMOMAN] = {
        [TF_AMMO_PRIMARY] = 16,
        [TF_AMMO_SECONDARY] = 24,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 1,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_HEAVY] = {
        [TF_AMMO_PRIMARY] = 200,
        [TF_AMMO_SECONDARY] = 32,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 1,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_ENGINEER] = {
        [TF_AMMO_PRIMARY] = 32,
        [TF_AMMO_SECONDARY] = 200,
        [TF_AMMO_METAL] = 200,
        [TF_AMMO_GRENADES1] = 0,
        [TF_AMMO_GRENADES2] = 0,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_MEDIC] = {
        [TF_AMMO_PRIMARY] = 150,
        [TF_AMMO_SECONDARY] = 150,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 0,
        [TF_AMMO_GRENADES2] = 0,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_SNIPER] = {
        [TF_AMMO_PRIMARY] = 25,
        [TF_AMMO_SECONDARY] = 75,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 1,
        [TF_AMMO_GRENADES2] = 0,
        [TF_AMMO_GRENADES3] = 1
    },
    [TF_CLASS_SPY] = {
        [TF_AMMO_PRIMARY] = 20,
        [TF_AMMO_SECONDARY] = 24,
        [TF_AMMO_METAL] = 100,
        [TF_AMMO_GRENADES1] = 0,
        [TF_AMMO_GRENADES2] = 1,
        [TF_AMMO_GRENADES3] = 1
    }
}

::NETPROP_ITEMDEFINDEX <- "m_AttributeManager.m_Item.m_iItemDefinitionIndex"
::NETPROP_INITIALIZED <- "m_AttributeManager.m_Item.m_bInitialized"
::NETPROP_VALIDATED_ATTACHED <- "m_bValidatedAttachedEntity"

::WEAPON_UNUSUAL_HOT <- 701;
::WEAPON_UNUSUAL_ISOTOPE <- 702;
::WEAPON_UNUSUAL_COOL <- 703;
::WEAPON_UNUSUAL_ENERGYORB <- 704;

::WEAPON_UNUSUAL_NAME <- {
    [0] = "None",
    [WEAPON_UNUSUAL_HOT] = "Hot",
    [WEAPON_UNUSUAL_ISOTOPE] = "Isotope",
    [WEAPON_UNUSUAL_COOL] = "Cool",
    [WEAPON_UNUSUAL_ENERGYORB] = "Energy Orb"
}

::WEAR_FACTORY_NEW <- 0.00;
::WEAR_MINIMAL_WEAR <- 0.25;
::WEAR_FIELD_TESTED <- 0.50;
::WEAR_WELL_WORN <- 0.75;
::WEAR_BATTLE_SCARRED <- 1.00;

::WEAR_NAME <- {
    [0] = "Factory New",
    [WEAR_FACTORY_NEW] = "Factory New",
    [WEAR_MINIMAL_WEAR] = "Minimal Wear",
    [WEAR_FIELD_TESTED] = "Field-Tested",
    [WEAR_WELL_WORN] = "Well-Worn",
    [WEAR_BATTLE_SCARRED] = "Battle Scarred",
    [1] = "Battle Scarred"
}

::KS_TYPE_BASIC <- 1;
::KS_TYPE_SPEC <- 2;
::KS_TYPE_PRO <- 3;

::KS_TYPE_NAME <- {
    [0] = "None",
    [KS_TYPE_BASIC] = "Basic",
    [KS_TYPE_SPEC] = "Specialized",
    [KS_TYPE_PRO] = "Professional"
}

::KS_SHEEN_TEAM_SHINE <- 1
::KS_SHEEN_DEADLY_DAFFODIL <- 2
::KS_SHEEN_MANNDARIN <- 3
::KS_SHEEN_MEAN_GREEN <- 4
::KS_SHEEN_AGONIZING_EMERALD <- 5
::KS_SHEEN_VILLAINOUS_VIOLET <- 6
::KS_SHEEN_HOT_ROD <- 7

::KS_SHEEN_NAME <- {
    [KS_SHEEN_TEAM_SHINE] = "Team Shine",
    [KS_SHEEN_DEADLY_DAFFODIL] = "Deadly Daffodil",
    [KS_SHEEN_MANNDARIN] = "Manndarin",
    [KS_SHEEN_MEAN_GREEN] = "Mean Green",
    [KS_SHEEN_AGONIZING_EMERALD] = "Agonizing Emerald",
    [KS_SHEEN_VILLAINOUS_VIOLET] = "Villainous Violet",
    [KS_SHEEN_HOT_ROD] = "Hot Rod"
}

::KS_EFFECT_FIRE_HORNS <- 2002
::KS_EFFECT_CEREBRAL_DISCHARGE <- 2003
::KS_EFFECT_TORNADO <- 2004
::KS_EFFECT_FLAMES <- 2005
::KS_EFFECT_SINGULARITY <- 2006
::KS_EFFECT_INCINERATOR <- 2007
::KS_EFFECT_HYPNOBEAM <- 2008

::KS_EFFECT_NAME <- {
    [KS_EFFECT_FIRE_HORNS] = "Fire Horns",
    [KS_EFFECT_CEREBRAL_DISCHARGE] = "Cerebral Discharge",
    [KS_EFFECT_TORNADO] = "Tornado",
    [KS_EFFECT_FLAMES] = "Flames",
    [KS_EFFECT_SINGULARITY] = "Singularity",
    [KS_EFFECT_INCINERATOR] = "Incinerator",
    [KS_EFFECT_HYPNOBEAM] = "Hypno-Beam"
}

enum UnusualType
{
    Cosmetic
    Taunt
}

enum CosmeticType
{
    Normal
    CommunityMedal
    TournamentMedal
}

::COSMETIC_PREFAB_COUNT <- 6; //how many prefabs per class
::COSMESTICS_IN_PREFAB_COUNT <- 7; //how many cosmetics inside of each prefab, last is reserved for medals

::DAI_INITIAL_TICKS <- 12 //how many ticks until we start dai
::DAI_TICKS <- [1100 550 220 110 55 0] //how many ticks need to have passed until we start moving the menu faster
::DAI_PERIOD_TICKS <- [0 1 2 3 4 8] //how many ticks it takes to move the input

::SIDE_DAI_INITIAL_TICKS <- 10; // how many ticks until side DAI starts
::SIDE_DAI_TICKS <- [1100 550 220 110 55 0] //how many ticks need to have passed until we start moving the menu faster
::SIDE_DAI_PERIOD_TICKS <- [0 1 2 3 4 8] //how many ticks it takes to move the input

::FLAG_WARPAINT_AND_UNUSUAL <- 1
::FLAG_ACCEPTS_ENERGYORB <- 2
::FLAG_AUSTRAILIUM <- 4

::DAMAGE_NO <- 0;
::DAMAGE_EVENTS_ONLY <- 1;
::DAMAGE_YES <- 2;
::DAMAGE_AIM <- 3;

::PATTACH_ABSORIGIN <- 0;
::PATTACH_ABSORIGIN_FOLLOW <- 1;
::PATTACH_CUSTOMORIGIN <- 2;
::PATTACH_POINT <- 3;
::PATTACH_POINT_FOLLOW <- 4;
::PATTACH_WORLDORIGIN <- 5;
::PATTACH_ROOTBONE_FOLLOW <- 6;

::DRAW_KEYS <- [
    "IN_ATTACK"
    "IN_ATTACK2"
    "IN_ATTACK3"
    "IN_JUMP"
    "IN_FORWARD"
    "IN_BACK"
    "IN_MOVELEFT"
    "IN_MOVERIGHT"
]

// name, spell charges
::TF_SPELLS <- [
    ["Fireball", 2],
    ["Swarm of Bats", 2],
    ["Overheal", 1],
    ["Pumpkin MIRV", 1],
    ["Blast Jump", 2],
    ["Stealth", 1],
    ["Shadow Leap", 2],

    ["Ball O' Lightning", 1],
    ["Power Up", 1],
    ["Meteor Shower", 1],
    ["MONOCULUS", 1],
    ["Skeleton Horde", 1],

    ["Bumper Kart: Boxing Rocket", 1],
    ["Bumper Kart: B.A.S.E Jump", 1],
    ["Bumper Kart: Overheal", 1],
    ["Bumper Kart: Bomb Head", 1],
]

::TF_COND_NAMES <- [
    "AIMING"
    "ZOOMED"
    "DISGUISING"
    "DISGUISED"
    "STEALTHED"
    "INVULNERABLE"
    "TELEPORTED"
    "TAUNTING"
    "INVULNERABLE_WEARINGOFF"
    "STEALTHED_BLINK"
    "SELECTED_TO_TELEPORT"
    "CRITBOOSTED"
    "TMPDAMAGEBONUS"
    "FEIGN_DEATH"
    "PHASE"
    "STUNNED"
    "OFFENSEBUFF"
    "SHIELD_CHARGE"
    "DEMO_BUFF"
    "ENERGY_BUFF"
    "RADIUSHEAL"
    "HEALTH_BUFF"
    "BURNING"
    "HEALTH_OVERHEALED"
    "URINE"
    "BLEEDING"
    "DEFENSEBUFF"
    "MAD_MILK"
    "MEGAHEAL"
    "REGENONDAMAGEBUFF"
    "MARKEDFORDEATH"
    "NOHEALINGDAMAGEBUFF"
    "SPEED_BOOST"
    "CRITBOOSTED_PUMPKIN"
    "CRITBOOSTED_USER_BUFF"
    "CRITBOOSTED_DEMO_CHARGE"
    "SODAPOPPER_HYPE"
    "CRITBOOSTED_FIRST_BLOOD"
    "CRITBOOSTED_BONUS_TIME"
    "CRITBOOSTED_CTF_CAPTURE"
    "CRITBOOSTED_ON_KILL"
    "CANNOT_SWITCH_FROM_MELEE"
    "DEFENSEBUFF_NO_CRIT_BLOCK"
    "REPROGRAMMED"
    "CRITBOOSTED_RAGE_BUFF"
    "DEFENSEBUFF_HIGH"
    "SNIPERCHARGE_RAGE_BUFF"
    "DISGUISE_WEARINGOFF"
    "MARKEDFORDEATH_SILENT"
    "DISGUISED_AS_DISPENSER"
    "SAPPED"
    "INVULNERABLE_HIDE_UNLESS_DAMAGED"
    "INVULNERABLE_USER_BUFF"
    "HALLOWEEN_BOMB_HEAD"
    "HALLOWEEN_THRILLER"
    "RADIUSHEAL_ON_DAMAGE"
    "CRITBOOSTED_CARD_EFFECT"
    "INVULNERABLE_CARD_EFFECT"
    "MEDIGUN_UBER_BULLET_RESIST"
    "MEDIGUN_UBER_BLAST_RESIST"
    "MEDIGUN_UBER_FIRE_RESIST"
    "MEDIGUN_SMALL_BULLET_RESIST"
    "MEDIGUN_SMALL_BLAST_RESIST"
    "MEDIGUN_SMALL_FIRE_RESIST"
    "STEALTHED_USER_BUFF"
    "MEDIGUN_DEBUFF"
    "STEALTHED_USER_BUFF_FADING"
    "BULLET_IMMUNE"
    "BLAST_IMMUNE"
    "FIRE_IMMUNE"
    "PREVENT_DEATH"
    "MVM_BOT_STUN_RADIOWAVE"
    "HALLOWEEN_SPEED_BOOST"
    "HALLOWEEN_QUICK_HEAL"
    "HALLOWEEN_GIANT"
    "HALLOWEEN_TINY"
    "HALLOWEEN_IN_HELL"
    "HALLOWEEN_GHOST_MODE"
    "MINICRITBOOSTED_ON_KILL"
    "OBSCURED_SMOKE"
    "PARACHUTE_ACTIVE"
    "BLASTJUMPING"
    "HALLOWEEN_KART"
    "HALLOWEEN_KART_DASH"
    "BALLOON_HEAD"
    "MELEE_ONLY"
    "SWIMMING_CURSE"
    "FREEZE_INPUT"
    "HALLOWEEN_KART_CAGE"
    "DONOTUSE_0"
    "RUNE_STRENGTH"
    "RUNE_HASTE"
    "RUNE_REGEN"
    "RUNE_RESIST"
    "RUNE_VAMPIRE"
    "RUNE_REFLECT"
    "RUNE_PRECISION"
    "RUNE_AGILITY"
    "GRAPPLINGHOOK"
    "GRAPPLINGHOOK_SAFEFALL"
    "GRAPPLINGHOOK_LATCHED"
    "GRAPPLINGHOOK_BLEEDING"
    "AFTERBURN_IMMUNE"
    "RUNE_KNOCKOUT"
    "RUNE_IMBALANCE"
    "CRITBOOSTED_RUNE_TEMP"
    "PASSTIME_INTERCEPTION"
    "SWIMMING_NO_EFFECTS"
    "PURGATORY"
    "RUNE_KING"
    "RUNE_PLAGUE"
    "RUNE_SUPERNOVA"
    "PLAGUE"
    "KING_BUFFED"
    "TEAM_GLOWS"
    "KNOCKED_INTO_AIR"
    "COMPETITIVE_WINNER"
    "COMPETITIVE_LOSER"
    "HEALING_DEBUFF"
    "PASSTIME_PENALTY_DEBUFF"
    "GRAPPLED_TO_PLAYER"
    "GRAPPLED_BY_PLAYER"
    "PARACHUTE_DEPLOYED"
    "GAS"
    "BURNING_PYRO"
    "ROCKETPACK"
    "LOST_FOOTING"
    "AIR_CURRENT"
    "HALLOWEEN_HELL_HEAL"
    "POWERUPMODE_DOMINANT"
    "IMMUNE_TO_PUSHBACK"
];
