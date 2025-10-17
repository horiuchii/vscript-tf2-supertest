::RemoveSpawnedBots <- function()
{
    bots.clear()
    Convars.SetValue("tf_bot_count", 0)
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

::last_spawned_bot_time <- 0;

::last_player_that_spawned_bots <- null;
::bots <- [];
::SpawnedBotType <-
[
    "Normal"
    "Zombie"
    "Robot"
]

ServerCookies.AddCookie("spawned_bot_type", "Normal");
Cookies.AddCookie("spawned_bot_copy_loadout_weapons", 0);
Cookies.AddCookie("spawned_bot_desired_slot", LOADOUT_SLOT_IDS[0]);
Cookies.AddCookie("spawned_bot_copy_loadout_cosmetics", 0);
Cookies.AddCookie("spawned_bot_killstreak", 0);

OnGameEvent("player_spawn", 0, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(!IsPlayerABot(player) || player.GetBotType() != TF_BOT_TYPE)
        return;

    bots.append(player);
    RunWithDelay(-1, function()
    {
        //kill any cosmetics on us because im LAZY
        local entity = null
        while (entity = Entities.FindByClassname(entity, "tf_wearable"))
        {
            if (entity.GetOwner() == player)
                entity.Kill()
        }

        player.SnapEyeAngles(QAngle(0,-90,0));
        if(player.GetPlayerClass() == TF_CLASS_SPY)
            player.AddCustomAttribute("cannot disguise", 1.0, -1)

        //equip better skin!
        switch(ServerCookies.Get("spawned_bot_type"))
        {
            case "Zombie":
            {
                if(!IsHolidayActive(kHoliday_HalloweenOrFullMoon))
                    break;

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

        if(!IsValidPlayer(::last_player_that_spawned_bots))
            return;

        //give us new wepaons, if desired
        if(Cookies.Get(::last_player_that_spawned_bots, "spawned_bot_copy_loadout_weapons"))
        {
            for (local weapon_slot_index = WeaponSlot.Primary; weapon_slot_index < WeaponSlot.MAX; weapon_slot_index++)
            {
                if(weapon_slot_index == WeaponSlot.DisguiseKit || weapon_slot_index == WeaponSlot.InvisWatch)
                    continue;

                local weapon_cookie = FormatWeaponCookie(player.GetPlayerClass(), weapon_slot_index);
                local weapon_id = Cookies.Get(::last_player_that_spawned_bots, weapon_cookie)
                if(weapon_id == "null")
                    continue;

                local weapon_table = WEAPONS[weapon_id];
                local item_id = (("item_id_override" in weapon_table) ? weapon_table.item_id_override : weapon_table.item_id)

                local weapon = CreateByClassname(ConvertWeaponClassname(player.GetPlayerClass(), weapon_table.classname))

                SetPropInt(weapon, NETPROP_ITEMDEFINDEX, item_id)
                SetPropBool(weapon, NETPROP_INITIALIZED, true)
                SetPropBool(weapon, NETPROP_VALIDATED_ATTACHED, true)
                weapon.SetTeam(player.GetTeam())
                if("extra_code" in WEAPONS[weapon_id])
                {
                    WEAPONS[weapon_id].extra_code(weapon);
                }

                if(GetWeaponIndexFlags(weapon_id) & FLAG_WARPAINT_AND_UNUSUAL)
                {
                    local desired_skin = Cookies.Get(::last_player_that_spawned_bots, "skin");
                    if(desired_skin != null && desired_skin != "null")
                    {
                        local skin_data = SKINS[desired_skin];
                        switch(skin_data.type)
                        {
                            case SkinType.LegacySkin:
                            {
                                if(item_id in skin_data.replacements)
                                {
                                    SetPropInt(weapon, NETPROP_ITEMDEFINDEX, skin_data.replacements[item_id]);
                                    DebugPrint("replaceing item id with " + skin_data.replacements[item_id] + " for skin id " + desired_skin)
                                }
                                break;
                            }
                            case SkinType.Warpaint:
                            {
                                weapon.AddAttribute("paintkit_proto_def_index", casti2f(skin_data.index.tointeger()), -1);
                                break;
                            }
                        }

                        weapon.AddAttribute("set_item_texture_wear", Cookies.Get(::last_player_that_spawned_bots, "wear"), -1);
                        weapon.AddAttribute("custom_paintkit_seed_lo", casti2f(Cookies.Get(::last_player_that_spawned_bots, "seed_lo").tointeger()), -1);
                        weapon.AddAttribute("custom_paintkit_seed_hi", casti2f(Cookies.Get(::last_player_that_spawned_bots, "seed_hi").tointeger()), -1);
                    }

                    local desired_unusual = Cookies.Get(::last_player_that_spawned_bots, "unusual");
                    if(desired_unusual && (desired_unusual != WEAPON_UNUSUAL_ENERGYORB || GetWeaponIndexFlags(weapon_id) & FLAG_ACCEPTS_ENERGYORB))
                        weapon.AddAttribute("attach particle effect", desired_unusual, -1);
                }

                if(Cookies.Get(::last_player_that_spawned_bots, "spells"))
                {
                    weapon.AddAttribute("SPELL: Halloween pumpkin explosions", 1, -1);

                    if(GetPlayerClass() == TF_CLASS_PYRO && weapon.GetSlot() == WeaponSlot.Primary)
                        weapon.AddAttribute("SPELL: Halloween green flames", 1, -1);
                }

                if(Cookies.Get(::last_player_that_spawned_bots, "festivizer"))
                {
                    weapon.AddAttribute("is_festivized", 1, -1);
                }

                if(Cookies.Get(::last_player_that_spawned_bots, "statclock"))
                {
                    weapon.AddAttribute("kill eater", casti2f(0), -1);
                }

                local ks_tier = Cookies.Get(::last_player_that_spawned_bots, "killstreak");
                if(ks_tier >= 1)
                {
                    weapon.AddAttribute("killstreak tier", ks_tier, -1);

                    if(ks_tier >= 2)
                        weapon.AddAttribute("killstreak idleeffect", Cookies.Get(::last_player_that_spawned_bots, "killstreak_sheen"), -1);

                    if(ks_tier >= 3)
                        weapon.AddAttribute("killstreak effect", Cookies.Get(::last_player_that_spawned_bots, "killstreak_particle"), -1);
                }
                weapon.DispatchSpawn()

                // remove existing weapon in same slot
                for (local i = 0; i < MAX_WEAPONS; i++)
                {
                    local heldWeapon = GetPropEntityArray(player, "m_hMyWeapons", i)
                    if (heldWeapon == null)
                        continue
                    if (heldWeapon.GetSlot() != WEAPONS[weapon_id].slot)
                        continue
                    heldWeapon.Destroy()
                    SetPropEntityArray(player, "m_hMyWeapons", null, i)
                }

                player.Weapon_Equip(weapon)

                weapon.ReapplyProvision()
            }
        }

        player.SetHealth(player.GetMaxHealth())

        //set killstreaks
        for(local i = 0; i < 2; i++)
        {
            SetPropIntArray(player, "m_Shared.m_nStreaks", Cookies.Get(::last_player_that_spawned_bots, "spawned_bot_killstreak"), i);
        }

        //give us cosmetics
        //do we have a prefab to equip?
        local namespace = "cosmetic_prefab_" + TF_CLASSES[player.GetPlayerClass() - 1];
        local current_prefab = Cookies.Get(::last_player_that_spawned_bots, "spawned_bot_copy_loadout_cosmetics");
        if(current_prefab == 0)
            return;

        //give cosmetics in the prefab
        for (local cosmetic_id = 0; cosmetic_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_id++)
        {
            local cookie = "prefab_" + (current_prefab - 1) + "_cosmetic_" + cosmetic_id;
            local hat_id = Cookies.GetNamespace(namespace, ::last_player_that_spawned_bots, cookie);
            if(hat_id == -1)
                continue;

            //set the style, this needs to be passed in before the hat spawns
            local style_id = Cookies.GetNamespace(namespace, ::last_player_that_spawned_bots, cookie + "_style");

            //give the hat
            local hat_entity = player.GivePlayerCosmetic(hat_id, null, style_id);

            //set the unusual
            local unusual_id = Cookies.GetNamespace(namespace, ::last_player_that_spawned_bots, cookie + "_unusual");
            if(unusual_id != -1)
            {
                hat_entity.AddAttribute("attach particle effect", unusual_id, -1);
            }

            //paint it
            local paint_id = Cookies.GetNamespace(namespace, ::last_player_that_spawned_bots, cookie + "_paint");
            if(paint_id != 0)
            {
                local team_paint = (PAINTS[paint_id].color.len() == 2);
                local paint_data_index = (team_paint ? (GetTeam() == TF_TEAM_RED ? 0 : 1) : 0);
                hat_entity.AddAttribute("set item tint RGB", PAINTS[paint_id].color[paint_data_index].tointeger(), -1);
            }
        }
    })
})

AddListener("tick_frame", 1, function()
{
    if (!IsValidPlayer(::last_player_that_spawned_bots))
        return;

    foreach(player in bots)
    {
        player.Weapon_Switch(player.GetWeaponBySlot(Cookies.Get(::last_player_that_spawned_bots, "spawned_bot_desired_slot")))
        player.SetMission(0, true) //stops from bots switching weapons
    }
});

DefineMenu(class extends Menu{
    id = "bot_controls"
    menu_name = "bot_range"
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
                if(last_spawned_bot_time + 5 > Time())
                    return;

                ::last_spawned_bot_time <- Time();
                ::last_player_that_spawned_bots = player;

                //keep this long because spawning can take time
                SuppressMessages(1.5);
                RunWithDelay(0.1, function(){
                    RemoveSpawnedBots()
                })
                RunWithDelay(0.2, function()
                {
                    local entity = null
                    while (entity = Entities.FindByClassname(entity, "bot_generator"))
                    {
                        entity.KeyValueFromString("team", index ? "blue" : "red")
                    }
                    //bots spawned in training always have just their class name
                    SuppressMessages(3.0)
                    EntFire("botspawn", "spawnbot")
                    Convars.SetValue("tf_bot_count", 9)
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
                    Convars.SetValue("tf_forced_holiday", kHoliday_FullMoon);
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
                SuppressMessages(0.2);
                RunWithDelay(0.1, function(){
                    RemoveSpawnedBots()
                })
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
            titles = ["Bots copy weapon loadout: Off" "Bots copy weapon loadout: On"];

            function OnMenuOpened(player)
            {
                index = Cookies.Get(player, "spawned_bot_copy_loadout_weapons")
            }

            function GenerateDesc(player)
            {
                return "Whether bots spawned by you will\nequip your override weapons.\nCurrent: " + (Cookies.Get(player, "spawned_bot_copy_loadout_weapons") ? "On" : "Off");
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "spawned_bot_copy_loadout_weapons", index);
                if(index)
                    player.SendChat(CHAT_PREFIX + "Bots spawned by you will now equip your override weapons.");
                else
                    player.SendChat(CHAT_PREFIX + "Bots spawned by you will no longer now equip your override weapons.");
            }
        },
        class extends MenuItem{
            titles = [];

            function OnMenuOpened(player)
            {
                local pre = "Desired bot weapon slot: "
                titles = []
                foreach (loadout_name in LOADOUT_SLOT_NAMES)
                {
                    titles.append(pre + UpperFirst(loadout_name))
                }
                index = Cookies.Get(player, "spawned_bot_desired_slot")
            }

            function GenerateDesc(player)
            {
                return "What slot of weapon bots will be forced to.\nCurrent: " + UpperFirst(LOADOUT_SLOT_NAMES[Cookies.Get(player, "spawned_bot_desired_slot")]);
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "spawned_bot_desired_slot", index);
                player.SendChat(CHAT_PREFIX + "Bots spawned by you will now always equip their " + LOADOUT_SLOT_NAMES[Cookies.Get(player, "spawned_bot_desired_slot")] + " weapon.");
            }
        },
        class extends MenuItem{
            titles = ["Bot Killstreak: 0" "Bot Killstreak: 5" "Bot Killstreak: 10" "Bot Killstreak: 15" "Bot Killstreak: 20"];

            function OnMenuOpened(player)
            {
                index = Cookies.Get(player, "spawned_bot_killstreak")/5
            }

            function GenerateDesc(player)
            {
                return "Set the killstreak count of bots spawned by you.";
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "spawned_bot_killstreak", index*5)
                player.SendChat(CHAT_PREFIX + "Bots spawned by you will now have a killstreak of " + Cookies.Get(player, "spawned_bot_killstreak") + ".");
            }
        },
        class extends MenuItem{
            titles = [];

            function OnMenuOpened(player)
            {
                local pre = "Bots copy cosmetic loadout: "
                titles = [pre + "None"]
                for (local i = 0; i < COSMETIC_PREFAB_COUNT; i++)
                {
                    titles.append(pre + ordinal(i+1) + " loadout")
                }
                index = Cookies.Get(player, "spawned_bot_copy_loadout_cosmetics")
            }

            function GenerateDesc(player)
            {
                local value = Cookies.Get(player, "spawned_bot_copy_loadout_cosmetics");
                local value_display = "";
                if(value)
                    value_display = ordinal(value) + " loadout";
                else
                    value_display = "None";
                return "Which one of your cosmetic loadouts\nbots will copy when spawned by you.\nCurrent: " + value_display;
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "spawned_bot_copy_loadout_cosmetics", index);
                local value_display = "";
                if(index)
                    value_display = "Bots spawned by you will now always equip your " + ordinal(index) + " cosmetic loadout.";
                else
                    value_display = "Bots spawned by you will now equip none of your cosmetic loadouts.";
                player.SendChat(CHAT_PREFIX + value_display);
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