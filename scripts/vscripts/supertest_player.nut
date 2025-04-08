::PlayerSpawned <- [];
::GlobalTickCounter <- 0;
::GlobalRespawnroom <- SpawnEntityFromTable("func_respawnroom", {
    spawnflags = 1,
    IsEnabled = true,
    StartDisabled = 0,
    TeamNum = 0
});
GlobalRespawnroom.SetSolid(SOLID_NONE)
::env_hudhint_menu <- SpawnEntityFromTable("env_hudhint", {message = "%+attack3% DOUBLE TAP OR CHAT /menu TO OPEN MENU"});

OnGameEvent("player_spawn", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    if (params.team == 0)
    {
        SendGlobalGameEvent("player_activate", {userid = params.userid});
        player.ClearText();
    }

    player.ValidateScriptScope();
    Cookies.CreateCache(player);

    if(PlayerSpawned.find(player) != null)
        return;

    PlayerSpawned.append(player);
    player.InitPlayerVariables();
})

OnGameEvent("player_spawn", 1, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    if(player.GetTeam() != TF_TEAM_RED && player.GetTeam() != TF_TEAM_BLUE)
        return;

    EntFireByHandle(GlobalRespawnroom, "StartTouch", null, 0.1, player, player);

    if(Time() - player.GetVar("last_show_menu_hint") < MENU_HINT_COOLDOWN_TIME)
    {
        player.SetVar("last_show_menu_hint", 0);
        EntFireByHandle(env_hudhint_menu, "ShowHudHint", "", 0, player, player);
    }

    if(!player.GetVar("last_life_death"))
    {
        if(player.GetVar("last_saved_pos") != null)
            player.SetAbsOrigin(player.GetVar("last_saved_pos"))
        if(player.GetVar("last_saved_ang") != null)
            player.SnapEyeAngles(player.GetVar("last_saved_ang"))
        if(player.GetVar("last_saved_ducked"))
            SetPropBool(player, "m_Local.m_bDucking", true)
        if(player.GetVar("last_saved_velocity"))
            player.SetAbsVelocity(player.GetVar("last_saved_velocity"))
    }

    player.SetVar("last_life_death", false);
})

OnGameEvent("player_death", 1, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    player.SetVar("last_life_death", true);
})

OnGameEvent("player_activate", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    Cookies.CreateCache(player);
})

OnGameEvent("player_team", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    //if we switch to spectator, remove the menu
    if(params.team != TF_TEAM_RED && params.team != TF_TEAM_BLUE)
    {
        player.SetScriptOverlayMaterial(null);
        player.SetVar("menu", null);
    }
})

OnGameEvent("post_inventory_application", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player) || player.GetTeam() == TEAM_UNASSIGNED)
        return;

    player.ValidateScriptScope()
    RunWithDelay(-1, function()
    {
        if(!safeget(params, "dont_reequip", false))
        {
            player.EquipDesiredWeapons();
        }
        player.SetHealth(player.GetMaxHealth())
        //delete any dropped weapons near us
        local entity = null
        while (entity = FindByClassname(entity, "tf_dropped_weapon"))
        {
            local dist = (entity.GetOrigin() - player.EyePosition()).Length()
            if(dist < 128)
                entity.Destroy()
        }
    })
})

::CTFPlayer.InitPlayerVariables <- function()
{
    SetVar("menu", null);
    SetVar("stored_menu", null);
    SetVar("last_press_menu_button", 0);
    SetVar("dai_ticks", 0);
    SetVar("dai_direction", null);
    SetVar("side_dai_ticks", 0);
    SetVar("side_dai_direction", null);
    SetVar("last_saved_cloak", 0);

    SetVar("last_show_menu_hint", 0);

    SetVar("taunt_tick_listener", null);

    SetVar("show_conds", false);
    SetVar("show_keys", false);

    SetVar("inf_cash", true);
    SetVar("inf_ammo", false);
    SetVar("inf_clip", false);
    SetVar("invuln", false);

    SetVar("last_buttons", 0);

    SetVar("priority_weapon_switch_slot", null);

    if(!"wearables" in GetScriptScope())
        SetVar("wearables", [])

    SetVar("last_life_death", false);
    SetVar("last_saved_pos", null);
    SetVar("last_saved_ang", null);
    SetVar("last_saved_ducked", null);
    SetVar("last_saved_velocity", null);
}

AddListener("tick_frame", 0, function()
{
    GlobalTickCounter += 1;
    foreach(player in GetPlayers())
    {
        if(IsPlayerABot(player))
            return;

        if(PlayerSpawned.find(player) == null)
            return;

        player.OnTick();
        player.SetVar("last_buttons", player.GetButtons());
    }
});

::CTFPlayer.OnTick <- function()
{
    if(DEBUG)
        DrawDebugVars();

    SetVar("last_saved_pos", GetOrigin());
    SetVar("last_saved_ang", EyeAngles());
    SetVar("last_saved_ducked", GetPropBool(this, "m_Local.m_bDucked"));
    SetVar("last_saved_velocity", GetAbsVelocity());

    if(GetVar("menu"))
    {
        HandleCurrentMenu();
        return;
    }

    SetPropInt(this, "m_takedamage", GetVar("invuln") ? DAMAGE_EVENTS_ONLY : DAMAGE_YES);

    if(GetVar("inf_cash"))
    {
        SetCurrency(30000);
    }

    if(GetVar("inf_ammo") || GetVar("inf_clip"))
    {
        for(local i = 0; i < MAX_WEAPONS; i++)
        {
            local heldWeapon = GetPropEntityArray(this, "m_hMyWeapons", i);
            if(heldWeapon == null)
                continue;

            if(GetVar("inf_clip"))
                heldWeapon.SetClip1(heldWeapon.GetMaxClip1());
            if(GetVar("inf_ammo"))
                UpdateReserveAmmoOnWeapon(heldWeapon);
        }
    }

    if(GetVar("show_conds"))
    {
        DrawConditions();
    }

    if(GetVar("show_keys"))
    {
        DrawKeys();
    }

    if(WasButtonJustPressed(IN_ATTACK3))
    {
        if(Time() - GetVar("last_press_menu_button") < OPEN_MENU_DOUBLEPRESS_TIME)
            OpenMenu();
        else
            SetVar("last_press_menu_button", Time());
    }

    if(GetActiveWeapon())
        SetVar("priority_weapon_switch_slot", GetActiveWeapon().GetSlot());
}

::CTFPlayer.DrawConditions <- function()
{
    if((GlobalTickCounter % 2) == 1)
        return;

    local hud_string = "";
    foreach(cond_index, cond_name in TF_COND_NAMES)
    {
        if(!InCond(cond_index))
            continue;

        local cond_time = GetCondDuration(cond_index);
        local hud_string_addition = "[" + cond_index + "] " + cond_name + " " + (cond_time <= 0 ? "∞" : format("%.2f", cond_time)) + "\n";

        if(hud_string_addition.len() + hud_string.len() >= 225)
            break;
        else
            hud_string += hud_string_addition;
    }

    SendGameText(0, -1, 4, "255 255 255", hud_string);
}

::CTFPlayer.DrawKeys <- function()
{
    if((GlobalTickCounter % 2) == 0)
        return;

    local hud_string = "";
    foreach(key in DRAW_KEYS)
    {
        hud_string += "[" + key + "] " + (IsHoldingButton(getroottable()[key.tostring()]) ? "[ О ]\n" : "[ Χ ]\n");
    }
    SendGameText(1, -1, 3, "255 255 255", hud_string);
}