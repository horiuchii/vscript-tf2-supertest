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
    // class extends MenuItem{
    //     titles = ["Taunt Unusual"];

    //     function GenerateDesc(player)
    //     {
    //         return "Pick a taunt unusual that will appear\nwhen you pick a taunt from the menu.";
    //     }

    //     function OnSelected(player)
    //     {
    //         player.GoToMenu("taunts_unusual");
    //     }
    // }
    ]
})

::SortTaunts <- function(a,b)
{
    if(a.id > b.id) return 1;
    if(a.id < b.id) return -1;
    return 0;
}

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
    menuitems.sort(SortTaunts);
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
        menuitems.sort(SortTaunts);
        menu.items = menuitems;
        DefineMenu(menu);
    }

    //TODO: generate the unusual selection menu
}
GenerateTauntSelectMenus();
