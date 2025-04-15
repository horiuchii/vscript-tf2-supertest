DefineMenu(class extends Menu{
    id = "player_mod"
    menu_name = "player_mod"
    function constructor(){
        items = [
            class extends MenuItem{
                titles = ["Menu Opacity: 100%" "Menu Opacity: 75%" "Menu Opacity: 50%" "Menu Opacity: 0%"];

                function GenerateDesc(player)
                {
                    return "Set the opacity of the Super Test menu background.\nCurrent: ";
                }

                function OnSelected(player)
                {
                    player.GoToMenu("add_cond");
                }
            },
            class extends MenuItem{
                titles = ["Show Conditions On HUD: Off", "Show Conditions On HUD: On"];

                function GenerateDesc(player)
                {
                    return "Whether to show active conditions on the HUD.\nCurrent: " + (player.GetVar("show_conds") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("show_conds", index);
                    player.SendChat(CHAT_PREFIX + "The Show Conds HUD is now: " + (player.GetVar("show_conds") ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Show Keys On HUD: Off", "Show Keys On HUD: On"];

                function GenerateDesc(player)
                {
                    return "Whether to show keys on the HUD.\nCurrent: " + (player.GetVar("show_keys") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("show_keys", index);
                    player.SendChat(CHAT_PREFIX + "The Show Keys HUD is now: " + (player.GetVar("show_keys") ? "On" : "Off"));
                }
            },
        ]}
    }
)