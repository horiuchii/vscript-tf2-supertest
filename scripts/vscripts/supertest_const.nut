::TICKRATE_TIME <- 0.01515151515;
::CONTRACKER_HUD <- "vgui/contracker_hud/";
::CHAT_PREFIX <- "\x07" + "66B2B2" + "[SUPER TEST] " + "\x07" + "DAFFF9";

::OPEN_MENU_DOUBLEPRESS_TIME <- 0.35;

::TF_CLASSES <- [
    "scout"
    "sniper"
    "soldier"
    "demoman"
    "medic"
    "heavy"
    "pyro"
    "spy"
    "engineer"
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

::DAI_INITIAL_TICKS <- 12; // how many ticks until DAI starts
::DAI_PERIOD_TICKS <- 8; // how many ticks inbetween DAI inputs
::SIDE_DAI_INITIAL_TICKS <- 10; // how many ticks until DAI starts
::SIDE_DAI_PERIOD_TICKS <- 10; // how many ticks inbetween DAI inputs

::FLAG_WARPAINT_AND_UNUSUAL <- 1
::FLAG_ACCEPTS_ENERGYORB <- 2
::FLAG_FESTIVIZER <- 4
::FLAG_AUSTRAILIUM <- 8