function GenerateLoadoutMenu()
{
    local menu = class extends Menu{id = "loadout"; menu_name = "loadout"; items = array(9, null)};
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
    menu.items.append(class extends MenuItem
    {
        titles = ["Clear Loadout Overrides"];

        function GenerateDesc(player)
        {
            return "Clear all loadout overrides for each class.";
        }

        function OnSelected(player)
        {
            for (local class_index = TF_CLASS_SCOUT; class_index < TF_CLASS_CIVILIAN; class_index++)
            {
                for (local weapon_slot_index = WeaponSlot.Primary; weapon_slot_index < WeaponSlot.MAX; weapon_slot_index++)
                {
                    if(weapon_slot_index == WeaponSlot.DisguiseKit)
                        continue;

                    if(weapon_slot_index == WeaponSlot.InvisWatch && class_index != TF_CLASS_SPY)
                        continue;

                    Cookies.Set(player, FormatWeaponCookie(class_index, weapon_slot_index), null)
                }
            }

            player.SendChat(CHAT_PREFIX + "Cleared override weapon selections.");
            player.Regenerate(true)
        }
    })
    DefineMenu(menu);
}
GenerateLoadoutMenu();

function GenerateClassSlotSelectMenu()
{
    foreach(i, name in TF_CLASSES)
    {
        local menu = class extends Menu{id = "loadout_" + name; menu_name = name; items = []};
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
            DefineMenu(class extends Menu{
                id = "loadout_" + name + "_" + slot;
                menu_name = slot
                _class_index = class_index + 1;
                _name = name;
                _slot = slot;
                _slot_id = slot_index;

                function constructor()
                {
                    GenerateLoadoutWeaponMenuItems(this);
                }
            });
        }
    }
}
GenerateClassWeaponSelectMenu();

::GenerateLoadoutWeaponMenuItems <- function(menu)
{
    menu.items = []

    menu.items.append(class extends MenuItem
    {
        class_id = menu._class_index;
        class_name = menu._name;
        slot_name = menu._slot;
        slot_id = (menu._name == "spy") ? LOADOUT_SLOT_IDS_SPY[menu._slot_id] : LOADOUT_SLOT_IDS[menu._slot_id];
        titles = ["Remove Override"];

        function GenerateDesc(player)
        {
            return "Remove the " + UpperFirst(class_name) + "'s " + slot_name + " override.";
        }

        function OnSelected(player)
        {
            player.UnequipWeaponInSlot(class_id, slot_id);
            player.SendChat(CHAT_PREFIX + "Removed the " + UpperFirst(class_name) + "'s " + slot_name + " override.");
        }
    }())
    foreach(weapon in FilterWeapons(menu._class_index, (menu._name == "spy") ? LOADOUT_SLOT_IDS_SPY[menu._slot_id] : LOADOUT_SLOT_IDS[menu._slot_id]))
    {
        if(safeget(weapon, "variant", false))
            continue;

        local weapon_menu_item = class extends MenuItem
        {
            class_id = menu._class_index;
            class_name = menu._name;
            slot_name = menu._slot;
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
                if(slot_id != WeaponSlot.InvisWatch)
                {
                    local offset = 0

                    if(player.GetPlayerClass() == TF_CLASS_SPY && slot_id == WeaponSlot.Secondary)
                        offset = 1;
                    if(player.GetPlayerClass() == TF_CLASS_SPY && slot_id == WeaponSlot.Melee)
                        offset = -2;

                    player.SetVar("priority_weapon_switch_slot", slot_id + offset);
                }
                player.SendChat(CHAT_PREFIX + "Equipped the " + titles[index] + " for " + UpperFirst(class_name) + "'s " + slot_name + " override.")
            }
        }()

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
}