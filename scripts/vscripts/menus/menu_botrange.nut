::RemoveSpawnedBots <- function()
{
    local training_logic = CreateByClassname("tf_logic_training_mode")
    training_logic.AcceptInput("KickBots", "", null, null)
    training_logic.Kill()
}

::BotEquip <- function(item, class_index = null)
{
    local entity = null
    while (entity = FindByClassname(entity, "player"))
    {
        if(!IsPlayerABot(entity) || entity.GetBotType() != TF_BOT_TYPE)
            continue;

        if(class_index != null && entity.GetPlayerClass() != class_index)
            continue;

        entity.GenerateAndWearItem(item)
    }
}

::SpawnedBotType <-
[
    "Normal"
    "Zombie"
    "Robot"
]

ServerCookies.AddCookie("spawned_bot_type", "Normal");

OnGameEvent("player_spawn", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(!IsPlayerABot(player) || player.GetBotType() != TF_BOT_TYPE)
        return;

    RunWithDelay(-1, function()
    {
        player.SnapEyeAngles(QAngle(0,-90,0));

        switch(ServerCookies.Get("spawned_bot_type"))
        {
            case "Zombie":
            {
                if(!IsHolidayActive(kHoliday_HalloweenOrFullMoon))
                    return;

                local model_names = ["Scout", "Soldier", "Pyro", "Demo", "Heavy", "Engineer", "Medic", "Sniper", "Spy"];
                player.GenerateAndWearItem("Zombie " + model_names[TF_CLASS_REMAP[player.GetPlayerClass()]]);
                break;
            }
            case "Robot":
            {
                local model_names = ["scout", "soldier", "pyro", "demo", "heavy", "engineer", "medic", "sniper", "spy"];
                local model_name = model_names[TF_CLASS_REMAP[player.GetPlayerClass()]];
                player.SetCustomModelWithClassAnimations("models/bots/" + model_name + "/bot_" + model_name + ".mdl");
                break;
            }
        }
    })
})

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
                })
            }
        },
        class extends MenuItem{
            titles = [];

            function OnMenuOpened(player){
                local pre = "Bot Skin: "
                titles = []
                foreach (bot_skin_name in SpawnedBotType)
                {
                    titles.append(pre + bot_skin_name)
                }
            }

            function GenerateDesc(player)
            {
                return "Equip spawning bots with a special skin.\nCurrent: " + ServerCookies.Get("spawned_bot_type");
            }

            function OnSelected(player)
            {
                local new_bot_type = SpawnedBotType[index];
                ServerCookies.Set("spawned_bot_type", new_bot_type)

                if(new_bot_type == "Zombie" && !IsHolidayActive(kHoliday_HalloweenOrFullMoon))
                {
                    Convars.SetValue("tf_force_holiday", kHoliday_FullMoon);
                    player.SendChat(CHAT_PREFIX + "Forced the holiday to \"Full Moon\" to allow the Zombie skin to appear.");
                }


                if(new_bot_type == "Normal")
                    player.SendChat(CHAT_PREFIX + "Newly spawned bots will have no skin applied to them.");
                else
                    player.SendChat(CHAT_PREFIX + "Newly spawned bots will have the " + new_bot_type + " skin applied to them.");
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
        },
        class extends MenuItem{
            titles = [];

            function OnMenuOpened(player){
                local pre = "Give Item ("
                local classes = ["All Class" "Scout" "Soldier" "Pyro" "Demoman" "Heavy" "Engineer" "Medic" "Sniper" "Spy"]
                titles = []
                foreach (class_name in classes)
                {
                    titles.append(pre + class_name + ")")
                }
            }

            function GenerateDesc(player)
            {
                local class_name = "";

                if(index == 0)
                    class_name = "a bot of any class";
                else
                    class_name = TF_CLASSES[TF_CLASS_REMAP_INV[index - 1] - 1] + " bots";

                return "Give an item to " + class_name + ". Type in chat\nto add an item to equip when bots spawn, the name\nmust be from fields \"name\" or \"base_item_name\"";
            }
        }]
    }
})

OnGameEvent("player_say", 101, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    local menu = player.GetVar("menu");
    if(!menu)
        return;

    if(menu.id != "bot_controls")
        return;

    //this is a stupid way of looking for the data we need, but we only need to do it once
    local selected_menu_item = menu.items[menu.selected_index];
    local title = selected_menu_item.titles[selected_menu_item.index];

    if(title.find("Give Item") != null)
    {
        local index = selected_menu_item.index;
        local msg = params.text;

        if(index == 0)
            BotEquip(msg);
        else
            BotEquip(msg, TF_CLASS_REMAP_INV[index - 1]);
    }
})