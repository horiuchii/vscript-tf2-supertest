::DEBUG <- !!GetDeveloperLevel();

::projectDir <- ""
IncludeScript(projectDir+"/__lizardlib/_lizardlib.nut", this);
IncludeScript(projectDir+"supertest_const.nut", this);
IncludeScript(projectDir+"supertest_util.nut", this);
IncludeScript(projectDir+"supertest_cookies.nut", this);
IncludeScript(projectDir+"menus/menus.nut", this);
IncludeScript(projectDir+"supertest_weapons.nut", this);
IncludeScript(projectDir+"supertest_hud.nut", this);
IncludeScript(projectDir+"supertest_player.nut", this);
IncludeScript(projectDir+"supertest_dpsmeter.nut", this);

ServerCookies.LoadServerData();
SetServerCookieCVars();
RemoveSpawnedBots();

Convars.SetValue("mp_waitingforplayers_cancel", 1);
Convars.SetValue("mp_teams_unbalance_limit", 0);
Convars.SetValue("sv_alltalk", 1);
Convars.SetValue("mp_disable_respawn_times", 1);
Convars.SetValue("tf_bot_reevaluate_class_in_spawnroom", 0);
Convars.SetValue("tf_bot_keep_class_after_death", 1);
ForceEnableUpgrades(2);

function TickFrame()
{
    FireListeners("tick_frame", {});
    return -1;
}

OnGameEvent("player_say", function(params)
{
    if(params.text == "/toggle_debug")
        DEBUG = !DEBUG;
})