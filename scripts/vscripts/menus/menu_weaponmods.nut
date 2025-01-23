Cookies.AddCookie("unusual", 0);
Cookies.AddCookie("skin", null);
Cookies.AddCookie("wear", 0);
Cookies.AddCookie("seed_lo", 0);
Cookies.AddCookie("seed_hi", 0);

DefineMenu(class extends Menu{
    id = "weapon_mod"
    items = [
    class extends MenuItem{
        titles = ["Skins"];

        function GenerateDesc(player)
        {
            return "Select the skin to apply to override weapons.\nCurrent: TODO";
        }

        function OnSelected(player)
        {
            player.GoToMenu("weapon_mod_skins")
        }
    },
    class extends MenuItem{
        titles = ["Skin Wear: Factory New", "Skin Wear: Minimal Wear", "Skin Wear: Field Tested", "Skin Wear: Well Worn", "Skin Wear: Battle Scarred"];

        function GenerateDesc(player)
        {
            return "Select the wear float to apply to override weapons.\nCurrent: " + WEAR_NAME[Cookies.Get(player, "wear")];
        }

        function OnSelected(player)
        {
            local wear = 0;
            switch(index)
            {
                case 0: wear = WEAR_FACTORY_NEW; break;
                case 1: wear = WEAR_MINIMAL_WEAR; break;
                case 2: wear = WEAR_FIELD_TESTED; break;
                case 3: wear = WEAR_WELL_WORN; break;
                case 4: wear = WEAR_BATTLE_SCARRED; break;
            }
            Cookies.Set(player, "wear", wear)
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Set your override weapon wear to: " + WEAR_NAME[wear] + ".")
        }
    },
    class extends MenuItem{
        titles = ["Lower Skin Seed Bytes", "Upper Skin Seed Bytes"];

        function GenerateDesc(player)
        {
            return "Select to randomize seed, type in chat to set seed.\nCurrent: " + Cookies.Get(player, index == 0 ? "seed_lo" : "seed_hi");
        }

        function OnSelected(player)
        {
            local new_seed = "";
            for (local i = 0; i < 13; i++)
            {
                new_seed += RandomInt(0,9).tostring()
            }

            Cookies.Set(player, index == 0 ? "seed_lo" : "seed_hi", new_seed)
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
        }
    },
    class extends MenuItem{
        titles = ["Killstreaker"];

        function GenerateDesc(player)
        {
            return "Set the killstreaker to apply to override weapons.\nCurrent: TODO";
        }

        function OnSelected(player)
        {
            player.GoToMenu("weapon_mod_killstreak")
        }
    },
    class extends MenuItem{
        titles = ["Unusual: None", "Unusual: Hot", "Unusual: Isotope", "Unusual: Cool", "Unusual: Energy Orb"];

        function GenerateDesc(player)
        {
            return "Select the unusual to appear on override weapons.\nCurrent: " + WEAPON_UNUSUAL_NAME[Cookies.Get(player, "unusual")];
        }

        function OnSelected(player)
        {
            local unusual = 0;
            switch(index)
            {
                case 0: break;
                case 1: unusual = WEAPON_UNUSUAL_HOT; break;
                case 2: unusual = WEAPON_UNUSUAL_ISOTOPE; break;
                case 3: unusual = WEAPON_UNUSUAL_COOL; break;
                case 4: unusual = WEAPON_UNUSUAL_ENERGYORB; break;
            }
            Cookies.Set(player, "unusual", unusual)
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            if(unusual)
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Set your override weapon unusual to: " + WEAPON_UNUSUAL_NAME[unusual] + ".")
            else
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Removed your override weapon unusual.")
        }
    }
    ]
})

OnGameEvent("player_say", 100, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    local menu = player.GetVar("menu");
    if(!menu)
        return;

    if(menu.id != "weapon_mod")
        return;

    local title = menu.items[menu.selected_index].titles[menu.items[menu.selected_index].index];

    if(title == "Lower Skin Seed Bytes")
    {
        local seed = params.text.tointeger()
        Cookies.Set(player, "seed_lo", seed)
    }
    else if(title == "Upper Skin Seed Bytes")
    {
        local seed = params.text.tointeger()
        Cookies.Set(player, "seed_hi", seed)
    }

    SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
})