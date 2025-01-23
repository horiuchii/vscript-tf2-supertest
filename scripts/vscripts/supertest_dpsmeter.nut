// ::dps_boss <- SpawnEntityFromTable("base_boss", {
//     origin = FindByName(null, "base_boss_spawn_point").GetOrigin()
//     model = "models/bots/boss_bot/static_boss_tank.mdl"
//     health = 300
// })

// dps_boss.AcceptInput("SetStepHeight", "0", null, null)
// dps_boss.AcceptInput("SetSpeed", "0", null, null)

// AddListener("tick_frame", 0, function()
// {
//     dps_boss.AcceptInput("SetHealth", "99999999999999999999999999999999999999999", null, null)
// });