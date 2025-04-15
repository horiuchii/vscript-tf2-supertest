::dps_boss <- null;
::spawn_point <- FindByName(null, "base_boss_spawn_point");

AddListener("tick_frame", 0, function()
{
    if(!spawn_point.IsValid())
        return;

    if(!IsValid(dps_boss))
    {
        dps_boss = SpawnEntityFromTable("tank_boss", {
            origin = spawn_point.GetOrigin()
        });

        dps_boss.KeyValueFromInt("disableshadows", 1);
        dps_boss.SetAbsAngles(QAngle(0,-120,0));
        dps_boss.AcceptInput("SetStepHeight", "0", null, null);
        dps_boss.AcceptInput("SetSpeed", "0", null, null);
        dps_boss.AcceptInput("SetTeam", "0", null, null);

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

    dps_boss.AcceptInput("SetHealth", "214783647", null, null);
});