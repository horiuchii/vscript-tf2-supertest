//================================
//Exposed Functions.
//Intended for use by your code.
//================================

::AddPropFloat <- function(entity, property, value)
{
    SetPropFloat(entity, property, GetPropFloat(entity, property) + value);
}

::AddPropInt <- function(entity, property, value)
{
    SetPropInt(entity, property, GetPropInt(entity, property) + value);
}

//==============================
//Internal Functions.
//
//This code folds Constants and NetProps
//  so that you could write
//  GetPropInt(...) instead of NetProps.GetPropInt(...)
//  or
//  TF_CLASS_HEAVYWEAPONS instead of Constants.ETFClass.TF_CLASS_HEAVYWEAPONS
//==============================

//Thanks Ficool2 for the idea.

if ("TF_TEAM_UNASSIGNED" in root_table)
        return;

foreach (k, v in ::NetProps.getclass())
    if (k != "IsValid")
        root_table[k] <- ::NetProps[k].bindenv(::NetProps);

foreach (k, v in ::Entities.getclass())
    if (k != "IsValid")
        root_table[k] <- ::Entities[k].bindenv(::Entities);

foreach (k, v in ::EntityOutputs.getclass())
    if (k != "IsValid")
        root_table[k] <- ::EntityOutputs[k].bindenv(::EntityOutputs);

foreach (_, cGroup in Constants)
    foreach (k, v in cGroup)
        root_table[k] <- v != null ? v : 0;

::TF_TEAM_UNASSIGNED <- TEAM_UNASSIGNED;
::TF_TEAM_SPECTATOR <- TEAM_SPECTATOR;
::TF_CLASS_HEAVY <- TF_CLASS_HEAVYWEAPONS;
::MAX_PLAYERS <- MaxClients().tointeger();

::TF_CLASS_NAMES <- [
    "generic",
    "scout",
    "sniper",
    "soldier",
    "demo",
    "medic",
    "heavy",
    "pyro",
    "spy",
    "engineer",
    "civilian"
];

::MAX_WEAPONS <- 8

::SND_NOFLAGS <- 0
::SND_CHANGE_VOL <- 1
::SND_CHANGE_PITCH <- 2
::SND_STOP <- 4
::SND_SPAWNING <- 8
::SND_DELAY <- 16
::SND_STOP_LOOPING <- 32
::SND_SPEAKER <- 64
::SND_SHOULDPAUSE <- 128
::SND_IGNORE_PHONEMES <- 256
::SND_IGNORE_NAME <- 512
::SND_DO_NOT_OVERWRITE_EXISTING_ON_CHANNEL <- 1024