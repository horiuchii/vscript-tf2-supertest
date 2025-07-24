::MENUS <- {};

class Menu
{
    id = "";
    menu_name = "UNSET_MENU_NAME";
    items = null;
    parent_menu = null;
    selected_index = 0;

    function _tostring()
    {
        return id;
    }
}

::DefineMenu <- function(menu_class)
{
    MENUS[menu_class.id] <- menu_class;
}

class MenuItem
{
    titles = null;
    index = 0;
    hidden = false;

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
        player.SetVar("current_menuitem_desc", null);
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
IncludeScript(projectDir+"menus/menu_chroma.nut", this);
IncludeScript(projectDir+"menus/menu_buildingrange.nut", this);
IncludeScript(projectDir+"menus/menu_cvars.nut", this);
IncludeScript(projectDir+"menus/menu_playermods.nut", this);
IncludeScript(projectDir+"menus/menu_cosmetics.nut", this);
IncludeScript(projectDir+"menus/menu_playersettings.nut", this);
IncludeScript(projectDir+"menus/menu_stats.nut", this);
IncludeScript(projectDir+"menus/menu_changelog.nut", this);

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
    RemoveCond(TF_COND_GRAPPLED_TO_PLAYER);
}

::CTFPlayer.OpenMenu <- function()
{
    PlaySoundForPlayer({sound_name = "ui/cyoa_map_open.wav"});
    EntFireByHandle(env_hudhint_menu, "HideHudHint", "", 0, this, this);
    SetVar("last_saved_cloak", GetSpyCloakMeter());
    ClearText();

    local menu = GetVar("stored_menu") ? GetVar("stored_menu") : MENUS["main_menu"]();
    SetMenu(menu);
}

::CTFPlayer.GoToMenu <- function(menu_id)
{
    PlaySoundForPlayer({sound_name = "ui/cyoa_objective_panel_expand.wav"});

    local menu = MENUS[menu_id]();
    menu.parent_menu = GetVar("menu");
    SetMenu(menu);
}

::CTFPlayer.GoUpMenuDir <- function()
{
    if(!GetVar("menu").parent_menu)
    {
        CloseMenu();
        return;
    }
    PlaySoundForPlayer({sound_name = "ui/cyoa_objective_panel_collapse.wav"});

    SetMenu(GetVar("menu").parent_menu);
}

::CTFPlayer.SetMenu <- function(menu)
{
    SetVar("current_menuitem_desc", null);
    SetVar("current_menu_dir", null);
    local new_menu = SetVar("menu", menu);
    foreach(menuitem in new_menu.items)
    {
        menuitem.OnMenuOpened(this);
    }
}

::CTFPlayer.HandleCurrentMenu <- function()
{
    AddFlag(FL_ATCONTROLS);
    AddCustomAttribute("no_attack", 1, -1);
    SetPropInt(this, "m_afButtonForced", 0);
    AddCond(TF_COND_GRAPPLED_TO_PLAYER); // block taunts
    SetSpyCloakMeter(0.01);
    if(InCond(TF_COND_TAUNTING))
        RemoveCond(TF_COND_TAUNTING);

    if(IsHoldingButton(IN_SCORE))
    {
        SetHudHideFlags(0);
        return;
    }

    SetHudHideFlags(HIDEHUD_WEAPONSELECTION | HIDEHUD_HEALTH | HIDEHUD_MISCSTATUS | HIDEHUD_CROSSHAIR);

    local menu = GetVar("menu");
    if(!menu)
        return;

    SetScriptOverlayMaterial(CONTRACKER_HUD + "supertest_hud_" + GetMenuOpacity());

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

    //we do additional checks here because scrolling big menus sucks
    if(GetVar("dai_direction") && GetVar("dai_ticks") > 0)
    {
        foreach(i, dai_delay in DAI_TICKS)
        {
            if(GetVar("dai_ticks") > dai_delay)
            {
                if(GetVar("dai_ticks") % DAI_PERIOD_TICKS[i] == 0)
                {
                    ShiftMenuInput(GetVar("dai_direction"), !!Cookies.Get(this, "menu_dai_loop"));
                    break;
                }
            }
        }
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
        SetVar("current_menuitem_desc", null);
        PlaySoundForPlayer({sound_name = "ui/buttonclick.wav"});
    }

    // Return To Previous Menu
    if(WasButtonJustPressed(IN_ATTACK2))
    {
        GoUpMenuDir();
    }

    DisplayMenu();
}

::CTFPlayer.ShiftMenuInput <- function(offset, allow_oob = true)
{
    local menu = GetVar("menu");

    local length = menu.items.len() - 1;
    local new_loc = menu.selected_index + offset;
    local oob = false;

    if(new_loc < 0)
    {
        oob = true;
        new_loc = length;
    }
    else if(new_loc > length)
    {
        oob = true;
        new_loc = 0;
    }

    //skip over hidden menu items
    //TODO: This doesn't work properly when menu items are hidden imbetween unhidden items
    while(menu.items[new_loc].hidden)
    {
        new_loc += offset;

        if(new_loc < 0)
        {
            oob = true;
            new_loc = length;
        }
        else if(new_loc > length)
        {
            oob = true;
            new_loc = 0;
        }
    }

    if(!allow_oob && oob)
        return;

    menu.selected_index = new_loc;

    PlaySoundForPlayer({sound_name = "ui/cyoa_node_absent.wav"});
    SetVar("current_menuitem_desc", null);
}

::CTFPlayer.ModifyMenuItem <- function(offset)
{
    local menu = GetVar("menu");
    local menuitem = menu.items[menu.selected_index];
    menuitem.OnLeftRightInput(this, offset);
}

::CTFPlayer.DisplayMenu <- function()
{
    if((GlobalTickCounter % 3) != 0)
        return;

    local menu = GetVar("menu");
    if(!menu)
        return;

    local add_count = 0;
    local message = "";
    local message2 = "";
    local message3 = "";

    local add_to_buffer = function(msg) {
        if(add_count == 0 || add_count == 1)
        {
            message += msg;
            message2 += "\n";
            message3 += "\n";
        }
        if(add_count == 2 || add_count == 3 || add_count == 4)
        {
            message2 += msg;
            message3 += "\n";
        }
        if(add_count == 5 || add_count == 6 || add_count == 7)
        {
            message3 += msg;
        }

        add_count++;
    }

    local menu_size = menu.items.len();
    local option_count = 3;
    for(local i = menu.selected_index - (option_count - 1); i < menu.selected_index + (option_count + 3); i++)
    {
        local index = i;

        if(index == -1)
        {
            add_to_buffer("▲\n");
            continue;
        }
        if(index == menu_size)
        {
            add_to_buffer("▼\n");
            continue;
        }
        if(index < 0 || index > menu_size - 1)
        {
            add_to_buffer("\n");
            continue;
        }

        if(!menu.items[i])
        {
            add_to_buffer("INVALID ITEM\n");
            continue;
        }
        else
        {
            local item = menu.items[index];

            if(item.hidden)
                continue;

            if(item.titles.len() > 1)
                add_to_buffer("◀  " + item.titles[item.index] + "  ▶\n");
            else
                add_to_buffer(item.titles[0] + "\n");
        }
    }

    SendGameText(-1, 0.11, 0, "255 255 255", message);
    SendGameText(-1, 0.11, 1, "255 255 255", message2);
    SendGameText(-1, 0.11, 2, "255 255 255", message3);

    local desc = GetVar("current_menuitem_desc");

    if(!desc)
        desc = SetVar("current_menuitem_desc", !menu.items[menu.selected_index] ? "INVALID ITEM" : menu.items[menu.selected_index].GenerateDesc(this))

    local linecount = split(desc, "\n").len()
    local desc_text_y;
    switch(linecount)
    {
        case 0:
        case 1: desc_text_y = 0.46; break;
        case 2: desc_text_y = 0.445; break;
        case 3: desc_text_y = 0.425; break;
    }
    SendGameText(-1, desc_text_y, 3, "255 255 255", desc);

    local menu_dir_name = GetVar("current_menu_dir");

    if(!menu_dir_name)
    {
        menu_dir_name = "";
        local menu_loop = menu;
        while(menu_loop)
        {
            menu_dir_name = "/" + menu_loop.menu_name + menu_dir_name;
            menu_loop = menu_loop.parent_menu;
        }
        menu_dir_name = SetVar("current_menu_dir", "." + menu_dir_name);
    }

    SendGameText(-1, 0.075, 4, "500 64 16", menu_dir_name);
}