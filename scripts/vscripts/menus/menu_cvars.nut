::CVarList <- [
    {
        name = "sv_gravity"
        display_name = "Gravity"
        options = [400, 800, 1200]
        option_names = ["0.5x", "1.0x", "1.5x"]
        description = "The scale of gravitational force."
    },
    {
        name = "tf_cheapobjects"
        display_name = "Cheap Buildings"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether engineer buildings should\nbe free to build and upgrade."
    },
    {
        name = "tf_weapon_criticals"
        display_name = "Random Crits"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether weapons should random crit."
    },
    {
        name = "tf_weapon_criticals_melee"
        display_name = "Melee Random Crits"
        options = [0, 1, 2]
        option_names = ["Never", "Default", "Always"]
        description = "Whether melee weapons should random crit.\nDefault follows what value Random Crits is set to."
    },
    {
        name = "tf_use_fixed_weaponspreads"
        display_name = "Bullet Spread"
        options = [0, 1]
        option_names = ["Random", "Fixed"]
        description = "Whether hitscan weapons\nshould have a fixed bullet spread."
    },
    {
        name = "tf_grapplinghook_enable"
        display_name = "Grapple Hook"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether players will be prompted\nto equip a grappling hook on spawn."
    },
    {
        name = "tf_spells_enabled"
        display_name = "Spells"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether players will be prompted to\nequip a spell book on spawn."
    },
    {
        name = "tf_forced_holiday"
        display_name = "Force Holiday"
        options = [0, 1, 2, 3, 5, 8, 11, 12]
        option_names = ["None", "Birthday", "Halloween", "Christmas", "End Of The Line", "Full Moon", "April Fools", "Rick May's Birthday"]
        description = "What holiday should be forced on."
    },
    {
        name = "tf_bot_force_jump"
        display_name = "Force Bot Jump"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether bots will continuously jump."
    },
    {
        name = "tf_bot_melee_only"
        display_name = "Force Bot Melee"
        options = [0, 1]
        option_names = ["Off", "On"]
        description = "Whether bots will have their melee out."
    }
]

foreach(cvar in CVarList)
{
    ServerCookies.AddCookie(cvar.name, Convars.GetInt(cvar.name));
}

::SetServerCookieCVars <- function()
{
    foreach(cvar in CVarList)
    {
        Convars.SetValue(cvar.name, ServerCookies.Get(cvar.name))
    }
}

::GenerateCVarMenuItems <- function(menu)
{
    menu.items = [];
    foreach(cvar in CVarList)
    {
        local menu_item = class extends MenuItem
        {
            titles = [];
            cvar_data = cvar;

            function OnMenuOpened(player)
            {
                titles = [];

                foreach(i, name in cvar_data.option_names)
                {
                    titles.append(cvar_data.display_name + ": " + name);
                }

                local cvar_value = Convars.GetInt(cvar_data.name);
                local cvar_index = cvar_data.options.find(cvar_value);
                index = (cvar_index != null ? cvar_index : 0);
            }

            function GenerateDesc(player)
            {
                local cvar_value = Convars.GetInt(cvar_data.name);
                local cvar_index = cvar_data.options.find(cvar_value);
                local cvar_option_displayname = (cvar_index != null ? cvar_data.option_names[cvar_index] : cvar_value);

                return "Current: " + cvar_option_displayname + "\n" + cvar_data.description;
            }

            function OnSelected(player)
            {
                Convars.SetValue(cvar_data.name, cvar_data.options[index]);
                ServerCookies.Set(cvar_data.name, cvar_data.options[index]);
                player.SendChat(CHAT_PREFIX + "Set CVar \"" + cvar_data.name + "\" to: " + cvar_data.options[index]);
            }
        }()
        menu.items.append(menu_item);
    }
}

DefineMenu(class extends Menu{
    id = "server_cvar"
    items = []

    function constructor()
    {
        GenerateCVarMenuItems(this);
    }
})