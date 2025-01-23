::TICKRATE_TIME <- 0.01515151515;
::CONTRACKER_HUD <- "vgui/contracker_hud/";

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

::KILLSTREAK_COLOR_TEAM_SHINE <- 1
::KILLSTREAK_COLOR_DEADLY_DAFFODIL <- 2
::KILLSTREAK_COLOR_MANNDARIN <- 3
::KILLSTREAK_COLOR_MEAN_GREEN <- 4
::KILLSTREAK_COLOR_AGONIZING_EMERALD <- 5
::KILLSTREAK_COLOR_VILLAINOUS_VIOLET <- 6
::KILLSTREAK_COLOR_HOT_ROD <- 7

::KILLSTREAK_COLOR <- {
    [KILLSTREAK_COLOR_TEAM_SHINE] = "Team Shine",
    [KILLSTREAK_COLOR_DEADLY_DAFFODIL] = "Deadly Daffodil",
    [KILLSTREAK_COLOR_MANNDARIN] = "Manndarin",
    [KILLSTREAK_COLOR_MEAN_GREEN] = "Mean Green",
    [KILLSTREAK_COLOR_AGONIZING_EMERALD] = "Agonizing Emerald",
    [KILLSTREAK_COLOR_VILLAINOUS_VIOLET] = "Villainous Violet",
    [KILLSTREAK_COLOR_HOT_ROD] = "Hot Rod"
}


::DAI_INITIAL_TICKS <- 12; // how many ticks until DAI starts
::DAI_PERIOD_TICKS <- 8; // how many ticks inbetween DAI inputs

::FLAG_WARPAINT_AND_UNUSUAL <- 1
::FLAG_ACCEPTS_ENERGYORB <- 2
::FLAG_FESTIVIZER <- 4
::FLAG_AUSTRAILIUM <- 8