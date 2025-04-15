Cookies.AddCookie("unusual", 0);
Cookies.AddCookie("skin", null);
Cookies.AddCookie("wear", 0.0);
Cookies.AddCookie("seed_lo", 0);
Cookies.AddCookie("seed_hi", 0);
Cookies.AddCookie("spells", 0);
Cookies.AddCookie("festivizer", 0);
Cookies.AddCookie("statclock", 0);

Cookies.AddCookie("killstreak", 0);
Cookies.AddCookie("killstreak_sheen", 1);
Cookies.AddCookie("killstreak_particle", KS_EFFECT_FIRE_HORNS);

::SPEC_PREFIX <- "Spec. KS Sheen: "
::PRO_PREFIX <- "Pro. KS Particle: "

DefineMenu(class extends Menu{
    id = "weapon_mod"
    menu_name = "wep_mod"
    function constructor(){
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

            function OnMenuOpened(player)
            {
                local wear = Cookies.Get(player, "wear")
                switch(wear)
                {
                    case WEAR_FACTORY_NEW: index = 0; break;
                    case WEAR_MINIMAL_WEAR: index = 1; break;
                    case WEAR_FIELD_TESTED: index = 2; break;
                    case WEAR_WELL_WORN: index = 3; break;
                    case WEAR_BATTLE_SCARRED: index = 4; break;
                }
            }

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
                player.SendChat(CHAT_PREFIX + "Set your override weapon wear to: " + WEAR_NAME[wear] + ".")
            }
        }(),
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
                    player.SendChat(CHAT_PREFIX + "Your override weapons will now be festivized.");
                else
                    player.SendChat(CHAT_PREFIX + "Your override weapons will no longer be festivized.");
            }
        },
        class extends MenuItem{
            titles = ["Stat Clock: Off" "Stat Clock: On"];

            function OnMenuOpened(player)
            {
                index = Cookies.Get(player, "statclock")
            }

            function GenerateDesc(player)
            {
                return "Whether the override weapon has a Stat Clock.\nOnly shows on skinned weapons. Current: " + (Cookies.Get(player, "statclock") ? "On" : "Off");
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "statclock", index);
                SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
                if(index)
                    player.SendChat(CHAT_PREFIX + "Your override weapons will now show a Stat Clock.");
                else
                    player.SendChat(CHAT_PREFIX + "Your override weapons will no longer show a Stat Clock.");
            }
        },
        class extends MenuItem{
            titles = ["Unusual: None", "Unusual: Hot", "Unusual: Isotope", "Unusual: Cool", "Unusual: Energy Orb"];

            function OnMenuOpened(player)
            {
                local unusual = Cookies.Get(player, "unusual")
                switch(unusual)
                {
                    case 0: index = 0; break;
                    case WEAPON_UNUSUAL_HOT: index = 1; break;
                    case WEAPON_UNUSUAL_ISOTOPE: index = 2; break;
                    case WEAPON_UNUSUAL_COOL: index = 3; break;
                    case WEAPON_UNUSUAL_ENERGYORB: index = 4; break;
                }
            }

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
                    player.SendChat(CHAT_PREFIX + "Set your override weapon unusual to: " + WEAPON_UNUSUAL_NAME[unusual] + ".");
                else
                    player.SendChat(CHAT_PREFIX + "Removed your override weapon unusual.");
            }
        },
        class extends MenuItem{
            titles = ["Spells: Off" "Spells: On"];

            function OnMenuOpened(player)
            {
                index = Cookies.Get(player, "spells")
            }

            function GenerateDesc(player)
            {
                return "Whether the pumpkin bomb and green flame spells\nshould appear on override weapons. Current: " + (Cookies.Get(player, "spells") ? "On" : "Off");
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "spells", index);
                SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
                if(index)
                    player.SendChat(CHAT_PREFIX + "Spells will appear on your override weapons.");
                else
                    player.SendChat(CHAT_PREFIX + "Spells will not appear on your override weapons.");
            }
        }
        class extends MenuItem{
            titles = ["KS Type: None", "KS Type: Basic", "KS Type: Spec.", "KS Type: Pro."];

            function OnMenuOpened(player)
            {
                index = Cookies.Get(player, "killstreak")
            }

            function GenerateDesc(player)
            {
                return "Which killstreak type should be applied to your\noverride weapons. Current: " + KS_TYPE_NAME[Cookies.Get(player, "killstreak")];
            }

            function OnSelected(player)
            {
                Cookies.Set(player, "killstreak", index);
                local message = CHAT_PREFIX + "Your override weapon killstreak type is now: "
                switch(index)
                {
                    case 0: message += "None"; break;
                    case 1: message += "Basic"; break;
                    case 2: message += "Specialized"; break;
                    case 3: message += "Professional"; break;
                }
                player.SendChat(message)
                SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            }
        },
        class extends MenuItem{
            titles = [SPEC_PREFIX+"Team Shine", SPEC_PREFIX+"D. Daffodil", SPEC_PREFIX+"Manndarin", SPEC_PREFIX+"M. Green", SPEC_PREFIX+"A. Emerald", SPEC_PREFIX+"V. Violet", SPEC_PREFIX+"Hot Rod"];

            function OnMenuOpened(player)
            {
                index = (Cookies.Get(player, "killstreak_sheen") - 1);
            }

            function GenerateDesc(player)
            {
                return "Which sheen color should be applied to your Spec.\nKS override weapons. Current: " + KS_SHEEN_NAME[Cookies.Get(player, "killstreak_sheen")];
            }

            function OnSelected(player)
            {
                local sheen = Cookies.Set(player, "killstreak_sheen", index + 1);
                local message = CHAT_PREFIX + "Your override weapon spec. killstreak sheen color is now: " + KS_SHEEN_NAME[sheen];
                player.SendChat(message);
                SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            }
        },
        class extends MenuItem{
            titles = [PRO_PREFIX+"Cerebral Discharge", PRO_PREFIX+"Fire Horns", PRO_PREFIX+"Flames", PRO_PREFIX+"Hypno-Beam", PRO_PREFIX+"Incinerator", PRO_PREFIX+"Singularity", PRO_PREFIX+"Tornado"];

            function OnMenuOpened(player)
            {
                local particle_id = Cookies.Get(player, "killstreak_particle");
                switch(particle_id)
                {
                    case KS_EFFECT_CEREBRAL_DISCHARGE: index = 0; break;
                    case KS_EFFECT_FIRE_HORNS: index = 1; break;
                    case KS_EFFECT_FLAMES: index = 2; break;
                    case KS_EFFECT_HYPNOBEAM: index = 3; break;
                    case KS_EFFECT_INCINERATOR: index = 4; break;
                    case KS_EFFECT_SINGULARITY: index = 5; break;
                    case KS_EFFECT_TORNADO: index = 6; break;
                }
            }

            function GenerateDesc(player)
            {
                return "Which particle should be applied to your Pro. KS\noverride weapons. Current: " + KS_EFFECT_NAME[Cookies.Get(player, "killstreak_particle")];
            }

            function OnSelected(player)
            {
                local particle_id = null;
                switch(index)
                {
                    case 0: particle_id = KS_EFFECT_CEREBRAL_DISCHARGE; break;
                    case 1: particle_id = KS_EFFECT_FIRE_HORNS; break;
                    case 2: particle_id = KS_EFFECT_FLAMES; break;
                    case 3: particle_id = KS_EFFECT_HYPNOBEAM; break;
                    case 4: particle_id = KS_EFFECT_INCINERATOR; break;
                    case 5: particle_id = KS_EFFECT_SINGULARITY; break;
                    case 6: particle_id = KS_EFFECT_TORNADO; break;
                }
                Cookies.Set(player, "killstreak_particle", particle_id);
                local message = CHAT_PREFIX + "Your override weapon spec. killstreak sheen color is now: " + KS_EFFECT_NAME[particle_id];
                player.SendChat(message);
                SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
            }
        }]
    }
})

OnGameEvent("player_say", 100, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    local menu = player.GetVar("menu");
    if(!menu)
        return;

    if(menu.id != "weapon_mod")
        return;

    //this is a stupid way of looking for the data we need, but we only need to do it once
    local selected_menu_item = menu.items[menu.selected_index];
    local title = selected_menu_item.titles[selected_menu_item.index];

    if(title == "Low Skin Seed Bytes")
    {
        local seed = params.text.tointeger()
        Cookies.Set(player, "seed_lo", seed)
        SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
    }
    else if(title == "High Skin Seed Bytes")
    {
        local seed = params.text.tointeger()
        Cookies.Set(player, "seed_hi", seed)
        SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
    }
})