::PAINTS <- [
    { name = "None" }
    { name = "Indubitably Green", color = ["7511618"] },
    { name = "Zepheniah's Greed", color = ["4345659"] },
    { name = "Noble Hatter's Violet", color = ["5322826"] },
    { name = "Color No. 216-190-216", color = ["14204632"] },
    { name = "Deep Commitment to Purple", color = ["8208497"] },
    { name = "Mann Co. Orange", color = ["13595446"] },
    { name = "Muskelmannbraun", color = ["10843461"] },
    { name = "Peculiarly Drab Tincture", color = ["12955537"] },
    { name = "Radigan Conagher Brown", color = ["6901050"] },
    { name = "Ye Olde Rustic Color", color = ["8154199"] },
    { name = "Australium Gold", color = ["15185211"] },
    { name = "Aged Moustache Grey", color = ["8289918"] },
    { name = "An Extraordinary Abundance of Tinge", color = ["15132390"] },
    { name = "A Distinctive Lack of Hue", color = ["1315860"] },
    { name = "Pink as Hell", color = ["16738740"] },
    { name = "Color Similar to Slate", color = ["3100495"] },
    { name = "Drably Olive", color = ["8421376"] },
    { name = "The Bitter Taste of Defeat and Lime", color = ["3329330"] },
    { name = "The Color of a Gentlemann's Business Pants", color = ["15787660"] },
    { name = "Dark Salmon Injustice", color = ["15308410"] },
    { name = "A Mann's Mint", color = ["12377523"] },
    { name = "After Eight", color = ["2960676"] },
    { name = "Team Spirit", color = ["12073019", "5801378"] },
    { name = "Operator's Overalls", color = ["4732984", "3686984"] },
    { name = "Waterlogged Lab Coat", color = ["11049612", "8626083"] },
    { name = "Balaclavas Are Forever", color = ["3874595", "1581885"] },
    { name = "An Air of Debonair", color = ["6637376", "2636109"] },
    { name = "The Value of Teamwork", color = ["8400928", "2452877"] },
    { name = "Cream Spirit", color = ["12807213", "12091445"] },
]

::PAINTS_HALLOWEEN <- [
    "Die Job"
    "Chromatic Corruption"
    "Putrescent Pigmentation"
    "Spectral Spectrum"
    "Sinister Staining"
]

Cookies.AddCookie("ignore_econ_cosmetics", 0);

::CTFPlayer.EquipDesiredCosmetics <- function()
{
    //get rid of our override wearables
    if(!("override_wearables" in GetScriptScope()))
        SetVar("override_wearables", array(0, null))

    for(local i = 0; i < GetVar("override_wearables").len(); i++)
    {
        if(GetVar("override_wearables")[i].IsValid())
        {
            GetVar("override_wearables")[i].Kill()
        }
    }
    GetVar("override_wearables").clear()

    //do we have a prefab to equip?
    local namespace = "cosmetic_prefab_" + TF_CLASSES[GetPlayerClass() - 1];
    local current_prefab = Cookies.GetNamespace(namespace, this, "current");
    if(current_prefab == -1)
        return;

    //first, kill any valid wearables
    local wearables_to_kill = [];
    for(local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        if (wearable.GetClassname() != "tf_wearable")
            continue;

        if(GetPropInt(wearable, NETPROP_ITEMDEFINDEX) in COSMETICS)
            wearables_to_kill.append(wearable)
    }
    foreach(wearable in wearables_to_kill)
    {
        wearable.Destroy();
    }

    //second, give cosmetics in the prefab
    for (local cosmetic_id = 0; cosmetic_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_id++)
    {
        local cookie = "prefab_" + current_prefab + "_cosmetic_" + cosmetic_id;
        local hat_id = Cookies.GetNamespace(namespace, this, cookie);
        if(hat_id == -1)
            continue;

        //set the style, this needs to be passed in before the hat spawns
        local style_id = Cookies.GetNamespace(namespace, this, cookie + "_style");

        //give the hat
        local hat_entity = GivePlayerCosmetic(hat_id, null, style_id);

        //set the unusual
        local unusual_id = Cookies.GetNamespace(namespace, this, cookie + "_unusual");
        if(unusual_id != -1)
        {
            hat_entity.AddAttribute("attach particle effect", unusual_id, -1);
        }

        //paint it
        local paint_id = Cookies.GetNamespace(namespace, this, cookie + "_paint");
        if(paint_id != 0)
        {
            local team_paint = (PAINTS[paint_id].color.len() == 2);
            local paint_data_index = (team_paint ? (GetTeam() == TF_TEAM_RED ? 0 : 1) : 0);
            hat_entity.AddAttribute("set item tint RGB", PAINTS[paint_id].color[paint_data_index].tointeger(), -1);
        }

        GetVar("override_wearables").append(hat_entity);
    }
}

foreach(name in TF_CLASSES)
{
    local namespace = "cosmetic_prefab_" + name;
    Cookies.AddCookieNamespace(namespace, "current", -1);
    for (local prefab_id = 0; prefab_id < COSMETIC_PREFAB_COUNT; prefab_id++)
    {
        for (local cosmetic_id = 0; cosmetic_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_id++)
        {
            local cookie = "prefab_" + prefab_id + "_cosmetic_" + cosmetic_id;
            Cookies.AddCookieNamespace(namespace, cookie, -1);              //hat
            Cookies.AddCookieNamespace(namespace, cookie + "_unusual", -1); //hat unusual
            Cookies.AddCookieNamespace(namespace, cookie + "_paint", 0);   //hat paint
            Cookies.AddCookieNamespace(namespace, cookie + "_style", 0);    //hat style
        }
    }
}

function GenerateCosmeticMenu()
{
    local menu = class extends Menu{id = "cosmetics"; menu_name = "cosmetic"; items = array(9, null)};
    foreach(class_index, name in TF_CLASSES)
    {
        menu.items[TF_CLASS_REMAP[class_index + 1]] = class extends MenuItem
        {
            class_name = name;
            titles = [UpperFirst(name)];

            function GenerateDesc(player)
            {
                local current_prefab = Cookies.GetNamespace("cosmetic_prefab_" + class_name, player, "current");
                local current_prefab_text = (current_prefab != -1 ? "#" + (current_prefab + 1) : "None");
                return "Equip or Modify a cosmetic prefabs for your " + UpperFirst(class_name) + ".\nActive Prefab: " + current_prefab_text;
            }

            function OnSelected(player)
            {
                player.GoToMenu("cosmetics_" + class_name)
            }
        }
    }
    DefineMenu(menu);
}
GenerateCosmeticMenu();

function GenerateCosmeticPrefabSelectMenu()
{
    foreach(class_id, name in TF_CLASSES)
    {
        local menu = class extends Menu{id = "cosmetics_" + name; menu_name = name; items = []};
        menu.items.append(class extends MenuItem
        {
            class_index = class_id;
            class_name = name;
            titles = ["Unequip Prefabs"];

            function GenerateDesc(player)
            {
                return "Make it so that no cosmetic\nprefabs are equipped for " + UpperFirst(class_name) + ".";
            }

            function OnSelected(player)
            {
                Cookies.SetNamespace("cosmetic_prefab_" + class_name, player, "current", -1);
                player.SendChat(CHAT_PREFIX + "Removed the " + UpperFirst(class_name) + "'s cosmetic prefab override.");
                SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
            }
        })
        for(local prefab_id = 0; prefab_id < COSMETIC_PREFAB_COUNT; prefab_id++)
        {
            menu.items.append(class extends MenuItem
            {
                prefab_index = prefab_id;
                class_name = name;
                titles = ["Prefab #" + (prefab_id + 1)];

                function GenerateDesc(player)
                {
                    return "Equip or Modify the cosmetics inside of Prefab #" + (prefab_index + 1) + ".";
                }

                function OnSelected(player)
                {
                    player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index);
                }
            })
        }
        DefineMenu(menu);
    }
}
GenerateCosmeticPrefabSelectMenu();

function GenerateCosmeticPrefabMenu()
{
    foreach(class_id, name in TF_CLASSES)
    {
        for(local prefab_id = 0; prefab_id < COSMETIC_PREFAB_COUNT; prefab_id++)
        {
            local menu = class extends Menu{id = "cosmetics_" + name + "_" + prefab_id; menu_name = "prefab" + (prefab_id + 1); items = []};
            menu.items.append(class extends MenuItem
            {
                prefab_index = prefab_id;
                class_name = name;
                titles = ["Equip Prefab"];

                function GenerateDesc(player)
                {
                    return "Equip this prefab and spawn\nwith the cosmetics inside it.";
                }

                function OnSelected(player)
                {
                    Cookies.SetNamespace("cosmetic_prefab_" + class_name, player, "current", prefab_index);
                    player.SendChat(CHAT_PREFIX + "Equipped Prefab #" + (prefab_index + 1) + " for the " + UpperFirst(class_name));
                    SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
                }
            })
            for(local cosmetic_slot_id = 0; cosmetic_slot_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_slot_id++)
            {
                menu.items.append(class extends MenuItem
                {
                    cosmetic_slot_index = cosmetic_slot_id;
                    medal_slot = cosmetic_slot_id == (COSMESTICS_IN_PREFAB_COUNT - 1);
                    prefab_index = prefab_id;
                    class_name = name;
                    titles = [""];

                    function OnMenuOpened(player)
                    {
                        //get the cosmetic name
                        local namespace = "cosmetic_prefab_" + class_name;
                        local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index;
                        local hat_id = Cookies.GetNamespace(namespace, player, cookie);
                        local hat_name = "None";

                        if(hat_id != -1 && hat_id in COSMETICS)
                        {
                            hat_name = COSMETICS[hat_id].name;
                        }

                        if(medal_slot)
                            titles[0] = "Medal: " + hat_name;
                        else
                            titles[0] = "Cosmetic #" + (cosmetic_slot_index + 1).tostring() + ": " + hat_name;
                    }

                    function GenerateDesc(player)
                    {
                        if(medal_slot)
                            return "Modify the medal inside it's slot."
                        else
                            return "Modify the cosmetic inside of slot #" + (cosmetic_slot_index + 1);
                    }

                    function OnSelected(player)
                    {
                        if(medal_slot)
                            player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index + "_medal");
                        else
                            player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index + "_" + cosmetic_slot_index);
                    }
                })
            }
            DefineMenu(menu);
        }
    }
}
GenerateCosmeticPrefabMenu();

function GenerateCosmeticEditMenu()
{
    foreach(class_id, name in TF_CLASSES)
    {
        for(local prefab_id = 0; prefab_id < COSMETIC_PREFAB_COUNT; prefab_id++)
        {
            for(local cosmetic_slot_id = 0; cosmetic_slot_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_slot_id++)
            {
                local menu = class extends Menu
                {
                    id = "cosmetics_" + name + "_" + prefab_id + "_" + cosmetic_slot_id;
                    menu_name = "slot" + (cosmetic_slot_id + 1);

                    cosmetic_slot_index = cosmetic_slot_id;
                    prefab_index = prefab_id;
                    class_name = name;

                    function constructor()
                    {
                        GenerateCosmeticEditMenuItems(this, cosmetic_slot_index, prefab_index, class_name)
                    }
                };
                DefineMenu(menu);
            }

            local menu = class extends Menu
            {
                id = "cosmetics_" + name + "_" + prefab_id + "_medal";
                menu_name = "medal";

                prefab_index = prefab_id;
                class_name = name;

                function constructor()
                {
                    GenerateCosmeticEditMenuItems(this, COSMESTICS_IN_PREFAB_COUNT - 1, prefab_index, class_name)
                }
            };
            DefineMenu(menu);
        }
    }
}
GenerateCosmeticEditMenu();

::GenerateCosmeticEditMenuItems <- function(menu, cosmetic_slot_index, prefab_index, class_name)
{
    menu.items = [];
    //edit hat
    menu.items.append(class extends MenuItem
    {
        titles = [""];

        function OnMenuOpened(player)
        {
            //get the cosmetic name
            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index;
            local hat_id = Cookies.GetNamespace(namespace, player, cookie);
            local hat_name = "None";
            if(hat_id != -1 && hat_id in COSMETICS)
            {
                hat_name = COSMETICS[hat_id].name;
            }

            if(cosmetic_slot_index == COSMESTICS_IN_PREFAB_COUNT - 1)
                titles[0] = "Medal: " + hat_name;
            else
                titles[0] = "Cosmetic: " + hat_name;
        }

        function GenerateDesc(player)
        {
            if(cosmetic_slot_index == COSMESTICS_IN_PREFAB_COUNT - 1)
                return "Change or Remove the medal.";
            else
                return "Change or Remove the cosmeitc." + "\nWhile in this menu, type in chat to perform a search.";
        }

        function OnSelected(player)
        {
            if(cosmetic_slot_index == COSMESTICS_IN_PREFAB_COUNT - 1)
            {
                player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index + "_medaltype");
                return;
            }

            player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index + "_" + cosmetic_slot_index + "_editcosmetic");

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index;
            local hat_id = Cookies.GetNamespace(namespace, player, cookie);
            if(hat_id != -1)
            {
                foreach(i, cosmetic in CosmeticMenuItems[class_name])
                {
                    //skip the remove cosmetic item
                    if(i == 0)
                        continue;

                    if(cosmetic.cosmetic_index == hat_id)
                    {
                        player.GetVar("menu").selected_index = i;
                        break;
                    }
                }
            }
        }
    })
    //edit unusual
    menu.items.append(class extends MenuItem
    {
        titles = [""];
        invalid = false;

        function OnMenuOpened(player)
        {
            if(cosmetic_slot_index == COSMESTICS_IN_PREFAB_COUNT - 1)
            {
                //hidden = true;
                invalid = true;
                titles[0] = "Unusual: N/A";
                return;
            }

            //get the cosmetic name
            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_unusual";
            local unusual_id = Cookies.GetNamespace(namespace, player, cookie);
            local unusual_name = "None";
            if(unusual_id != -1 && unusual_id in UNUSUALS)
            {
                unusual_name = UNUSUALS[unusual_id].name;
            }

            titles[0] = "Unusual: " + unusual_name;
        }

        function GenerateDesc(player)
        {
            if(invalid)
                return "This cosmetic cannot have an unusual.";
            else
                return "Change or Remove the unusual." + "\nWhile in this menu, type in chat to perform a search.";
        }

        function OnSelected(player)
        {
            if(invalid)
                return;

            player.GoToMenu("cosmetics_" + class_name + "_" + prefab_index + "_" + cosmetic_slot_index + "_editunusual");

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_unusual";
            local unusual_id = Cookies.GetNamespace(namespace, player, cookie);
            if(unusual_id != -1)
            {
                foreach(i, unusual in CosmeticUnusualMenuItems)
                {
                    //skip the remove unusual item
                    if(i == 0)
                        continue;

                    if(unusual.unusual_index == unusual_id)
                    {
                        player.GetVar("menu").selected_index = i;
                        break;
                    }
                }
            }
        }
    })
    //edit paint
    //make this a left/right menu because i dont care
    menu.items.append(class extends MenuItem
    {
        titles = [""];
        invalid = false;

        function OnMenuOpened(player)
        {
            //is the cosmetic paintable
            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index;
            local hat_id = Cookies.GetNamespace(namespace, player, cookie);
            if(hat_id == -1 || !(hat_id in COSMETICS) || !("paint" in COSMETICS[hat_id]) || !COSMETICS[hat_id].paint)
            {
                invalid = true;
                titles[0] = "Paint: N/A"
                //hidden = true;
            }
            else
            {
                invalid = false;
                //hidden = false;
                titles = [];
                foreach(paint in PAINTS)
                    titles.append("Paint: " + paint.name);
            }

            index = Cookies.GetNamespace(namespace, player, cookie + "_paint");
        }

        function GenerateDesc(player)
        {
            if(invalid)
                return "This cosmetic cannot be painted.";

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_paint";
            return "Set the paint of the current cosmetic to:\n" + PAINTS[index].name + ".\nCurrent: " + PAINTS[Cookies.GetNamespace(namespace, player, cookie)].name;
        }

        function OnSelected(player)
        {
            if(invalid)
                return;

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_paint";
            Cookies.SetNamespace(namespace, player, cookie, index);
            player.SendChat(CHAT_PREFIX + "Set the paint of the current cosmetic to: " + PAINTS[index].name + ".");
            SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
        }
    })
    //edit style
    //make this a left/right menu because of how few styles exist for cosmetics
    menu.items.append(class extends MenuItem
    {
        titles = [""];
        invalid = false;

        function OnMenuOpened(player)
        {
            //get the cosmetic styles
            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index;
            local hat_id = Cookies.GetNamespace(namespace, player, cookie);
            if(hat_id == -1 || !(hat_id in COSMETICS) || !("styles" in COSMETICS[hat_id]))
            {
                invalid = true;
                titles[0] = "Style: N/A";
                //hidden = true;
            }
            else
            {
                invalid = false;
                //hidden = false;
                titles = [];
                foreach(style_name in COSMETICS[hat_id]["styles"])
                    titles.append("Style: " + style_name);
            }

            index = Cookies.GetNamespace(namespace, player, cookie + "_style");
        }

        function GenerateDesc(player)
        {
            if(invalid)
                return "This cosmetic cannot be styled.";

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_style";
            return "Set the style of the current cosmetic to: " + titles[index].slice(7) + ".\nCurrent: " + titles[Cookies.GetNamespace(namespace, player, cookie)].slice(7);
        }

        function OnSelected(player)
        {
            if(invalid)
                return;

            local namespace = "cosmetic_prefab_" + class_name;
            local cookie = "prefab_" + prefab_index + "_cosmetic_" + cosmetic_slot_index + "_style";
            Cookies.SetNamespace(namespace, player, cookie, index);
            player.SendChat(CHAT_PREFIX + "Set the style of the current cosmetic to: " + titles[index].slice(7) + ".");
            SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
        }
    })
}

::CosmeticMenuItems <- {}

foreach(tf_class_name in TF_CLASSES)
{
    CosmeticMenuItems[tf_class_name] <- [];
}

::CommunityMedalMenuItems <- []
::TournamentMedalMenuItems <- []

local cosmetic_array = [];
foreach(cosmetic_id, cosmetic_data in COSMETICS)
{
    //regular cosmetics go here, into each class' array
    if(cosmetic_data.type == CosmeticType.Normal)
    {
        local menu_item = class extends MenuItem
        {
            cosmetic_index = cosmetic_id;
            titles = [cosmetic_data.name];

            function GenerateDesc(player)
            {
                local menu = player.GetVar("menu");
                //Equip the Pyrovision Goggles to Slot 1 for Demoman's 3rd Prefab.
                return "Equip the\n" + titles[0] + "\nto Slot " + (menu.cosmetic_slot_index + 1) + " for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab."
            }

            function OnSelected(player)
            {
                local menu = player.GetVar("menu");
                local namespace = "cosmetic_prefab_" + menu.class_name;
                local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + menu.cosmetic_slot_index;
                Cookies.SetNamespace(namespace, player, cookie, cosmetic_index);
                player.SendChat(CHAT_PREFIX + "Equiped the " + titles[0] + " to Slot " + (menu.cosmetic_slot_index + 1) + " for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
                SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
            }
        }

        if(!("classes" in cosmetic_data))
        {
            foreach(tf_class_name in TF_CLASSES)
            {
                CosmeticMenuItems[tf_class_name].append(menu_item);
            }
        }
        else
        {
            foreach(tf_class_name in cosmetic_data.classes)
            {
                CosmeticMenuItems[TF_CLASSES[tf_class_name - 1]].append(menu_item);
            }
        }
    }
    //touney and community medals
    else
    {
        local menuitem = class extends MenuItem
        {
            cosmetic_index = cosmetic_id;
            titles = [cosmetic_data.name];

            function GenerateDesc(player)
            {
                local menu = player.GetVar("menu");
                //Equip the x into the medal slot for Demoman's 3rd Prefab.
                return "Equip the\n" + titles[0] + "\ninto the medal slot for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab."
            }

            function OnSelected(player)
            {
                local menu = player.GetVar("menu");
                local namespace = "cosmetic_prefab_" + menu.class_name;
                local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + (COSMESTICS_IN_PREFAB_COUNT - 1);
                Cookies.SetNamespace(namespace, player, cookie, cosmetic_index);
                player.SendChat(CHAT_PREFIX + "Equiped the " + titles[0] + " into the medal slot for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
                SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
            }
        }

        if(cosmetic_data.type == CosmeticType.CommunityMedal)
            CommunityMedalMenuItems.append(menuitem);
        else if(cosmetic_data.type == CosmeticType.TournamentMedal)
            TournamentMedalMenuItems.append(menuitem);
    }
}
//sort it
foreach(tf_class_name in TF_CLASSES) {
    CosmeticMenuItems[tf_class_name].sort(function(a,b){return a.cosmetic_index <=> b.cosmetic_index;})
}
CommunityMedalMenuItems.sort(function(a,b){return a.cosmetic_index <=> b.cosmetic_index;})
TournamentMedalMenuItems.sort(function(a,b){return a.cosmetic_index <=> b.cosmetic_index;})

//add the remove option
foreach(tf_class_name in TF_CLASSES) {
    CosmeticMenuItems[tf_class_name].insert(0, class extends MenuItem
    {
        titles = ["Remove Cosmetic"];

        function GenerateDesc(player)
        {
            local menu = player.GetVar("menu");
            return "Remove the Cosmetic in Slot " + (menu.cosmetic_slot_index + 1) + " for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.";
        }

        function OnSelected(player)
        {
            local menu = player.GetVar("menu");
            local namespace = "cosmetic_prefab_" + menu.class_name;
            local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + menu.cosmetic_slot_index;
            Cookies.SetNamespace(namespace, player, cookie, -1);
            Cookies.SetNamespace(namespace, player, cookie + "_paint", 0);
            Cookies.SetNamespace(namespace, player, cookie + "_style", 0);
            player.SendChat(CHAT_PREFIX + "Removed the Cosmetic in Slot " + (menu.cosmetic_slot_index + 1) + " for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
            SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
        }
    })
}
CommunityMedalMenuItems.insert(0, class extends MenuItem
{
    titles = ["Remove Medal"];

    function GenerateDesc(player)
    {
        local menu = player.GetVar("menu");
        return "Remove the medal in it's slot for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.";
    }

    function OnSelected(player)
    {
        local menu = player.GetVar("menu");
        local namespace = "cosmetic_prefab_" + menu.class_name;
        local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + (COSMESTICS_IN_PREFAB_COUNT - 1);
        Cookies.SetNamespace(namespace, player, cookie, -1);
        Cookies.SetNamespace(namespace, player, cookie + "_paint", 0);
        Cookies.SetNamespace(namespace, player, cookie + "_style", 0);
        player.SendChat(CHAT_PREFIX + "Removed the medal in it's slot for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
        SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
    }
})
TournamentMedalMenuItems.insert(0, class extends MenuItem
{
    titles = ["Remove Medal"];

    function GenerateDesc(player)
    {
        local menu = player.GetVar("menu");
        return "Remove the medal in it's slot for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.";
    }

    function OnSelected(player)
    {
        local menu = player.GetVar("menu");
        local namespace = "cosmetic_prefab_" + menu.class_name;
        local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + (COSMESTICS_IN_PREFAB_COUNT - 1);
        Cookies.SetNamespace(namespace, player, cookie, -1);
        Cookies.SetNamespace(namespace, player, cookie + "_paint", 0);
        Cookies.SetNamespace(namespace, player, cookie + "_style", 0);
        player.SendChat(CHAT_PREFIX + "Removed the medal in it's slot for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
        SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
    }
})

::CosmeticUnusualMenuItems <- []

foreach(unusual_id, unusual_data in UNUSUALS)
{
    //only add this unusual if its a hat unusual
    if(unusual_data.type == UnusualType.Cosmetic)
    {
        CosmeticUnusualMenuItems.append(class extends MenuItem
        {
            unusual_index = unusual_id;
            titles = [unusual_data.name];

            function GenerateDesc(player)
            {
                local menu = player.GetVar("menu");
                //Equip the Pyrovision Goggles to Slot 1's Unusual for Demoman's 3rd Prefab.
                return "Equip the\n" + titles[0] + "\nto Slot " + (menu.cosmetic_slot_index + 1) + "'s Unusual for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.";
            }

            function OnSelected(player)
            {
                local menu = player.GetVar("menu");
                local namespace = "cosmetic_prefab_" + menu.class_name;
                local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + menu.cosmetic_slot_index + "_unusual";
                Cookies.SetNamespace(namespace, player, cookie, unusual_index);
                player.SendChat(CHAT_PREFIX + "Equiped the " + titles[0] + " to Slot " + (menu.cosmetic_slot_index + 1) + "'s Unusual for " + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
                SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
            }
        })
    }
}

CosmeticUnusualMenuItems.sort(function(a,b){return a.unusual_index <=> b.unusual_index;})

CosmeticUnusualMenuItems.insert(0, class extends MenuItem
{
    titles = ["Remove Unusual"];

    function GenerateDesc(player)
    {
        local menu = player.GetVar("menu");
        return "Remove the Unusual in Slot " + (menu.cosmetic_slot_index + 1) + " for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.";
    }

    function OnSelected(player)
    {
        local menu = player.GetVar("menu");
        local namespace = "cosmetic_prefab_" + menu.class_name;
        local cookie = "prefab_" + menu.prefab_index + "_cosmetic_" + menu.cosmetic_slot_index + "_unusual";
        Cookies.SetNamespace(namespace, player, cookie, -1);
        player.SendChat(CHAT_PREFIX + "Removed the Unusual in Slot " + (menu.cosmetic_slot_index + 1) + " for\n" + UpperFirst(menu.class_name) + "'s " + ordinal(menu.prefab_index + 1) + " Prefab.");
        SendGlobalGameEvent("post_inventory_application", {userid = player.GetUserID()});
    }
})

foreach(class_id, name in TF_CLASSES)
{
    for(local prefab_id = 0; prefab_id < COSMETIC_PREFAB_COUNT; prefab_id++)
    {
        for(local cosmetic_slot_id = 0; cosmetic_slot_id < COSMESTICS_IN_PREFAB_COUNT; cosmetic_slot_id++)
        {
            DefineMenu(class extends Menu
            {
                id = "cosmetics_" + name + "_" + prefab_id + "_" + cosmetic_slot_id + "_editcosmetic"
                menu_name = "cosmetic"

                class_name = name
                prefab_index = prefab_id
                cosmetic_slot_index = cosmetic_slot_id

                function constructor()
                {
                    items = clone(CosmeticMenuItems[class_name])
                }
            })

            DefineMenu(class extends Menu
            {
                id = "cosmetics_" + name + "_" + prefab_id + "_" + cosmetic_slot_id + "_editunusual"
                menu_name = "unusual"

                class_name = name
                prefab_index = prefab_id
                cosmetic_slot_index = cosmetic_slot_id

                function constructor()
                {
                    items = clone(CosmeticUnusualMenuItems)
                }
            })
        }

        DefineMenu(class extends Menu
        {
            id = "cosmetics_" + name + "_" + prefab_id + "_medaltype"
            menu_name = "type"

            class_name = name
            prefab_index = prefab_id

            function constructor()
            {
                items = [
                    class extends MenuItem{
                        titles = ["Community Medal"]

                        function OnSelected(player)
                        {
                            local menu = player.GetVar("menu");
                            player.GoToMenu("cosmetics_" + menu.class_name + "_" + menu.prefab_index + "_medal_community");
                        }

                        function GenerateDesc(player)
                        {
                            return "Choose from the list of Community Medals.\nWhile in this menu, type in chat to perform a search.";
                        }
                    }
                    class extends MenuItem{
                        titles = ["Tournament Medal"]

                        function OnSelected(player)
                        {
                            local menu = player.GetVar("menu");
                            player.GoToMenu("cosmetics_" + menu.class_name + "_" + menu.prefab_index + "_medal_tournament");
                        }

                        function GenerateDesc(player)
                        {
                            return "Choose from the list of Tournament Medals.\nWhile in this menu, type in chat to perform a search.";
                        }
                    }
                ]
            }
        })

        DefineMenu(class extends Menu
        {
            id = "cosmetics_" + name + "_" + prefab_id + "_medal_community"
            menu_name = "community"

            class_name = name
            prefab_index = prefab_id

            function constructor()
            {
                items = clone(CommunityMedalMenuItems)
            }
        })

        DefineMenu(class extends Menu
        {
            id = "cosmetics_" + name + "_" + prefab_id + "_medal_tournament"
            menu_name = "tournament"

            class_name = name
            prefab_index = prefab_id

            function constructor()
            {
                items = clone(TournamentMedalMenuItems)
            }
        })
    }
}

OnGameEvent("player_say", 110, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    local menu = player.GetVar("menu");
    if(!menu)
        return;

    if(menu.id.find("_editcosmetic") != null && menu.id.find("_editunusual") != null && menu.id.find("_medal_community") != null && menu.id.find("_medal_tournament") != null)
        return;

    //reload the menu in the case we're doing a search on an already searched on menu
    local parent_menu = menu.parent_menu;
    menu = player.SetVar("menu", MENUS[menu.id]());
    menu.parent_menu = parent_menu;

    local menu_suffix = "_search";
    if(player.GetVar("current_menu_dir").find(menu_suffix) == null)
    {
        player.SetVar("current_menu_dir", player.GetVar("current_menu_dir") + menu_suffix);
    }

    local new_item_array = [];
    foreach(i, menuitem in menu.items)
    {
        if(i == 0)
        {
            new_item_array.append(menuitem);
            continue;
        }

        if(menuitem.titles[0].tolower().find(params.text.tolower()) != null)
            new_item_array.append(menuitem);
    }
    menu.items = new_item_array
})