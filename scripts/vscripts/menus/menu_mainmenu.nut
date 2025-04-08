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
        titles = ["Player Modifiers"];

        function GenerateDesc(player)
        {
            return "Modify aspects about yourself.\n(Conditions, Spells, Health & Ammo)";
        }

        function OnSelected(player)
        {
            player.GoToMenu("player_mod")
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
        titles = ["Server CVars"];

        function GenerateDesc(player)
        {
            return "Modify server console variables.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("server_cvar")
        }
    }
    ]
})