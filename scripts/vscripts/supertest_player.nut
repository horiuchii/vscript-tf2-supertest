::PlayerSpawned <- [];
::GlobalTickCounter <- 0;
::GlobalRespawnroom <- SpawnEntityFromTable("func_respawnroom", {
    spawnflags = 1,
    IsEnabled = true,
    StartDisabled = 0,
    TeamNum = 0
});
::env_hudhint_menu <- SpawnEntityFromTable("env_hudhint", {message = "%+attack3% DOUBLE TAP OR CHAT /menu TO OPEN MENU"});

OnGameEvent("player_spawn", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    EntFireByHandle(GlobalRespawnroom, "StartTouch", null, 0.1, player, player)
    EntFireByHandle(env_hudhint_menu, "ShowHudHint", "", 0, player, player);

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

OnGameEvent("player_disconnect", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    player.RemoveInstancedProps();
})

OnGameEvent("post_inventory_application", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(IsPlayerABot(player))
        return;

    player.ValidateScriptScope()
    RunWithDelay(-1, function(){
        if(!safeget(params, "dont_reequip", false))
        {
            SetPropInt(player, "m_Shared.m_bShieldEquipped", 0)
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
    SetVar("last_saved_cloak", 0);

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
    foreach(player in GetAlivePlayers())
    {
        if(IsPlayerABot(player))
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

    if(WasButtonJustPressed(IN_ATTACK3))
    {
        if (Time() - GetVar("last_press_menu_button") < OPEN_MENU_DOUBLEPRESS_TIME)
            OpenMenu();
        else
            SetVar("last_press_menu_button", Time());
    }
}