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

::message_suppressor <- null;
::suppress_time <- 0.0
SetPropBool(tf_gamerules, "m_bIsInTraining", false)
ServerCookies.LoadServerData();

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
    if(::suppress_time < Time())
    {
        KillIfValid(::message_suppressor)
        SetPropBool(tf_gamerules, "m_bIsInTraining", false)
    }

    FireListeners("tick_frame", {});
    return -1;
}

::SuppressMessages <- function(time)
{
    ::suppress_time <- Time() + time

    if(!IsValid(::message_suppressor))
    {
        ::message_suppressor <- CreateByClassname("point_commentary_node")
        ::message_suppressor.KeyValueFromString("classname", "killme") //dont keep between rounds
    }
    SetPropBool(tf_gamerules, "m_bIsInTraining", true)
}

SetServerCookieCVars();
RemoveSpawnedBots();


::SlowTick <- function()
{
    FireListeners("tick_slow", {});
    return 0.1;
}
AddThinkToEnt(tf_gamerules, "SlowTick")

OnGameEvent("player_say", function(params)
{
    if(params.text == "/toggle_debug")
        DEBUG = !DEBUG;
})

function OnPostSpawn()
{
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
    else
    {
        local entity = null
        while(entity = FindByClassname(entity, "item_teamflag"))
        {
            SetPropBool(entity, "m_bGlowEnabled", false)
        }
        while(entity = FindByClassname(entity, "team_train_watcher"))
        {
            SetPropEntity(entity, "m_hGlowEnt", null)
        }
        SetPropInt(tf_gamerules, "m_nGameType", 0)
        ForceEscortPushLogic(2)

        local tank_spawn_point = FindByName(null, "base_boss_spawn_point");
        if(tank_spawn_point)
        {
            local dps_boss = SpawnEntityFromTable("tank_boss", {
                origin = tank_spawn_point.GetOrigin()
            });

            dps_boss.KeyValueFromInt("disableshadows", 1);
            dps_boss.SetAbsAngles(QAngle(0,-120,0));
            dps_boss.AcceptInput("SetStepHeight", "0", null, null);
            dps_boss.AcceptInput("SetSpeed", "0", null, null);
            dps_boss.AcceptInput("SetTeam", "1", null, null); //unassigned breaks damage
            SetPropInt(dps_boss, "m_takedamage", DAMAGE_EVENTS_ONLY);
            dps_boss.AddEFlags(EFL_NO_THINK_FUNCTION)

            local tank_attachment = null;
            while(tank_attachment = FindByClassname(tank_attachment, "prop_dynamic"))
            {
                local model_name = tank_attachment.GetModelName();
                if(model_name.find("boss_bot/tank_track_") != null || model_name == "models/bots/boss_bot/bomb_mechanism.mdl")
                {
                    tank_attachment.SetSequence(0)
                    tank_attachment.KeyValueFromInt("disableshadows", 1);
                }
            }
        }
    }
}
