DefineMenu(class extends Menu{
    id = "player_mod"
    menu_name = "player_mod"
    function constructor(){
        items = [
            class extends MenuItem{
                titles = ["Add Condition"];

                function GenerateDesc(player)
                {
                    return "Add a specific condition.";
                }

                function OnSelected(player)
                {
                    player.GoToMenu("add_cond");
                }
            },
            class extends MenuItem{
                titles = ["Remove Condition"];

                function GenerateDesc(player)
                {
                    return "Remove a specific condition.";
                }

                function OnSelected(player)
                {
                    player.GoToMenu("remove_cond");
                }
            },
            class extends MenuItem{
                titles = ["Remove All Conditions"];

                function GenerateDesc(player)
                {
                    return "Removes all Conditions applied to you.";
                }

                function OnSelected(player)
                {
                    foreach(cond_index, cond_name in TF_COND_NAMES)
                    {
                        player.RemoveCond(cond_index);
                    }
                }
            },
            class extends MenuItem{
                titles = ["Give Specific Spell"];

                function GenerateDesc(player)
                {
                    return "Give yourself a specific spell.\nSpells must be enabled in the CVar Menu.";
                }

                function OnSelected(player)
                {
                    player.GoToMenu("give_spell");
                }
            },
            class extends MenuItem{
                titles = ["Set Killstreak: 0" "Set Killstreak: 5" "Set Killstreak: 10" "Set Killstreak: 15" "Set Killstreak: 20"];

                function GenerateDesc(player)
                {
                    return "Set your current killstreak count.";
                }

                function OnSelected(player)
                {
                    for(local i = 0; i < 4; i++)
                    {
                        SetPropIntArray(player, "m_Shared.m_nStreaks", index*5, i);
                    }
                    player.SendChat(CHAT_PREFIX + "Set the killstreak on your weapons to " + index*5 + ".");
                }
            },
            class extends MenuItem{
                titles = ["Invulnerable: Off" "Invulnerable: On"];

                function OnMenuOpened(player)
                {
                    index = player.GetVar("invuln").tointeger();
                }

                function GenerateDesc(player)
                {
                    return "Whether all damage being inflicted\non you should be ignored.\nCurrent: " + (player.GetVar("invuln") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("invuln", index);
                    player.SendChat(CHAT_PREFIX + "Invulnerability is now: " + (player.GetVar("invuln") ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Infinite Cash: Off" "Infinite Cash: On"];

                function OnMenuOpened(player)
                {
                    index = player.GetVar("inf_cash").tointeger();
                }

                function GenerateDesc(player)
                {
                    return "Grants infinite MvM cash.\nCurrent: " + (player.GetVar("inf_cash") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("inf_cash", index);
                    player.SendChat(CHAT_PREFIX + "Infinite MvM Cash is now: " + (player.GetVar("inf_cash") ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Infinite Clip: Off" "Infinite Clip: On"];

                function OnMenuOpened(player)
                {
                    index = player.GetVar("inf_clip").tointeger();
                }

                function GenerateDesc(player)
                {
                    return "Grants infinite weapon clip.\nCurrent: " + (player.GetVar("inf_clip") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("inf_clip", index);
                    player.SendChat(CHAT_PREFIX + "Infinite clip is now: " + (player.GetVar("inf_clip") ? "On" : "Off"));
                }
            },
            class extends MenuItem{
                titles = ["Infinite Reserve Ammo: Off" "Infinite Reserve Ammo: On"];

                function OnMenuOpened(player)
                {
                    index = player.GetVar("inf_ammo").tointeger();
                }

                function GenerateDesc(player)
                {
                    return "Grants infinite weapon reserve ammo.\nCurrent: " + (player.GetVar("inf_ammo") ? "On" : "Off");
                }

                function OnSelected(player)
                {
                    player.SetVar("inf_ammo", index);
                    player.SendChat(CHAT_PREFIX + "Infinite reserve ammo is now: " + (player.GetVar("inf_ammo") ? "On" : "Off"));
                }
            },
        ]
    }
})

function GenerateCondSelectMenus()
{
    local menu = class extends Menu{id = "add_cond"; menu_name = "add_cond"; items = []};
    foreach(cond_index, cond_name in TF_COND_NAMES)
    {
        menu.items.append(class extends MenuItem
        {
            condition_index = cond_index;
            condition_name = cond_name;
            titles = [cond_name];

            function GenerateDesc(player)
            {
                return "Give yourself the [" + condition_index + "] " + condition_name + " condition.";
            }

            function OnSelected(player)
            {
                player.AddCond(condition_index);
                player.SendChat(CHAT_PREFIX + "Gave yourself the [" + condition_index + "] " + condition_name + " condition.");
            }
        })
    }
    DefineMenu(menu);
    menu = class extends Menu{id = "remove_cond"; menu_name = "remove_cond"; items = []};
    foreach(cond_index, cond_name in TF_COND_NAMES)
    {
        menu.items.append(class extends MenuItem
        {
            condition_index = cond_index;
            condition_name = cond_name;
            titles = [cond_name];

            function GenerateDesc(player)
            {
                return "Remove the [" + condition_index + "] " + condition_name + " condition from yourself.";
            }

            function OnSelected(player)
            {
                player.RemoveCond(condition_index);
                player.SendChat(CHAT_PREFIX + "Removed the [" + condition_index + "] " + condition_name + " condition from yourself.");
            }
        })
    }
    DefineMenu(menu);
}
GenerateCondSelectMenus();

function GenerateSpellSelectMenu()
{
    local menu = class extends Menu{id = "give_spell"; menu_name = "give_spell"; items = []};
    foreach(i, spell_data in TF_SPELLS)
    {
        menu.items.append(class extends MenuItem
        {
            spell_index = i;
            spell_name = spell_data[0];
            spell_charges = spell_data[1];
            titles = [spell_data[0]];

            function GenerateDesc(player)
            {
                return "Give yourself the " + spell_name + " spell.";
            }

            function OnSelected(player)
            {
                if(!Convars.GetBool("tf_spells_enabled"))
                {
                    Convars.SetValue("tf_spells_enabled", 1);
                    player.SendChat(CHAT_PREFIX + "Enabled spells as they were previously disabled.");
                }

                local spellbook = null;

                for(local wearable = player.FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
                {
                    if(wearable.GetClassname() != "tf_weapon_spellbook")
                        continue;

                    spellbook = wearable;
                }

                if(!spellbook)
                {
                    player.SendChat(CHAT_PREFIX + "Cannot grant spell as you don't have a spellbook equipped.");
                    return;
                }

                SetPropInt(spellbook, "m_iSelectedSpellIndex", spell_index);
                SetPropInt(spellbook, "m_iSpellCharges", spell_charges);
                player.SendChat(CHAT_PREFIX + "Gave yourself the " + spell_name + " spell.");
            }
        })
    }
    DefineMenu(menu);
}
GenerateSpellSelectMenu();