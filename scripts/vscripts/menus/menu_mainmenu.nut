DefineMenu(class extends Menu{
    id = "main_menu"
    items = [
    class extends MenuItem{
        titles = ["Loadout Overrides"];

        function GenerateDesc(player)
        {
            return "Modify your loadout overrides, which weapons\nshould always be equipped as a specific class.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("loadout")
        }
    },
    class extends MenuItem{
        titles = ["Loadout Override Modifiers"];

        function GenerateDesc(player)
        {
            return "Modify your loadout overrides modifiers.\n(Weapon Skins, KS Effects & Unusuals)";
        }

        function OnSelected(player)
        {
            player.GoToMenu("weapon_mod")
        }
    },
    class extends MenuItem{
        titles = ["Taunts"];

        function GenerateDesc(player)
        {
            return "Perform any taunt you desire.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts")
        }
    },
    // class extends MenuItem{
    //     titles = ["Server Settings"];

    //     function GenerateDesc(player)
    //     {
    //         return "Modify specific server console commands.\n(Random Crits, Spread, Holiday, etc.)\n";
    //     }

    //     function OnSelected(player){}
    // },
    // class extends MenuItem{
    //     titles = ["Player Settings"];

    //     function GenerateDesc(player)
    //     {
    //         return "Modify settings specific to you.\n(Infinite Ammo/Clip, Perma Crits, etc.)\n";
    //     }

    //     function OnSelected(player){}
    // }
    ]
})