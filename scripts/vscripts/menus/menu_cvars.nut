class CvarMenuItem
{
    name = "" //cvar name
    display_name = "" //easy to read name for cvar
    options = null //array containing every desired value
    option_names = null //array containing a easy to read result for the value
    description = "" //string describing the cvar

    function constructor(_name, _display_name, _options, _option_names, _description)
    {
        name = _name
        display_name = _display_name
        options = _options;
        option_names = _option_names;
        description = _description;
    }

    function GetCvarValueName()
    {
        local value = Convars.GetInt(name);
        local index = options.find(value);
        return (index != null ? option_names[index] : value);
    }

    function GetCvarValueIndex()
    {
        local value = Convars.GetInt(name);
        local index = options.find(value);
        return (index != null ? index : 0);
    }
}

::CVarList <- [
    CvarMenuItem("sv_gravity" , "Gravity", [400, 800, 1200], ["0.5x", "1.0x", "1.5x"], "The scale of gravitational force."),
    CvarMenuItem("tf_cheapobjects", "Cheap Buildings", [0, 1], ["Off", "On"], "Whether engineer buildings should\nbe free to build and upgrade."),
    CvarMenuItem("tf_weapon_criticals", "Random Crits", [0, 1], ["Off", "On"], "Whether weapons should random crit."),
    CvarMenuItem("tf_weapon_criticals_melee", "Melee Random Crits", [0, 1, 2], ["Never", "Default", "Always"], "Whether melee weapons should random crit.\nDefault follows what value Random Crits is set to."),
    CvarMenuItem("tf_use_fixed_weaponspreads", "Bullet Spread", [0, 1], ["Random", "Fixed"], "Whether hitscan weapons\nshould have a fixed bullet spread."),
    CvarMenuItem("tf_grapplinghook_enable", "Grapple Hook", [0, 1], ["Off", "On"], "Whether players will be prompted\nto equip a grappling hook on spawn."),
    CvarMenuItem("tf_spells_enabled", "Spells", [0, 1], ["Off", "On"], "Whether players will be prompted to\nequip a spell book on spawn."),
    CvarMenuItem("tf_forced_holiday", "Force Holiday", [0, 1, 2, 3, 5, 8, 11, 12], ["None", "Birthday", "Halloween", "Christmas", "End Of The Line", "Full Moon", "April Fools", "Rick May's Birthday"], "What holiday should be forced on."),
    CvarMenuItem("tf_bot_force_jump", "Force Bot Jump", [0, 1], ["Off", "On"], "Whether bots will continuously jump."),
    CvarMenuItem("tf_bot_melee_only", "Force Bot Melee", [0, 1], ["Off", "On"], "Whether bots will have their melee out."),
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
                index = cvar_data.GetCvarValueIndex();

                foreach(i, name in cvar_data.option_names)
                {
                    titles.append(cvar_data.display_name + ": " + name);
                }
            }

            function GenerateDesc(player)
            {
                return "Current: " + cvar_data.GetCvarValueName() + "\n" + cvar_data.description;
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