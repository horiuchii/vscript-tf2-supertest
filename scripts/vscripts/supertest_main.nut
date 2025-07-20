::DEBUG <- !!GetDeveloperLevel();
::IS_SUPERTEST <- GetMapName().find("supertest") != null;

::projectDir <- ""
IncludeScript(projectDir+"/__lizardlib/_lizardlib.nut", this);
IncludeScript(projectDir+"supertest_const.nut", this);
IncludeScript(projectDir+"supertest_generated_data.nut", this);
IncludeScript(projectDir+"supertest_util.nut", this);
IncludeScript(projectDir+"supertest_cookies.nut", this);
IncludeScript(projectDir+"menus/menus.nut", this);
IncludeScript(projectDir+"supertest_weapons.nut", this);
IncludeScript(projectDir+"supertest_hud.nut", this);
IncludeScript(projectDir+"supertest_player.nut", this);
IncludeScript(projectDir+"supertest_dpsmeter.nut", this);

ServerCookies.LoadServerData();
SuppressMessages(0.2);
RunWithDelay(0.1, function(){
    SetServerCookieCVars();
    RemoveSpawnedBots();
})

SetPropBool(tf_gamerules, "m_bIsInTraining", false)

Convars.SetValue("mp_waitingforplayers_cancel", 1);
Convars.SetValue("mp_teams_unbalance_limit", 0);
Convars.SetValue("sv_alltalk", 1);
Convars.SetValue("mp_disable_respawn_times", 1);
Convars.SetValue("tf_bot_reevaluate_class_in_spawnroom", 0);
Convars.SetValue("tf_bot_keep_class_after_death", 1);
Convars.SetValue("tf_player_movement_restart_freeze", 0);
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

if(!IS_SUPERTEST)
{
    //respawn players so that the player vars can exist
    foreach(player in GetPlayers())
    {
        player.ForceRespawn();
    }

    //if we're in a map without upgrade stations, make it so when we touch a resupply cabinet we open the menu
    if(!FindByClassname(null, "func_upgradestation"))
    {
        local entity = null
        while(entity = FindByClassname(entity, "func_regenerate"))
        {
            local brush = SpawnEntityFromTable("func_upgradestation", {
                model = entity.GetModelName()
                origin = entity.GetOrigin()
                angles = entity.GetAbsAngles()
                spawnflags = 1
            })
            brush.SetSolid(SOLID_OBB);
        }
    }
}