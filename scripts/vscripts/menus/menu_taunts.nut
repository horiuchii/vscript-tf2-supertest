Cookies.AddCookie("taunt_unusual", 0);

DefineMenu(class extends Menu{
    id = "taunts"
    menu_name = "taunts"
    items = [
    class extends MenuItem{
        titles = ["Current Class"];

        function GenerateDesc(player)
        {
            return "Pick any taunt to perform as a "+UpperFirst(TF_CLASSES[player.GetPlayerClass() - 1])+".";
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts_" + TF_CLASSES[player.GetPlayerClass()-1]);
        }
    },
    class extends MenuItem{
        titles = ["All-Class Taunts"];

        function GenerateDesc(player)
        {
            return "Pick a taunt you can perform as any class.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts_allclass");
        }
    },
    class extends MenuItem{
        titles = ["Taunt Unusual"];

        function GenerateDesc(player)
        {
            local unusual_id = Cookies.Get(player, "taunt_unusual");
            local unusual_name = unusual_id ? UNUSUALS[unusual_id].name : "None";
            return "Pick an unusual that will appear with a menu taunt.\nWhile in this menu, type in chat to perform a search.\nCurrent: " + unusual_name;
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts_unusual");
            local unusual_id = Cookies.Get(player, "taunt_unusual");
            if(unusual_id != 0)
            {
                foreach(i, unusual in player.GetVar("menu").items)
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
    }
    ]
})

function GenerateTauntSelectMenus()
{
    local allclass_taunts = [];
    local class_taunts = {};

    //sort all of the taunts
    foreach(taunt_id, taunt in TAUNTS)
    {
        local allclass = !("classes" in taunt);

        if(allclass)
            allclass_taunts.append({id = taunt_id, name = taunt.name});
        else
        {
            foreach(class_index in taunt.classes)
            {
                if(!(class_index in class_taunts))
                    class_taunts[class_index] <- {}

                class_taunts[class_index][taunt_id] <- taunt.name;
            }
        }
    }

    //make the allclass taunt menu
    local menu = class extends Menu{id = "taunts_allclass"; menu_name = "all_class"; items = []};
    local menuitems = [];
    foreach(taunt_data in allclass_taunts)
    {
        menuitems.append(class extends MenuItem
        {
            taunt_name = taunt_data.name;
            id = taunt_data.id;
            titles = [taunt_data.name];

            function GenerateDesc(player)
            {
                return "Perform the " + taunt_name + (taunt_name.find("!") != null ? "" : ".");
            }

            function OnSelected(player)
            {
                player.CloseMenu();
                player.ForceTaunt(id);
            }
        })
    }
    menuitems.sort(function(a,b){return a.id <=> b.id;});
    menu.items = menuitems;
    DefineMenu(menu);

    //generate the class taunt menus
    foreach(class_index, class_name in TF_CLASSES)
    {
        local menu = class extends Menu{id = "taunts_" + class_name; menu_name = class_name; items = []};
        local menuitems = [];
        foreach(_taunt_id, _taunt_name in class_taunts[class_index + 1])
        {
            menuitems.append(class extends MenuItem
            {
                class_id = class_index;
                taunt_name = _taunt_name;
                id = _taunt_id;
                titles = [_taunt_name];

                function GenerateDesc(player)
                {
                    return "Perform the " + taunt_name + (taunt_name.find("!") != null ? "" : ".");
                }

                function OnSelected(player)
                {
                    if(player.GetPlayerClass() != class_id + 1)
                    {
                        player.SendChat(CHAT_PREFIX + "Cannot perform this taunt as you are not a " + UpperFirst(TF_CLASSES[class_id]) + ".")
                        return;
                    }

                    player.CloseMenu();
                    player.ForceTaunt(id);
                }
            })
        }
        menuitems.sort(function(a,b){return a.id <=> b.id;});
        menu.items = menuitems;
        DefineMenu(menu);
    }

    //generate the unusual selection menu
    local particle_menu = class extends Menu{id = "taunts_unusual"; menu_name = "unusual"; items = []};
    local unusual_items = [];
    foreach(unusual_id, unusual_data in UNUSUALS)
    {
        //only add this unusual if its a taunt unusual
        if(unusual_data.type == UnusualType.Taunt)
        {
            unusual_items.append(class extends MenuItem
            {
                unusual_index = unusual_id;
                titles = [unusual_data.name];

                function GenerateDesc(player)
                {
                    return "Set the " + titles[0] + " as your\nunusual when taunting from the menu.";
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "taunt_unusual", unusual_index);
                    player.SendChat(CHAT_PREFIX + "Set the " + titles[0] + " as your unusual when taunting from the menu.");
                }
            })
        }
    }

    unusual_items.sort(function(a,b){return a.unusual_index <=> b.unusual_index;})

    unusual_items.insert(0, class extends MenuItem
    {
        titles = ["Remove Unusual"];

        function GenerateDesc(player)
        {
            return "Set your unusual when taunting\nfrom the menu to be nothing.";
        }

        function OnSelected(player)
        {
            Cookies.Set(player, "taunt_unusual", 0);
            player.SendChat(CHAT_PREFIX + "Set your unusual when taunting from the menu to be nothing.");
        }
    })

    particle_menu.items = unusual_items;
    DefineMenu(particle_menu);
}
GenerateTauntSelectMenus();

OnGameEvent("player_say", 110, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    local menu = player.GetVar("menu");
    if(!menu)
        return;

    if(menu.id != "taunts_unusual")
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