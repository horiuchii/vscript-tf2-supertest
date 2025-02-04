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
    class extends MenuItem{
        titles = ["Bot Range Controls"];

        function GenerateDesc(player)
        {
            return "Control aspects about the bot range.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("bot_controls")
        }
    }
    ]
})