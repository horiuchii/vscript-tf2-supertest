::DEBUG <- true;

::projectDir <- ""
IncludeScript(projectDir+"/__lizardlib/_lizardlib.nut", this);
IncludeScript(projectDir+"supertest_const.nut", this);
IncludeScript(projectDir+"supertest_util.nut", this);
IncludeScript(projectDir+"supertest_cookies.nut", this);
IncludeScript(projectDir+"supertest_weapons.nut", this);
IncludeScript(projectDir+"menus/menus.nut", this);
IncludeScript(projectDir+"supertest_hud.nut", this);
IncludeScript(projectDir+"supertest_player.nut", this);
IncludeScript(projectDir+"supertest_dpsmeter.nut", this);

Convars.SetValue("mp_waitingforplayers_cancel", 1);
Convars.SetValue("sv_alltalk", 1);
Convars.SetValue("mp_disable_respawn_times", 1);

function OnPostSpawn()
{
    FireListeners("setup_start", {});
}

function TickFrame()
{
    FireListeners("tick_frame", {});
    return -1;
}

tf_gamerules.ValidateScriptScope();
tf_gamerules.GetScriptScope().Tick <- function()
{
    FireListeners("tick", {});
    return 0.1;
}
AddThinkToEnt(tf_gamerules, "Tick");

tf_player_manager.ValidateScriptScope();
tf_player_manager.GetScriptScope().Tick <- function()
{
    FireListeners("tick_player_manager", {});
    return -1;
}
AddThinkToEnt(tf_player_manager, "Tick");

OnGameEvent("player_say", function(params)
{
    if(params.text == "/toggle_debug")
        DEBUG = !DEBUG;
})