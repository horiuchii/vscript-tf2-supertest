Cookies.AddCookie("unusual", 0);
Cookies.AddCookie("skin", null);
Cookies.AddCookie("wear", 0.0);
Cookies.AddCookie("seed_lo", 0);
Cookies.AddCookie("seed_hi", 0);
Cookies.AddCookie("spells", 0);
Cookies.AddCookie("festivizer", 0);

DefineMenu(class extends Menu{
    id = "weapon_mod"
    items = [
    class extends MenuItem{
        titles = ["Skins & War Paints"];

        function GenerateDesc(player)
        {
            local current_skin = Cookies.Get(player, "skin")
            local skin_string = IsSkinValid(current_skin) ? SKINS[current_skin].display_name : "None"
            return "Select the skin to apply to override weapons.\nCurrent: " + skin_string;
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
        titles = ["Low Skin Seed Bytes", "High Skin Seed Bytes"];

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
        titles = ["Festivizer: Off" "Festivizer: On"];

        function OnMenuOpened(player)
        {
            index = Cookies.Get(player, "festivizer")
        }

        function GenerateDesc(player)
        {
            return "Whether the override weapon should be festivized.\nCurrent: " + (Cookies.Get(player, "festivizer") ? "On" : "Off");
        }

        function OnSelected(player)
        {
            Cookies.Set(player, "festivizer", index);
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            if(index)
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Your override weapons will now be festivized.");
            else
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Your override weapons will no longer be festivized.");
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
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Set your override weapon unusual to: " + WEAPON_UNUSUAL_NAME[unusual] + ".");
            else
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Removed your override weapon unusual.");
        }
    },
    class extends MenuItem{
        titles = ["Spells: Off" "Spells: On"];

        function GenerateDesc(player)
        {
            return "Whether the pumpkin bomb and green flame spells\nshould appear on override weapons. Current: " + (Cookies.Get(player, "spells") ? "On" : "Off");
        }

        function OnSelected(player)
        {
            Cookies.Set(player, "spells", index);
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            if(index)
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Spells will appear on your override weapons.");
            else
                player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Spells will not appear on your override weapons.");
        }
    }
    class extends MenuItem{
        titles = ["KS Type: None", "KS Type: Basic", "KS Type: Specialized", "KS Type: Professional"];

        function GenerateDesc(player)
        {
            return "Which killstreak type should be applied to your\noverride weapons. Current: Professional";
        }

        function OnSelected(player)
        {
        }
    },
    class extends MenuItem{
        titles = ["Spec. KS Sheen: Team Shine", "Spec. KS Sheen: Hot Rod", "Spec. KS Sheen: Manndarin", "Spec. KS Sheen: Deadly Daffodil", "Spec. KS Sheen: Agonizing Emerald", "Spec. KS Sheen: Mean Green", "Spec. KS Sheen: Villianous Violet"];

        function GenerateDesc(player)
        {
            return "Which sheen color should be applied to your Spec.\nKS override weapons. Current: Villianous Violet";
        }

        function OnSelected(player)
        {
        }
    },
    class extends MenuItem{
        titles = ["Pro. KS Particle: Cerebral Discharge", "Pro. KS Particle: Fire Horns", "Pro. KS Particle: Flames", "Pro. KS Particle: Hypno-Beam", "Pro. KS Particle: Incinerator", "Pro. KS Particle: Singularity", "Pro. KS Particle: Tornado"];

        function GenerateDesc(player)
        {
            return "Which particle should be applied to your Pro. KS\noverride weapons. Current: Cerebral Discharge";
        }

        function OnSelected(player)
        {
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