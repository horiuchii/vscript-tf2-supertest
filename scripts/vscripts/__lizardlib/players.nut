//A valid _client_ can be a spectator. A valid _player_ can not.
::GetClients <- function()
{
    local allPlayers = [];
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (player)
            allPlayers.push(player);
    }
    return allPlayers;
}
::GetAllClients <- GetClients

//A valid _client_ can be a spectator. A valid _player_ can not.
::GetPlayers <- function(team = null)
{
    local allPlayers = [];
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (player && player.GetTeam() > 1 && (!team || player.GetTeam() == team))
            allPlayers.push(player);
    }
    return allPlayers;
}
::GetAllPlayers <- GetPlayers

::GetAlivePlayers <- function(team = null)
{
    local alivePlayers = [];
    for (local i = 1; i <= MAX_PLAYERS; i++)
    {
        local player = PlayerInstanceFromIndex(i);
        if (player && GetPropInt(player, "m_lifeState") == 0 && (!team || player.GetTeam() == team))
            alivePlayers.push(player);
    }
    return alivePlayers;
}

::CTFPlayer.IsAlive <- function()
{
    return GetPropInt(this, "m_lifeState") == 0;
}
::CTFBot.IsAlive <- CTFPlayer.IsAlive;

::CTFPlayer.IsOnGround <- function()
{
    return GetPropEntity(this, "m_hGroundEntity") != null;
}
::CTFBot.IsOnGround <- CTFPlayer.IsOnGround;

//A valid _client_ can be a spectator. A valid _player_ can not.
::IsValidClient <- function(player)
{
    try
    {
        return player && player.IsValid() && player.IsPlayer();
    }
    catch(e)
    {
        return false;
    }
}

//A valid _client_ can be a spectator. A valid _player_ can not.
::IsValidPlayer <- function(player)
{
    try
    {
        return player && player.IsValid() && player.IsPlayer() && player.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::IsValidPlayerOrBuilding <- function(entity)
{
    try
    {
        return entity
            && entity.IsValid()
            && entity.GetTeam() > 1
            && (entity.IsPlayer() || startswith(entity.GetClassname(), "obj_"));
    }
    catch(e)
    {
        return false;
    }
}

::IsValidBuilding <- function(building)
{
    try
    {
        return building
            && building.IsValid()
            && startswith(building.GetClassname(), "obj_")
            && building.GetTeam() > 1;
    }
    catch(e)
    {
        return false;
    }
}

::CTFPlayer.GetUserID <- function()
{
    return GetPropIntArray(tf_player_manager, "m_iUserID", this.entindex());
}
::CTFBot.GetUserID <- CTFPlayer.GetUserID;

::GetPlayerFromParams <- function(params, key = "userid")
{
    if (!(key in params))
        return null;
    local player = GetPlayerFromUserID(params[key]);
    if (IsValidPlayer(player))
        return player;
    return null;
}

::CTFPlayer.Yeet <- function(vector)
{
    SetPropEntity(this, "m_hGroundEntity", null);
    this.ApplyAbsVelocityImpulse(vector);
    this.RemoveFlag(FL_ONGROUND);
}
::CTFBot.Yeet <- CTFPlayer.Yeet;

//Normal ForceChangeTeam will not work if the player is dueling. This is a fix.
::CTFBot.SwitchTeam <- function(team)
{
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_iTeamNum", team);
}

::CTFPlayer.SwitchTeam <- function(team)
{
    SetPropInt(this, "m_bIsCoaching", 1);
    this.ForceChangeTeam(team, true);
    SetPropInt(this, "m_bIsCoaching", 0);
}

::CTFPlayer.GetWeaponsAndCosmetics <- function()
{
    local items = [];
    local extraVM;
    for (local item = this.FirstMoveChild(); item != null; item = item.NextMovePeer())
    {
        local className = item.GetClassname();
        if (startswith(className, "tf_we") || className == "tf_powerup_bottle")
        {
            items.push(item);
            if (extraVM = GetPropEntity(item, "m_hExtraWearableViewModel"))
                items.push(extraVM);
        }
    }
    return items;
}
::CTFBot.GetWeaponsAndCosmetics <- CTFPlayer.GetWeaponsAndCosmetics;

::CTFPlayer.GetAttachments <- function()
{
    local items = [];
    local extraVM;
    for (local item = this.FirstMoveChild(); item != null; item = item.NextMovePeer())
        if (item.GetClassname() != "tf_viewmodel")
        {
            items.push(item);
            if (extraVM = GetPropEntity(item, "m_hExtraWearableViewModel"))
                items.push(extraVM);
        }
    return items;
}
::CTFBot.GetAttachments <- CTFPlayer.GetAttachments;

::CTFPlayer.GetWeaponBySlot <- function(slot)
{
	for (local i = 0; i < 7; i++)
	{
		local weapon = GetPropEntityArray(this, "m_hMyWeapons", i);
        if (weapon && weapon.GetSlot() == slot)
            return weapon;
	}
    return null;
}
::CTFBot.GetWeaponBySlot <- CTFPlayer.GetWeaponBySlot;

::CTFPlayer.Heal <- function(healing, dispalyOnHud = true, healer = null)
{
    local oldHP = this.GetHealth();
    local newHP = clampFloor(oldHP, clampCeiling(oldHP + healing, this.GetMaxHealth()));
    this.SetHealth(newHP);

    if(!dispalyOnHud || newHP - oldHP <= 0)
        return;

    if(IsValidPlayer(healer))
    {
        SendGlobalGameEvent("player_healed", {
            patient = this.GetUserID()
            healer = healer.GetUserID()
            amount = newHP - oldHP
        })
    }

    SendGlobalGameEvent("player_healonhit", {
        entindex = this.entindex(),
        amount = newHP - oldHP
    });

}
::CTFBot.Heal <- CTFPlayer.Heal;

//Might change in the future.
//I dislike that you need to manually type `player.entindex()` as a key,
// but using the ent index is the whole point - it gives us safety against nulls, invalid entities and out-of-bounds
::player_collection <- function(defValue = 0)
{
    local array = [];
    array.resize(MAX_PLAYERS + 1, defValue);
    OnGameEvent("player_connect", -999, function(player, params)
    {
        this[params.index+1] = defValue;
    }, array);
    return array;
}
::playerCollection <- player_collection;
::PlayerCollection <- player_collection;
::GetPlayerCollection <- player_collection;