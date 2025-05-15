Cookies.AddCookie("menu_opacity", 0);

::CTFPlayer.GetMenuOpacity <- function()
{
    local opactiy_value = "";
    switch(Cookies.Get(this, "menu_opacity"))
    {
        case 0: opactiy_value = "100"; break;
        case 1: opactiy_value = "75"; break;
        case 2: opactiy_value = "50"; break;
        case 3: opactiy_value = "0"; break;

        default: opactiy_value = "100"; break;
    }
    return opactiy_value;
}

Cookies.AddCookie("menu_dai_loop", 0);
Cookies.AddCookie("instant_respawn", 0);
Cookies.AddCookie("respawn_at_death_point", 0);
Cookies.AddCookie("show_conds", 0);
Cookies.AddCookie("show_keys", 0);

DefineMenu(class extends Menu{
    id = "player_settings"
    menu_name = "player_settings"
    function constructor(){
        items = [
            class extends MenuItem{
                titles = ["Menu Opacity: 100%" "Menu Opacity: 75%" "Menu Opacity: 50%" "Menu Opacity: 0%"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "menu_opacity");
                }

                function GenerateDesc(player)
                {
                    return "Set the opacity of the Super Test menu background.\nCurrent: " + player.GetMenuOpacity() + "%";
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "menu_opacity", index);
                    player.SendChat(CHAT_PREFIX + "Menu Opacity is now: " + player.GetMenuOpacity() + "%");
                }
            },
            class extends MenuItem{
                titles = ["Delayed Auto Input Menu Looping: Off", "Delayed Auto Input Menu Looping: On"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "menu_dai_loop");
                }

                function GenerateDesc(player)
                {
                    return "Whether to allow the menu to loop with DAIs.\nCurrent: " + (Cookies.Get(player, "menu_dai_loop") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "menu_dai_loop", index);
                    local toggle = (index ? "now" : "no longer");
                    player.SendChat(CHAT_PREFIX + "The menu will " + toggle + " loop with DAI Inputs.");
                }
            },
            class extends MenuItem{
                titles = ["Instant Respawn: Off", "Instant Respawn: On"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "instant_respawn");
                }

                function GenerateDesc(player)
                {
                    return "Whether you will instantly respawn upon death.\nCurrent: " + (Cookies.Get(player, "instant_respawn") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "instant_respawn", index);
                    player.SendChat(CHAT_PREFIX + "Instant Respawn is now: " + (index ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Respawn At Death Point: Off", "Respawn At Death Point: On"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "respawn_at_death_point");
                }

                function GenerateDesc(player)
                {
                    return "Whether you will respawn where you died,\nmaintaining velocity and view angles.\nCurrent: " + (Cookies.Get(player, "respawn_at_death_point") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "respawn_at_death_point", index);
                    player.SendChat(CHAT_PREFIX + "Respawning at death point is now: " + (index ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Show Conditions On HUD: Off", "Show Conditions On HUD: On"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "show_conds");
                }

                function GenerateDesc(player)
                {
                    return "Whether to show active conditions on the HUD.\nMay cause menu flickering when enabled.\nCurrent: " + (Cookies.Get(player, "show_conds") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "show_conds", index);
                    player.SendChat(CHAT_PREFIX + "The Show Conds HUD is now: " + (index ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Show Keys On HUD: Off", "Show Keys On HUD: On"];

                function OnMenuOpened(player)
                {
                    index = Cookies.Get(player, "show_keys");
                }

                function GenerateDesc(player)
                {
                    return "Whether to show keys on the HUD.\nMay cause menu flickering when enabled.\nCurrent: " + (Cookies.Get(player, "show_keys") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "show_keys", index);
                    player.SendChat(CHAT_PREFIX + "The Show Keys HUD is now: " + (index ? "On" : "Off"));
                }
            },
        ]}
    }
)