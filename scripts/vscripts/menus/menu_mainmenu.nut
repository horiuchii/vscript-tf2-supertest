DefineMenu(class extends Menu{
    id = "main_menu"
    menu_name = "main"
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
        titles = ["Cosmetic Prefab Overrides"];

        function GenerateDesc(player)
        {
            return "Modify your cosmetic prefab overrides, which\ncosmetics should be equipped as a specific class.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("cosmetics")
        }
    },
    class extends MenuItem{
        titles = ["Player Modifiers"];

        function GenerateDesc(player)
        {
            return "Modify aspects about your player.\n(Conditions, Spells, Health & Ammo)";
        }

        function OnSelected(player)
        {
            player.GoToMenu("player_mod")
        }
    },
    class extends MenuItem{
        titles = ["Player Settings"];

        function GenerateDesc(player)
        {
            return "Modify aspects about your Super Test experience.\n(HUD, Menus, Instant Respawn)";
        }

        function OnSelected(player)
        {
            player.GoToMenu("player_settings")
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
    class extends MenuItem{
        titles = ["Chroma Key Room"];

        function GenerateDesc(player)
        {
            return "Modify the chroma key room.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("chroma")
        }
    },
    class extends MenuItem{
        titles = ["Bot Range"];

        function GenerateDesc(player)
        {
            return "Interact with the bots inside of the bot range.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("bot_controls")
        }
    },
    class extends MenuItem{
        titles = ["Building Range"];

        function GenerateDesc(player)
        {
            return "Interact with the buildings\ninside of the building range.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("building_controls")
        }
    },
    class extends MenuItem{
        titles = ["Server CVars"];

        function GenerateDesc(player)
        {
            return "Modify server console variables.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("server_cvar")
        }
    },
    class extends MenuItem{
        titles = ["Statistics"];

        function GenerateDesc(player)
        {
            return "See various statistics for the items in TF2.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("stats")
        }
    },
    class extends MenuItem{
        titles = ["Changelog"];

        function GenerateDesc(player)
        {
            return "View the history of Super Test updates.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("changelog")
        }
    }
    ]
})