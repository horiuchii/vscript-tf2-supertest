if(!IS_SUPERTEST)
    return;

::spawn_point <- FindByName(null, "base_boss_spawn_point");

::SpawnTank <- function()
{
    if(!spawn_point)
        return;

    local dps_boss = SpawnEntityFromTable("tank_boss", {
        origin = spawn_point.GetOrigin()
    });

    dps_boss.KeyValueFromInt("disableshadows", 1);
    dps_boss.SetAbsAngles(QAngle(0,-120,0));
    dps_boss.AcceptInput("SetStepHeight", "0", null, null);
    dps_boss.AcceptInput("SetSpeed", "0", null, null);
    dps_boss.AcceptInput("SetTeam", "0", null, null);
    SetPropInt(dps_boss, "m_takedamage", DAMAGE_EVENTS_ONLY);

    local tank_attachment = null;
    while(tank_attachment = FindByClassname(tank_attachment, "prop_dynamic"))
    {
        local model_name = tank_attachment.GetModelName();
        if(model_name.find("boss_bot/tank_track_") != null || model_name == "models/bots/boss_bot/bomb_mechanism.mdl");
        {
            tank_attachment.KeyValueFromInt("disableshadows", 1);
        }
    }
}
SpawnTank();