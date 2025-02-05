::RemoveSpawnedBots <- function()
{
    local training_logic = CreateByClassname("tf_logic_training_mode")
    training_logic.AcceptInput("KickBots", "", null, null)
    training_logic.Kill()
}

DefineMenu(class extends Menu{
    id = "bot_controls"
    function constructor(){
        items = [
        class extends MenuItem{
            titles = ["Generate RED Bots" "Generate BLU Bots"];

            function GenerateDesc(player)
            {
                return "Generate a team of " + (index ? "BLU" : "RED") +" bots in the range.";
            }

            function OnSelected(player)
            {
                RemoveSpawnedBots()
                RunWithDelay(0.1, function()
                {
                    local entity = null
                    while (entity = Entities.FindByClassname(entity, "bot_generator"))
                    {
                        entity.KeyValueFromString("team", index ? "blue" : "red")
                    }

                    EntFire("botspawn", "spawnbot")

                    RunWithDelay(-1, function()
                    {
                        local entity = null
                        while (entity = FindByClassname(entity, "player"))
                        {
                            if(!IsPlayerABot(entity) || entity.GetBotType() != TF_BOT_TYPE)
                                continue;

                            entity.SnapEyeAngles(QAngle(0,-90,0))
                        }
                    })
                })
            }
        },
        class extends MenuItem{
            titles = ["Remove Bots"];

            function GenerateDesc(player)
            {
                return "Kick all bots from the game.";
            }

            function OnSelected(player)
            {
                RemoveSpawnedBots()
            }
        },
        class extends MenuItem{
            titles = ["Teleport to range"];

            function GenerateDesc(player)
            {
                return "Teleport yourself and angle your camera\nat the range for an ideal showcase view.";
            }

            function OnSelected(player)
            {
                local range_teleport = FindByName(null, "range_teleport")
                if(!range_teleport)
                    return;

                player.SetAbsOrigin(range_teleport.GetOrigin())
                player.SnapEyeAngles(QAngle(0,90,0))
            }
        }]
    }
})