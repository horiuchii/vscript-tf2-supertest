function GenerateLoadoutMenu()
{
    local menu = class extends Menu{id = "loadout"; items = array(9, null)};
    foreach(class_index_, name in TF_CLASSES)
    {
        menu.items[TF_CLASS_REMAP[class_index_ + 1]] = class extends MenuItem
        {
            class_name = name;
            class_index = class_index_;
            titles = [UpperFirst(name)];

            function GenerateDesc(player)
            {
                local count = 0;

                for (local weapon_slot_index = WeaponSlot.Primary; weapon_slot_index < WeaponSlot.MAX; weapon_slot_index++)
                {
                    if(weapon_slot_index == WeaponSlot.DisguiseKit)
                        continue;

                    if(weapon_slot_index == WeaponSlot.InvisWatch && class_name != "spy")
                        continue;

                    if(IsWeaponValid(player.GetDesiredWeapon(class_index + 1, weapon_slot_index)))
                        count += 1;
                }

                return "Modify the loadout overrides for your " + UpperFirst(class_name) + ".\nCurrent #: " + count;
            }

            function OnSelected(player)
            {
                player.GoToMenu("loadout_" + class_name)
            }
        }
    }
    DefineMenu(menu);
}
GenerateLoadoutMenu();

function GenerateClassSlotSelectMenu()
{
    foreach(i, name in TF_CLASSES)
    {
        local menu = class extends Menu{id = "loadout_" + name; items = []};
        foreach(slot_name_index, slot in (name == "spy") ? LOADOUT_SLOT_NAMES_SPY : LOADOUT_SLOT_NAMES)
        {
            menu.items.append(class extends MenuItem
            {
                class_name = name;
                class_index = i;
                slot_name = slot;
                slot_index = (name == "spy") ? LOADOUT_SLOT_IDS_SPY[slot_name_index] : LOADOUT_SLOT_IDS[slot_name_index]
                titles = [UpperFirst(slot)];

                function GenerateDesc(player)
                {
                    local current_wep = player.GetDesiredWeapon(class_index + 1, slot_index)
                    local wep_string = IsWeaponValid(current_wep) ? WEAPONS[current_wep].display_name : "None"
                    return "Set the override for " + UpperFirst(class_name) + "'s " + slot_name + ".\nCurrent: " + wep_string;
                }

                function OnSelected(player)
                {
                    player.GoToMenu("loadout_" + class_name + "_" + slot_name);
                }
            })
        }
        DefineMenu(menu);
    }
}
GenerateClassSlotSelectMenu();

function GenerateClassWeaponSelectMenu()
{
    foreach(class_index, name in TF_CLASSES)
    {
        foreach(slot_index, slot in (name == "spy") ? LOADOUT_SLOT_NAMES_SPY : LOADOUT_SLOT_NAMES)
        {
            local menu = class extends Menu{id = "loadout_" + name + "_" + slot; items = []};
            menu.items.append(class extends MenuItem
            {
                class_id = class_index + 1;
                class_name = name;
                slot_name = slot;
                slot_id = (name == "spy") ? LOADOUT_SLOT_IDS_SPY[slot_index] : LOADOUT_SLOT_IDS[slot_index];
                titles = ["Remove Override"];

                function GenerateDesc(player)
                {
                    return "Remove the " + UpperFirst(class_name) + "'s " + slot_name + " override.";
                }

                function OnSelected(player)
                {
                    player.UnequipWeaponInSlot(class_id, slot_id);
                    player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Removed the " + UpperFirst(class_name) + "'s " + slot_name + " override.")
                }
            })
            foreach(weapon in FilterWeapons(class_index + 1, (name == "spy") ? LOADOUT_SLOT_IDS_SPY[slot_index] : LOADOUT_SLOT_IDS[slot_index]))
            {
                if(safeget(weapon, "variant", false))
                    continue;

                local weapon_menu_item = class extends MenuItem
                {
                    class_id = class_index + 1;
                    class_name = name;
                    slot_name = slot;
                    slot_id = weapon.slot
                    weapon_idnames = [weapon.weapon_id];
                    titles = [weapon.display_name];

                    function GenerateDesc(player)
                    {
                        local pre_newline = "Set the " + UpperFirst(class_name) + "'s " + slot_name;

                        local weapon_name = titles[index];
                        local newline = weapon_name.len() < 24 ? "\noverride to the " : " override to the\n";

                        return pre_newline + newline + titles[index] + ".";
                    }

                    function OnSelected(player)
                    {
                        player.EquipWeapon(class_id, weapon_idnames[index]);
                        player.SetVar("priority_weapon_switch_slot", slot_id);
                        player.SendChat("\x07" + "66B2B2" + "[SUPER TEST] " + "Equipped the " + titles[index] + " for " + UpperFirst(class_name) + "'s " + slot_name + " override.")
                    }
                }

                if(safeget(weapon, "variants", false))
                {
                    foreach (variant_wep in weapon.variants)
                    {
                        if(!(variant_wep in WEAPONS))
                        {
                            DebugPrint("ERROR: INVALID VARIANT: " + variant_wep);
                            continue;
                        }

                        weapon_menu_item.titles.append(WEAPONS[variant_wep].display_name)
                        weapon_menu_item.weapon_idnames.append(variant_wep)
                    }
                }

                menu.items.append(weapon_menu_item)
            }
            DefineMenu(menu);
        }
    }
}
GenerateClassWeaponSelectMenu();