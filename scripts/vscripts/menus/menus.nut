::MENUS <- {};

class Menu
{
    id = "";
    items = null;
    parent_menu = null;
    selected_index = 0;

    function _tostring()
    {
        return id;
    }

    function OnMenuOpened(player){}
}

::DefineMenu <- function(menu_class)
{
    MENUS[menu_class.id] <- menu_class;
}

class MenuItem
{
    assigned_menu = null;
    titles = null;
    index = 0;

    function OnMenuOpened(player){}

    function GenerateDesc(player)
    {
        return "LINE1\nLINE2";
    }

    function OnSelected(player){}

    function OnLeftRightInput(player, input)
    {
        local length = titles.len() - 1;

        if(length == 0)
            return false;

        local new_loc = this.index + input;

        if(new_loc < 0)
            new_loc = length;
        else if(new_loc > length)
            new_loc = 0;

        this.index = new_loc;

        player.PlaySoundForPlayer({sound_name = "ui/cyoa_node_absent.wav"});
        return true;
    }
}
::MenuItem <- MenuItem

IncludeScript(projectDir+"menus/menu_mainmenu.nut", this);
IncludeScript(projectDir+"menus/menu_loadout.nut", this);
IncludeScript(projectDir+"menus/menu_weaponmods.nut", this);
IncludeScript(projectDir+"menus/menu_weaponmods_skins.nut", this);
IncludeScript(projectDir+"menus/menu_taunts.nut", this);
IncludeScript(projectDir+"menus/menu_botrange.nut", this);

OnGameEvent("player_say", 101, function(params)
{
    local player = GetPlayerFromUserID(params.userid);

    if(params.text != "/menu" && params.text != "!menu")
        return;

    player.GetVar("menu") ? player.CloseMenu() : player.OpenMenu();
})

::CTFPlayer.CloseMenu <- function()
{
    SetVar("stored_menu", GetVar("menu"));
    SetVar("menu", null);
    PlaySoundForPlayer({sound_name = "ui/cyoa_map_close.wav"});
    RemoveFlag(FL_ATCONTROLS);
    SetHudHideFlags(0);
    SetScriptOverlayMaterial(null);
    ClearText();
    AddCustomAttribute("no_attack", 0, -1);
    SetSpyCloakMeter(GetVar("last_saved_cloak"));
    RemoveCond(TF_COND_GRAPPLED_TO_PLAYER)
}

::CTFPlayer.OpenMenu <- function()
{
    local menu = SetVar("menu", GetVar("stored_menu") ? GetVar("stored_menu") : MENUS["main_menu"]());
    PlaySoundForPlayer({sound_name = "ui/cyoa_map_open.wav"});
    EntFireByHandle(env_hudhint_menu, "HideHudHint", "", 0, this, this);
    SetVar("last_saved_cloak", GetSpyCloakMeter());

    menu.OnMenuOpened(this);
    foreach(menuitem in menu.items)
    {
        menuitem.OnMenuOpened(this)
    }
}

::CTFPlayer.GoToMenu <- function(menu_id)
{
    local menu = MENUS[menu_id]();
    menu.parent_menu = GetVar("menu");
    SetVar("menu", menu);
    PlaySoundForPlayer({sound_name = "ui/cyoa_objective_panel_expand.wav"});

    menu.OnMenuOpened(this);
    foreach(menuitem in menu.items)
    {
        menuitem.OnMenuOpened(this)
    }
}

::CTFPlayer.GoUpMenuDir <- function()
{
    if(!GetVar("menu").parent_menu)
    {
        CloseMenu();
        return;
    }

    SetVar("menu", GetVar("menu").parent_menu);
    PlaySoundForPlayer({sound_name = "ui/cyoa_objective_panel_collapse.wav"});
}

::CTFPlayer.HandleCurrentMenu <- function()
{
    AddFlag(FL_ATCONTROLS);
    AddCustomAttribute("no_attack", 1, -1);
    SetPropInt(this, "m_afButtonForced", 0)
    AddCond(TF_COND_GRAPPLED_TO_PLAYER) // block taunts
    SetSpyCloakMeter(0.01);
    if(InCond(TF_COND_TAUNTING))
        RemoveCond(TF_COND_TAUNTING)

    if(IsHoldingButton(IN_SCORE))
    {
        SetHudHideFlags(0);
        return;
    }

    SetHudHideFlags(HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);

    local menu = GetVar("menu");
    if(!menu)
        return;

    SetScriptOverlayMaterial(CONTRACKER_HUD + menu.id);

    // Close Menu
    if(WasButtonJustPressed(IN_ATTACK3))
    {
        CloseMenu();
        return;
    }

    // Navigate Menu UP/DOWN
    if(IsHoldingButton(IN_FORWARD) || IsHoldingButton(IN_BACK))
    {
        local desired_input = (IsHoldingButton(IN_FORWARD) ? -1 : 1)

        if(GetVar("dai_direction") != desired_input)
        {
            SetVar("dai_ticks", -DAI_INITIAL_TICKS);
            SetVar("dai_direction", desired_input);
            ShiftMenuInput(desired_input);
        }
        else
            AddVar("dai_ticks", 1);
    }
    else
    {
        SetVar("dai_direction", null);
    }

    if(GetVar("dai_direction") && GetVar("dai_ticks") > 0 && GetVar("dai_ticks") % DAI_PERIOD_TICKS == 0)
    {
        ShiftMenuInput(GetVar("dai_direction"));
    }

    // Modify Menu Item
    if(IsHoldingButton(IN_MOVELEFT) || IsHoldingButton(IN_MOVERIGHT))
    {
        local desired_input = (IsHoldingButton(IN_MOVELEFT) ? -1 : 1)

        if(GetVar("side_dai_direction") != desired_input)
        {
            SetVar("side_dai_ticks", -SIDE_DAI_INITIAL_TICKS);
            SetVar("side_dai_direction", desired_input);
            ModifyMenuItem(desired_input);
        }
        else
            AddVar("side_dai_ticks", 1);
    }
    else
    {
        SetVar("side_dai_direction", null);
    }

    if(GetVar("side_dai_direction") && GetVar("side_dai_ticks") > 0 && GetVar("side_dai_ticks") % SIDE_DAI_PERIOD_TICKS == 0)
    {
        ModifyMenuItem(GetVar("side_dai_direction"));
    }

    // Select Menu Item
    if(WasButtonJustPressed(IN_ATTACK))
    {
        menu.items[menu.selected_index].OnSelected(this);
        PlaySoundForPlayer({sound_name = "ui/buttonclick.wav"});
    }

    // Return To Previous Menu
    if(WasButtonJustPressed(IN_ATTACK2))
    {
        GoUpMenuDir();
    }

    DisplayMenu();
}

::CTFPlayer.ShiftMenuInput <- function(offset)
{
    local menu = GetVar("menu");

    local length = menu.items.len() - 1;
    local new_loc = menu.selected_index + offset;

    if(new_loc < 0)
        new_loc = length;
    else if(new_loc > length)
        new_loc = 0;

    menu.selected_index = new_loc;

    PlaySoundForPlayer({sound_name = "ui/cyoa_node_absent.wav"});
}

::CTFPlayer.ModifyMenuItem <- function(offset)
{
    local menu = GetVar("menu");
    local menuitem = menu.items[menu.selected_index];
    menuitem.OnLeftRightInput(this, offset);
}

::CTFPlayer.DisplayMenu <- function()
{
    local menu = GetVar("menu");
    if(!menu)
        return;

    local message = "";
    local menu_size = menu.items.len();
    local option_count = 3;
    for(local i = menu.selected_index - (option_count - 1); i < menu.selected_index + (option_count + 2); i++)
    {
        local index = i;

        if(index == -1)
        {
            message += "▲\n";
            continue;
        }
        if(index == menu_size)
        {
            message += "▼\n";
            continue;
        }
        if(index < 0 || index > menu_size - 1)
        {
            message += "\n";
            continue;
        }

        if(!menu.items[i])
        {
            message += "INVALID ITEM\n"
            continue;
        }
        else
        {
            local item = menu.items[index];

            if(item.titles.len() > 1)
                message += "◀  " + item.titles[item.index] + "  ▶\n";
            else
                message += item.titles[0] + "\n";
        }
    }

    SendGameText(-1, 0.2175, 0, "255 255 255", message);
    local desc = !menu.items[menu.selected_index] ? "INVALID ITEM" : menu.items[menu.selected_index].GenerateDesc(this);
    SendGameText(-1, desc.find("\n") ? 0.49 : 0.51, 1, "255 255 255", desc);
}