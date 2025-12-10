::FormatWeaponCookie <- function(tfclass, slot)
{
    return "desired_" + TF_CLASSES[tfclass - 1] + "_" + slot.tostring();
}

for (local class_index = TF_CLASS_SCOUT; class_index < TF_CLASS_CIVILIAN; class_index++)
{
    for (local weapon_slot_index = WeaponSlot.Primary; weapon_slot_index < WeaponSlot.MAX; weapon_slot_index++)
    {
        if(weapon_slot_index == WeaponSlot.DisguiseKit)
            continue;

        if(weapon_slot_index == WeaponSlot.InvisWatch && class_index != TF_CLASS_SPY)
            continue;

        Cookies.AddCookie(FormatWeaponCookie(class_index, weapon_slot_index), "null");
    }
}

::IsWeaponValid <- function(weapon)
{
    return weapon && weapon != "null" && (weapon in WEAPONS);
}

::ConvertWeaponClassname <- function(class_index, classname)
{
    if(classname == "saxxy")
    {
        switch(class_index)
        {
            case TF_CLASS_SCOUT: classname = "tf_weapon_bat"; break;
            case TF_CLASS_SOLDIER: classname = "tf_weapon_shovel"; break;
            case TF_CLASS_PYRO: classname = "tf_weapon_fireaxe"; break;
            case TF_CLASS_DEMOMAN: classname = "tf_weapon_bottle"; break;
            case TF_CLASS_HEAVY: classname = "tf_weapon_fireaxe"; break;
            case TF_CLASS_ENGINEER: classname = "tf_weapon_wrench"; break;
            case TF_CLASS_MEDIC: classname = "tf_weapon_bonesaw"; break;
            case TF_CLASS_SNIPER: classname = "tf_weapon_club"; break;
            case TF_CLASS_SPY: classname = "tf_weapon_knife"; break;
        }
    }

    if(classname == "tf_weapon_shotgun")
    {
        switch(class_index)
        {
            case TF_CLASS_SOLDIER: classname = "tf_weapon_shotgun_soldier"; break;
            case TF_CLASS_PYRO: classname = "tf_weapon_shotgun_pyro"; break;
            case TF_CLASS_HEAVY: classname = "tf_weapon_shotgun_hwg"; break;
            case TF_CLASS_ENGINEER: classname = "tf_weapon_shotgun_primary"; break;
        }
    }

    if(classname == "tf_weapon_pistol")
    {
        switch(class_index)
        {
            case TF_CLASS_SCOUT: classname = "tf_weapon_pistol_scout"; break;
        }
    }

    return classname;
}

::CTFPlayer.UpdateReserveAmmoOnWeapon <- function(weapon)
{
    local ammo_type = weapon.GetPrimaryAmmoType();
    local tf_class = GetPlayerClass();

    if(ammo_type == -1)
        return;

    local max_ammo = CLASS_AMMO[tf_class][ammo_type]

    switch(ammo_type)
    {
        case TF_AMMO_PRIMARY:
        {
            local mult1 = weapon.GetAttribute("hidden primary max ammo bonus", 1);
            local mult2 = weapon.GetAttribute("maxammo primary increased", 1);
            local mult3 = weapon.GetAttribute("maxammo primary reduced", 1);

            max_ammo = (max_ammo * mult1 * mult2 * mult3);
            break;
        }
        case TF_AMMO_SECONDARY:
        {
            local mult1 = weapon.GetAttribute("hidden secondary max ammo penalty", 1);
            local mult2 = weapon.GetAttribute("maxammo secondary increased", 1);
            local mult3 = weapon.GetAttribute("maxammo secondary reduced", 1);

            max_ammo = (max_ammo * mult1 * mult2 * mult3);
            break;
        }
        case TF_AMMO_METAL:
        {
            local mult1 = weapon.GetAttribute("maxammo metal increased", 1);
            local mult2 = weapon.GetAttribute("maxammo metal reduced", 1);

            max_ammo = (max_ammo * mult1 * mult2);

            break;
        }
        case TF_AMMO_GRENADES1:
        {
            local mult1 = weapon.GetAttribute("maxammo grenades1 increased", 1);

            max_ammo = (max_ammo * mult1);

            break;
        }
    }

    if(InCond(TF_COND_RUNE_HASTE))
        max_ammo *= 2

    weapon.SetReserveAmmo(max_ammo)
}

::CTFPlayer.GetDesiredWeapon <- function(tfclass, slot)
{
    return Cookies.Get(this, FormatWeaponCookie(tfclass, slot))
}

::CTFPlayer.UnequipWeaponInSlot <- function(tfclass, slot)
{
    Cookies.Set(this, FormatWeaponCookie(tfclass, slot), "null");
    DebugPrint("set " + FormatWeaponCookie(tfclass, slot) + " to null")
    if(GetPlayerClass() == tfclass)
        Regenerate(true);
}
::TEST_UnequipWeaponInSlot <- function(slot)
    GetListenServerHost().UnequipWeaponInSlot(GetPlayerClass(), slot);

::CTFPlayer.EquipWeapon <- function(tfclass, desired_weapon)
{
    if(!desired_weapon || desired_weapon == "null" || !(desired_weapon in WEAPONS))
        return;

    local weapon_table = WEAPONS[desired_weapon];
    local slot = weapon_table.slot;
    Cookies.Set(this, FormatWeaponCookie(tfclass, slot), desired_weapon);
    DebugPrint("set " + FormatWeaponCookie(tfclass, slot) + " to " + desired_weapon)

    if(GetPlayerClass() == tfclass)
    {
        local weapon = null;
        Regenerate(true);
        return weapon;
    }

    return null;
}
::TEST_EquipWeapon <- function(desired_weapon)
    GetListenServerHost().EquipWeapon(GetPlayerClass(), desired_weapon);

::CTFPlayer.EquipDesiredWeapons <- function()
{
    if(!("weapon_wearables" in GetScriptScope()))
        SetVar("weapon_wearables", array(0, null))

    //remove all tf_wearable weapons in our scope
    for (local i = 0; i < GetVar("weapon_wearables").len(); i++)
    {
        if(GetVar("weapon_wearables")[i].IsValid())
        {
            GetVar("weapon_wearables")[i].ReapplyProvision()
            GetVar("weapon_wearables")[i].Kill()
        }
    }
    GetVar("weapon_wearables").clear()

    local switched_weapon = false;
    for (local weapon_slot_index = WeaponSlot.Primary; weapon_slot_index < WeaponSlot.MAX; weapon_slot_index++)
    {
        if(weapon_slot_index == WeaponSlot.DisguiseKit)
            continue;

        if(weapon_slot_index == WeaponSlot.InvisWatch && GetPlayerClass() != TF_CLASS_SPY)
            continue;

        local desired_weapon = GetDesiredWeapon(GetPlayerClass(), weapon_slot_index);

        if(!IsWeaponValid(desired_weapon))
        {
            DebugPrint("invalid wep in slot " + weapon_slot_index + " " + FormatWeaponCookie(GetPlayerClass(), weapon_slot_index))
            continue;
        }

        DebugPrint("giving weapon " + desired_weapon + " in slot " + weapon_slot_index  + " " + FormatWeaponCookie(GetPlayerClass(), weapon_slot_index))

        local weapon_table = WEAPONS[desired_weapon];

        if(weapon_table.classname.find("tf_wearable") != null)
            GiveCosmetic(desired_weapon, weapon_table.item_id)
        else
            GiveWeapon(desired_weapon, weapon_table.classname, ("item_id_override" in weapon_table) ? weapon_table.item_id_override : weapon_table.item_id);

        if(!switched_weapon && !(safeget(WEAPONS[desired_weapon], "unequipable", false)))
        {
            local wep_to_switch_to = null
            if(GetVar("priority_weapon_switch_slot") == weapon_slot_index)
            {
                wep_to_switch_to = GetWeaponBySlot(GetVar("priority_weapon_switch_slot"));
            }

            if(wep_to_switch_to)
            {
                Weapon_Switch(wep_to_switch_to)
                switched_weapon = true;
                DebugPrint("EQUIPPING EARLY: " + desired_weapon + " id: " + (GetVar("priority_weapon_switch_slot") != null ? GetVar("priority_weapon_switch_slot") : weapon_slot_index))
            }
        }
    }

    if(!switched_weapon)
    {
        DebugPrint("EQUIPPED LATE")
        Weapon_Switch(GetWeaponBySlot(GetVar("priority_weapon_switch_slot") != null ? GetVar("priority_weapon_switch_slot") : 0))
    }

    RunWithDelay(0.1, function()
    {
        SendGlobalGameEvent("localplayer_pickup_weapon", {})
    })
}

::CTFPlayer.GiveWeapon <- function(weapon_id, classname, item_id)
{
    local weapon = CreateByClassname(ConvertWeaponClassname(GetPlayerClass(), classname))

    weapon.ValidateScriptScope();
    local wep_scriptscope = weapon.GetScriptScope();
    wep_scriptscope["override"] <- true;

    SetPropInt(weapon, NETPROP_ITEMDEFINDEX, item_id)
    SetPropBool(weapon, NETPROP_INITIALIZED, true)
    SetPropBool(weapon, NETPROP_VALIDATED_ATTACHED, true)
    weapon.SetTeam(GetTeam())
    if("extra_code" in WEAPONS[weapon_id])
    {
        WEAPONS[weapon_id].extra_code(weapon);
    }

    if(GetWeaponIndexFlags(weapon_id) & FLAG_WARPAINT_AND_UNUSUAL)
    {
        local desired_skin = Cookies.Get(this, "skin");
        if(desired_skin != null && desired_skin != "null")
        {
            local skin_data = SKINS[desired_skin];
            switch(skin_data.type)
            {
                case SkinType.LegacySkin:
                {
                    if(item_id in skin_data.replacements)
                    {
                        SetPropInt(weapon, NETPROP_ITEMDEFINDEX, skin_data.replacements[item_id]);
                        DebugPrint("replaceing item id with " + skin_data.replacements[item_id] + " for skin id " + desired_skin)
                    }
                    break;
                }
                case SkinType.Warpaint:
                {
                    weapon.AddAttribute("paintkit_proto_def_index", casti2f(skin_data.index.tointeger()), -1);
                    break;
                }
            }

            weapon.AddAttribute("set_item_texture_wear", Cookies.Get(this, "wear"), -1);
            weapon.AddAttribute("custom_paintkit_seed_lo", casti2f(Cookies.Get(this, "seed_lo").tointeger()), -1);
            weapon.AddAttribute("custom_paintkit_seed_hi", casti2f(Cookies.Get(this, "seed_hi").tointeger()), -1);
        }

        local desired_unusual = Cookies.Get(this, "unusual");
        if(desired_unusual && (desired_unusual != WEAPON_UNUSUAL_ENERGYORB || GetWeaponIndexFlags(weapon_id) & FLAG_ACCEPTS_ENERGYORB))
            weapon.AddAttribute("attach particle effect", desired_unusual, -1);
    }

    if(Cookies.Get(this, "spells"))
    {
        weapon.AddAttribute("SPELL: Halloween pumpkin explosions", 1, -1);

        if(GetPlayerClass() == TF_CLASS_PYRO && weapon.GetSlot() == WeaponSlot.Primary)
            weapon.AddAttribute("SPELL: Halloween green flames", 1, -1);
    }

    if(Cookies.Get(this, "festivizer"))
    {
        weapon.AddAttribute("is_festivized", 1, -1);
    }

    if(Cookies.Get(this, "statclock"))
    {
        weapon.AddAttribute("kill eater", casti2f(0), -1);
    }

    local ks_tier = Cookies.Get(this, "killstreak");
    if(ks_tier >= 1)
    {
        weapon.AddAttribute("killstreak tier", ks_tier, -1);

        if(ks_tier >= 2)
            weapon.AddAttribute("killstreak idleeffect", Cookies.Get(this, "killstreak_sheen"), -1);

        if(ks_tier >= 3)
            weapon.AddAttribute("killstreak effect", Cookies.Get(this, "killstreak_particle"), -1);
    }

    if(classname == "tf_weapon_builder" || classname == "tf_weapon_sapper")
    {
        SetPropInt(weapon, "m_iObjectType", 3);
        SetPropInt(weapon, "m_iSubType", 3);
        SetPropInt(weapon, "m_iObjectMode", 0);
        SetPropBoolArray(weapon, "m_aBuildableObjectTypes", true, 3);
    }
    weapon.DispatchSpawn()

    // remove existing weapon in same slot
    for (local i = 0; i < MAX_WEAPONS; i++)
    {
        local heldWeapon = GetPropEntityArray(this, "m_hMyWeapons", i)
        if (heldWeapon == null)
            continue
        if (heldWeapon.GetSlot() != WEAPONS[weapon_id].slot)
            continue
        heldWeapon.Destroy()
        SetPropEntityArray(this, "m_hMyWeapons", null, i)
    }

    Weapon_Equip(weapon)

    weapon.ReapplyProvision()

    // remove existing wearables with the same slot
    local wearables_to_kill = [];
    for(local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        local wearable_index = GetPropInt(wearable, NETPROP_ITEMDEFINDEX);

        if(wearable.GetClassname().find("tf_wearable") == null)
            continue;

        if(!(wearable_index in WEARABLE_LOOKUP))
            continue;

        if(WEARABLE_LOOKUP[wearable_index].slot == WEAPONS[weapon_id].slot && GetVar("weapon_wearables").find(wearable) == null)
        {
            wearables_to_kill.append(wearable)
        }
    }
    for(local i = 0; i < wearables_to_kill.len(); i++)
    {
        wearables_to_kill[i].Kill()
    }

    if(item_id != 527 && item_id != 528)
        UpdateReserveAmmoOnWeapon(weapon)

    if(WEAPONS[weapon_id].slot == WeaponSlot.Secondary)
    {
        SetPropInt(this, "m_Shared.m_bShieldEquipped", 0)
    }

    return weapon;
}

::CTFPlayer.GiveCosmetic <- function(weapon_id, item_id)
{
	local weapon = CreateByClassname("tf_weapon_parachute")
	SetPropInt(weapon, NETPROP_ITEMDEFINDEX, 1101)
	SetPropBool(weapon, NETPROP_INITIALIZED, true)
	weapon.SetTeam(GetTeam())
	weapon.DispatchSpawn()
	Weapon_Equip(weapon)
	local wearable = GetPropEntity(weapon, "m_hExtraWearable")
	weapon.Kill()

	SetPropInt(wearable, NETPROP_ITEMDEFINDEX, item_id)
    SetPropBool(wearable, NETPROP_INITIALIZED, true)
	SetPropBool(wearable, NETPROP_VALIDATED_ATTACHED, true)
    SetPropString(wearable, "m_iClassname", WEAPONS[weapon_id].classname)
    if("extra_code" in WEAPONS[weapon_id])
    {
        WEAPONS[weapon_id].extra_code(wearable);
    }
	wearable.DispatchSpawn()

    // remove existing weapon in same slot
    for (local i = 0; i < MAX_WEAPONS; i++)
    {
        local heldWeapon = GetPropEntityArray(this, "m_hMyWeapons", i)
        if (heldWeapon == null)
            continue
        if (heldWeapon.GetSlot() != WEAPONS[weapon_id].slot)
            continue
        heldWeapon.Destroy()
        SetPropEntityArray(this, "m_hMyWeapons", null, i)
    }

	//recalculates bodygroups on the player
	SendGlobalGameEvent("post_inventory_application", { userid = GetUserID(), dont_reequip = true })

	GetVar("weapon_wearables").append(wearable)
    // remove existing wearables with the same item def index
    local wearables_to_kill = [];
    for(local wearable = FirstMoveChild(); wearable != null; wearable = wearable.NextMovePeer())
    {
        local wearable_index = GetPropInt(wearable, NETPROP_ITEMDEFINDEX);

        if(wearable.GetClassname().find("tf_wearable") == null)
            continue;

        if(!(wearable_index in WEARABLE_LOOKUP))
            continue;

        if((WEARABLE_LOOKUP[wearable_index].slot == WEAPONS[weapon_id].slot || wearable_index == item_id) && GetVar("weapon_wearables").find(wearable) == null)
        {
            wearables_to_kill.append(wearable)
        }
    }
    for(local i = 0; i < wearables_to_kill.len(); i++)
    {
        wearables_to_kill[i].Kill()
    }

    if(WEAPONS[weapon_id].slot == WeaponSlot.Secondary)
    {
        if(WEAPONS[weapon_id].classname == "tf_wearable_demoshield")
            SetPropInt(this, "m_Shared.m_bShieldEquipped", 1)
        else
            SetPropInt(this, "m_Shared.m_bShieldEquipped", 0)
    }

	return wearable
}

::FilterWeapons <- function(class_index, slot_index)
{
    local weapon_array = [];
    foreach(weaponidname, weapon in WEAPONS)
    {
        if(weapon.used_by_classes.find(class_index) != null && weapon.slot == slot_index)
        {
            local weapon_table = weapon;
            weapon_table.weapon_id <- weaponidname
            weapon_array.append(weapon_table);
        }
    }
    weapon_array.sort(function(a,b){return a.item_id <=> b.item_id;});
    return weapon_array;
}

::GetWeaponIndexFlags <- function(weapon_id)
    return safeget(WEAPONS[weapon_id], "flags", 0);

::WEP_BASE_SCATTERGUN <- {
    display_name = "Scattergun"
    classname = "tf_weapon_scattergun"
    item_id = 13,
    used_by_classes = [TF_CLASS_SCOUT]
    slot = WeaponSlot.Primary
}
::WEP_BASE_ROCKETLAUNCHER <- {
    display_name = "Rocket Launcher"
    classname = "tf_weapon_rocketlauncher"
    item_id = 18,
    used_by_classes = [TF_CLASS_SOLDIER]
    slot = WeaponSlot.Primary
}
::WEP_BASE_FLAMETHROWER <- {
    display_name = "Flame Thrower"
    classname = "tf_weapon_flamethrower"
    item_id = 21,
    used_by_classes = [TF_CLASS_PYRO]
    slot = WeaponSlot.Primary
}
::WEP_BASE_STICKYBOMBLAUNCHER <- {
    display_name = "Stickybomb Launcher"
    classname = "tf_weapon_pipebomblauncher"
    item_id = 20,
    used_by_classes = [TF_CLASS_DEMOMAN]
    slot = WeaponSlot.Secondary
}
::WEP_BASE_MINIGUN <- {
    display_name = "Minigun"
    classname = "tf_weapon_minigun"
    item_id = 15,
    used_by_classes = [TF_CLASS_HEAVY]
    slot = WeaponSlot.Primary
}
::WEP_BASE_WRENCH <- {
    display_name = "Wrench"
    classname = "tf_weapon_wrench"
    item_id = 7,
    used_by_classes = [TF_CLASS_ENGINEER]
    slot = WeaponSlot.Melee
}
::WEP_BASE_MEDIGUN <- {
    display_name = "Medi Gun"
    classname = "tf_weapon_medigun"
    item_id = 29,
    used_by_classes = [TF_CLASS_MEDIC]
    slot = WeaponSlot.Secondary
}
::WEP_BASE_SNIPERRIFLE <- {
    display_name = "Sniper Rifle"
    classname = "tf_weapon_sniperrifle"
    item_id = 14,
    used_by_classes = [TF_CLASS_SNIPER]
    slot = WeaponSlot.Primary
}
::WEP_BASE_KNIFE <- {
    display_name = "Knife"
    classname = "tf_weapon_knife"
    item_id = 4,
    used_by_classes = [TF_CLASS_SPY]
    slot = WeaponSlot.Melee
}

::WEAPONS <- {
    //MULTICLASS SECONDARY
    ["lugermorph"] = {
        display_name = "Lugermorph"
        classname = "tf_weapon_pistol"
        item_id = 294
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["capper"] = {
        display_name = "C.A.P.P.E.R."
        classname = "tf_weapon_pistol"
        item_id = 30666
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["reserve_shooter"] = {
        display_name = "Reserve Shooter"
        classname = "tf_weapon_shotgun"
        item_id = 415
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SOLDIER, TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    ["panic_attack"] = {
        display_name = "Panic Attack"
        classname = "tf_weapon_shotgun"
        item_id = 1153
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
    },
    ["panic_attack_engie"] = {
        display_name = "Panic Attack"
        classname = "tf_weapon_shotgun"
        item_id = 1153
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
    },
    //MULTICLASS MELEE
    ["envballs"] = {
        display_name = "Cubemap Balls"
        classname = "saxxy"
        item_id = -1
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_ENGINEER, TF_CLASS_MEDIC, TF_CLASS_SNIPER, TF_CLASS_SPY]
        slot = WeaponSlot.Melee
        variant = true
        extra_code = function(weapon)
        {
            PrecacheModel("models/shadertest/envballs.mdl")
            PrecacheModel("empty.mdl")
            weapon.SetModel("empty.mdl")
            weapon.SetCustomViewModel("models/shadertest/envballs.mdl")
        }
    },
    ["pan"] = {
        display_name = "Frying Pan"
        classname = "saxxy"
        item_id = 264
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["gold_pan"] = {
        display_name = "Golden Frying Pan"
        classname = "saxxy"
        item_id = 1071
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_ENGINEER, TF_CLASS_MEDIC, TF_CLASS_SNIPER, TF_CLASS_SPY]
        slot = WeaponSlot.Melee
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 0, -1);
            weapon.AddAttribute("loot rarity", 1, -1);
            weapon.AddAttribute("is australium item", 1, -1);
        }
    },
    ["katana"] = {
        display_name = "Half-Zatoichi"
        classname = "tf_weapon_katana"
        item_id = 357
        used_by_classes = [TF_CLASS_SOLDIER, TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    ["pain_train"] = {
        display_name = "Pain Train"
        classname = "tf_weapon_shovel"
        item_id = 154
        used_by_classes = [TF_CLASS_SOLDIER, TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    ["saxxy"] = {
        display_name = "Saxxy"
        classname = "saxxy"
        item_id = 423
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_ENGINEER, TF_CLASS_MEDIC, TF_CLASS_SNIPER, TF_CLASS_SPY]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["memory_maker"] = {
        display_name = "Memory Maker"
        classname = "saxxy"
        item_id = 954
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["bat_outta_hell"] = {
        display_name = "Bat Outta Hell (Universal)"
        classname = "saxxy"
        item_id = 939
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["bat_outta_hell_scout"] = {
        display_name = "Bat Outta Hell (Scout)"
        classname = "saxxy"
        item_id = 939
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 1, -1);
        }
    },
    ["bat_outta_hell_demo"] = {
        display_name = "Bat Outta Hell (Demoman)"
        classname = "saxxy"
        item_id = 939
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 2, -1);
        }
    },
    ["bat_outta_hell_soldier"] = {
        display_name = "Bat Outta Hell (Soldier)"
        classname = "saxxy"
        item_id = 939
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 3, -1);
        }
    },
    ["objector"] = {
        display_name = "Conscientious Objector"
        classname = "saxxy"
        item_id = 474
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["ham_shank"] = {
        display_name = "Ham Shank"
        classname = "saxxy"
        item_id = 1013
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["necro_smasher"] = {
        display_name = "Necro Smasher"
        classname = "saxxy"
        item_id = 1123
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_ENGINEER, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["freedom_staff"] = {
        display_name = "Freedom Staff"
        classname = "saxxy"
        item_id = 880
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["crossing_guard"] = {
        display_name = "Crossing Guard"
        classname = "saxxy"
        item_id = 1127
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_MEDIC, TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["prinny_knife"] = {
        display_name = "Prinny Machete"
        classname = "saxxy"
        item_id = 30758
        used_by_classes = [TF_CLASS_SCOUT, TF_CLASS_SOLDIER, TF_CLASS_PYRO, TF_CLASS_DEMOMAN, TF_CLASS_HEAVY, TF_CLASS_ENGINEER, TF_CLASS_MEDIC, TF_CLASS_SNIPER, TF_CLASS_SPY]
        slot = WeaponSlot.Melee
        variant = true
    },
    //SCOUT PRIMARY
    ["scattergun"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        item_id_override = 200
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_scattergun" "scattergun_festive" "silver_bk_scattergun_mk1" "gold_bk_scattergun_mk1" "rust_bk_scattergun_mk1" "blood_bk_scattergun_mk1" "carbonado_bk_scattergun_mk1" "diamond_bk_scattergun_mk1" "silver_bk_scattergun_mk2" "gold_bk_scattergun_mk2"]
    }),
    ["scattergun_festive"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Festive Scattergun"
        item_id = 669,
        variant = true
    }),
    ["silver_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Silver Botkiller Scattergun Mk.I"
        item_id = 799
        variant = true
    }),
    ["gold_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Gold Botkiller Scattergun Mk.I"
        item_id = 808
        variant = true
    }),
    ["rust_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Rust Botkiller Scattergun Mk.I"
        item_id = 888
        variant = true
    }),
    ["blood_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Blood Botkiller Scattergun Mk.I"
        item_id = 897
        variant = true
    }),
    ["carbonado_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Carbonado Botkiller Scattergun Mk.I"
        item_id = 906
        variant = true
    }),
    ["diamond_bk_scattergun_mk1"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Diamond Botkiller Scattergun Mk.I"
        item_id = 915
        variant = true
    }),
    ["silver_bk_scattergun_mk2"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Silver Botkiller Scattergun Mk.II"
        item_id = 964
        variant = true
    }),
    ["gold_bk_scattergun_mk2"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Gold Botkiller Scattergun Mk.II"
        item_id = 973
        variant = true
    }),
    ["force_a_nature"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Force-A-Nature"
        item_id = 45
        flags = FLAG_AUSTRAILIUM
        variants = ["aus_force_a_nature" "force_a_nature_festive"]
    }),
    ["force_a_nature_festive"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Festive Force-A-Nature"
        item_id = 1078
        variant = true
    }),
    ["shortstop"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Shortstop"
        classname = "tf_weapon_handgun_scout_primary"
        item_id = 220
        flags = FLAG_WARPAINT_AND_UNUSUAL
    }),
    ["soda_popper"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Soda Popper"
        classname = "tf_weapon_soda_popper"
        item_id = 448
        flags = FLAG_WARPAINT_AND_UNUSUAL
    }),
    ["baby_faces_blaster"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Baby Face's Blaster"
        classname = "tf_weapon_pep_brawler_blaster"
        item_id = 772
    }),
    ["back_scatter"] = combinetables(clone(WEP_BASE_SCATTERGUN), {
        display_name = "Back Scatter"
        item_id = 1103
    }),
    //SCOUT SECONDARY
    ["scout_pistol"] = {
        display_name = "Pistol"
        classname = "tf_weapon_pistol"
        item_id = 23
        item_id_override = 209
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variants = ["lugermorph" "capper"]
    },
    ["bonk"] = {
        display_name = "Bonk! Atomic Punch"
        classname = "tf_weapon_lunchbox_drink"
        item_id = 46
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variants = ["festive_bonk"]
    },
    ["festive_bonk"] = {
        display_name = "Festive Bonk! Atomic Punch"
        classname = "tf_weapon_lunchbox_drink"
        item_id = 1145
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["critacola"] = {
        display_name = "Crit-a-Cola"
        classname = "tf_weapon_lunchbox_drink"
        item_id = 163
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
    },
    ["milk"] = {
        display_name = "Mad Milk"
        classname = "tf_weapon_jar_milk"
        item_id = 222
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variants = ["mutated_milk"]
    },
    ["mutated_milk"] = {
        display_name = "Mutated Milk"
        classname = "tf_weapon_jar_milk"
        item_id = 1121
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["winger"] = {
        display_name = "Winger"
        classname = "tf_weapon_handgun_scout_secondary"
        item_id = 449
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
    },
    ["pocket_pistol"] = {
        display_name = "Pretty Boy's Pocket Pistol"
        classname = "tf_weapon_handgun_scout_secondary"
        item_id = 773
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
    },
    ["guillotine_thirsty"] = {
        display_name = "The Flying Guillotine (Thirsty)"
        classname = "tf_weapon_cleaver"
        item_id = 812
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variants = ["guillotine_thirstier"]
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 0, -1);
        }
    },
    ["guillotine_thirstier"] = {
        display_name = "The Flying Guillotine (Thirstier)"
        classname = "tf_weapon_cleaver"
        item_id = 812
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Secondary
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 1, -1);
        }
    },
    //SCOUT MELEE
    ["bat"] = {
        display_name = "Bat"
        classname = "tf_weapon_bat"
        item_id = 0
        item_id_override = 190
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variants = ["holy_mackerel" "holy_mackerel_festive" "unarmed_combat" "bat_festive" "batsaber" "pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["bat_festive"] = {
        display_name = "Festive Bat"
        classname = "tf_weapon_bat"
        item_id = 660
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["batsaber"] = {
        display_name = "Batsaber"
        classname = "tf_weapon_bat"
        item_id = 30667
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["holy_mackerel"] = {
        display_name = "Holy Mackerel"
        classname = "tf_weapon_bat_fish"
        item_id = 221
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["holy_mackerel_festive"] = {
        display_name = "Festive Holy Mackerel"
        classname = "tf_weapon_bat_fish"
        item_id = 999
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["unarmed_combat"] = {
        display_name = "Unarmed Combat"
        classname = "tf_weapon_bat_fish"
        item_id = 572
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["sandman"] = {
        display_name = "Sandman"
        classname = "tf_weapon_bat_wood"
        item_id = 44
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    ["candy_cane"] = {
        display_name = "Candy Cane"
        classname = "tf_weapon_bat"
        item_id = 317
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    ["boston_basher"] = {
        display_name = "Boston Basher"
        classname = "tf_weapon_bat"
        item_id = 325
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variants = ["three_rune_blade"]
    },
    ["three_rune_blade"] = {
        display_name = "Three-Rune Blade"
        classname = "tf_weapon_bat"
        item_id = 452
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["sun_on_a_stick"] = {
        display_name = "Sun-on-a-Stick"
        classname = "tf_weapon_bat"
        item_id = 349
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    ["fan_o_war"] = {
        display_name = "Fan O'War"
        classname = "tf_weapon_bat"
        item_id = 355
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    ["atomizer"] = {
        display_name = "Atomizer"
        classname = "tf_weapon_bat"
        item_id = 450
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    ["wrap_assassin"] = {
        display_name = "Wrap Assassin"
        classname = "tf_weapon_bat_giftwrap"
        item_id = 648
        used_by_classes = [TF_CLASS_SCOUT]
        slot = WeaponSlot.Melee
    },
    //SOLDIER PRIMARY
    ["rocketlauncher"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        item_id_override = 205
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_rocketlauncher" "rocketlauncher_festive" "valve_rocketlauncher" "silver_bk_rocketlauncher_mk1" "gold_bk_rocketlauncher_mk1" "rust_bk_rocketlauncher_mk1" "blood_bk_rocketlauncher_mk1" "carbonado_bk_rocketlauncher_mk1" "diamond_bk_rocketlauncher_mk1" "silver_bk_rocketlauncher_mk2" "gold_bk_rocketlauncher_mk2"]
    }),
    ["valve_rocketlauncher"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Valve Rocket Launcher"
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("attach particle effect", 2, -1);
            weapon.AddAttribute("damage bonus", 200, -1);
            weapon.AddAttribute("clip size bonus", 201, -1);
            weapon.AddAttribute("fire rate bonus", 0.25, -1);
            weapon.AddAttribute("heal on hit for slowfire", 250, -1);
            weapon.AddAttribute("critboost on kill", 10, -1);
            weapon.AddAttribute("Projectile speed increased", 1.5, -1);
            weapon.AddAttribute("critboost on kill", 10, -1);
            weapon.AddAttribute("move speed bonus", 2, -1);
            weapon.AddAttribute("max health additive bonus", 250, -1);
            weapon.AddAttribute("Reload time decreased", 0.25, -1);
            weapon.AddAttribute("maxammo primary increased", 200, -1);
        }
    }),
    ["rocketlauncher_festive"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Festive Rocket Launcher"
        item_id = 658,
        variant = true
    }),
    ["silver_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Silver Botkiller Rocket Launcher Mk.I"
        item_id = 800
        variant = true
    }),
    ["gold_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Gold Botkiller Rocket Launcher Mk.I"
        item_id = 809
        variant = true
    }),
    ["rust_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Rust Botkiller Rocket Launcher Mk.I"
        item_id = 889
        variant = true
    }),
    ["blood_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Blood Botkiller Rocket Launcher Mk.I"
        item_id = 898
        variant = true
    }),
    ["carbonado_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Carbonado Botkiller Rocket Launcher Mk.I"
        item_id = 907
        variant = true
    }),
    ["diamond_bk_rocketlauncher_mk1"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Diamond Botkiller Rocket Launcher Mk.I"
        item_id = 916
        variant = true
    }),
    ["silver_bk_rocketlauncher_mk2"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Silver Botkiller Rocket Launcher Mk.II"
        item_id = 965
        variant = true
    }),
    ["gold_bk_rocketlauncher_mk2"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Gold Botkiller Rocket Launcher Mk.II"
        item_id = 974
        variant = true
    }),
    ["direct_hit"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Direct Hit"
        classname = "tf_weapon_rocketlauncher_directhit"
        item_id = 127
    }),
    ["black_box"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Black Box"
        item_id = 228
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_AUSTRAILIUM)
        variants = ["aus_black_box" "black_box_festive"]
    }),
    ["black_box_festive"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Festive Black Box"
        item_id = 1085
        variant = true
    }),
    ["rocket_jumper"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Rocket Jumper"
        item_id = 237
    }),
    ["liberty_launcher"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Liberty Launcher"
        item_id = 414
    }),
    ["cow_mangler_5k"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Cow Mangler 5000"
        item_id = 441
        classname = "tf_weapon_particle_cannon"
    }),
    ["original"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Original"
        item_id = 513
    }),
    ["beggars_bazooka"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Beggar's Bazooka"
        item_id = 730
    }),
    ["air_strike"] = combinetables(clone(WEP_BASE_ROCKETLAUNCHER), {
        display_name = "Air Strike"
        flags = FLAG_WARPAINT_AND_UNUSUAL
        item_id = 1104
    }),
    //SOLDIER SECONDARY
    ["shotgun_soldier"] = {
        display_name = "Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 10
        item_id_override = 199
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
        variants = ["shotgun_soldier_festive"]
    },
    ["shotgun_soldier_festive"] = {
        display_name = "Festive Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 1141
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["buff_banner"] = {
        display_name = "Buff Banner"
        classname = "tf_weapon_buff_item"
        item_id = 129
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
        variants = ["buff_banner_festive"]
    },
    ["buff_banner_festive"] = {
        display_name = "Festive Buff Banner"
        classname = "tf_weapon_buff_item"
        item_id = 1001
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["gunboats"] = {
        display_name = "Gunboats"
        classname = "tf_wearable"
        item_id = 133
        unequipable = true
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    ["battalion_backup"] = {
        display_name = "Battalion's Backup"
        classname = "tf_weapon_buff_item"
        item_id = 226
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    ["conch"] = {
        display_name = "Concheror"
        classname = "tf_weapon_buff_item"
        item_id = 354
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    ["righteous_bison"] = {
        display_name = "Righteous Bison"
        classname = "tf_weapon_raygun"
        item_id = 442
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    ["mantreads"] = {
        display_name = "Mantreads"
        classname = "tf_wearable"
        item_id = 444
        unequipable = true
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    ["base_jumper_soldier"] = {
        display_name = "B.A.S.E. Jumper"
        classname = "tf_weapon_parachute"
        item_id = 1101
        unequipable = true
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Secondary
    },
    //SOLDIER MELEE
    ["shovel"] = {
        display_name = "Shovel"
        classname = "tf_weapon_shovel"
        item_id = 6
        item_id_override = 196
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Melee
        variants = ["pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["equalizer"] = {
        display_name = "Equalizer"
        classname = "tf_weapon_shovel"
        item_id = 128
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Melee
    },
    ["market_gardener"] = {
        display_name = "Market Gardener"
        classname = "tf_weapon_shovel"
        item_id = 416
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Melee
    },
    ["disciplinary_action"] = {
        display_name = "Disciplinary Action"
        classname = "tf_weapon_shovel"
        item_id = 447
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Melee
    },
    ["escape_plan"] = {
        display_name = "Escape Plan"
        classname = "tf_weapon_shovel"
        item_id = 775
        used_by_classes = [TF_CLASS_SOLDIER]
        slot = WeaponSlot.Melee
    },
    //PYRO PRIMARY
    ["flamethrower"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        item_id_override = 208
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_flamethrower" "flamethrower_festive" "rainblower" "nostromo_napalmer" "silver_bk_flamethrower_mk1" "gold_bk_flamethrower_mk1" "rust_bk_flamethrower_mk1" "blood_bk_flamethrower_mk1" "carbonado_bk_flamethrower_mk1" "diamond_bk_flamethrower_mk1" "silver_bk_flamethrower_mk2" "gold_bk_flamethrower_mk2"]
    }),
    ["flamethrower_festive"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Festive Flame Thrower"
        item_id = 659
        variant = true
    }),
    ["rainblower"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Rainblower"
        item_id = 741
        variant = true
    }),
    ["nostromo_napalmer"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Nostromo Napalmer"
        item_id = 30474
        variant = true
    }),
    ["silver_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Silver Botkiller Flame Thrower Mk.I"
        item_id = 798
        variant = true
    }),
    ["gold_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Gold Botkiller Flame Thrower Mk.I"
        item_id = 807
        variant = true
    }),
    ["rust_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Rust Botkiller Flame Thrower Mk.I"
        item_id = 887
        variant = true
    }),
    ["blood_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Blood Botkiller Flame Thrower Mk.I"
        item_id = 896
        variant = true
    }),
    ["carbonado_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Carbonado Botkiller Flame Thrower Mk.I"
        item_id = 905
        variant = true
    }),
    ["diamond_bk_flamethrower_mk1"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Diamond Botkiller Flame Thrower Mk.I"
        item_id = 914
        variant = true
    }),
    ["silver_bk_flamethrower_mk2"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Silver Botkiller Flame Thrower Mk.II"
        item_id = 963
        variant = true
    }),
    ["gold_bk_flamethrower_mk2"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Gold Botkiller Flame Thrower Mk.II"
        item_id = 972
        variant = true
    }),
    ["backburner"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Backburner"
        item_id = 40
        variants = ["backburner_festive"]
    }),
    ["backburner_festive"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Festive Backburner"
        item_id = 1146
        variant = true
    }),
    ["degreaser"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Degreaser"
        item_id = 215
        flags = FLAG_WARPAINT_AND_UNUSUAL
    }),
    ["phlog"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Phlogistinator"
        item_id = 594
    }),
    ["dragons_fury"] = combinetables(clone(WEP_BASE_FLAMETHROWER), {
        display_name = "Dragon's Fury"
        classname = "tf_weapon_rocketlauncher_fireball"
        item_id = 1178
        flags = FLAG_WARPAINT_AND_UNUSUAL
    }),
    //PYRO SECONDARY
    ["shotgun_pyro"] = {
        display_name = "Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 12
        item_id_override = 199
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
        variants = ["shotgun_pyro_festive"]
    },
    ["shotgun_pyro_festive"] = {
        display_name = "Festive Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 1141
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["flare_gun"] = {
        display_name = "Flare Gun"
        classname = "tf_weapon_flaregun"
        item_id = 39
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
        variants = ["flare_gun_festive"]
    },
    ["flare_gun_festive"] = {
        display_name = "Festive Flare Gun"
        classname = "tf_weapon_flaregun"
        item_id = 1081
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["detonator"] = {
        display_name = "Detonator"
        classname = "tf_weapon_flaregun"
        item_id = 351
        flags = (FLAG_WARPAINT_AND_UNUSUAL)
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    ["manmelter"] = {
        display_name = "Manmelter"
        classname = "tf_weapon_flaregun_revenge"
        item_id = 595
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    ["scorch_shot"] = {
        display_name = "Scorch Shot"
        classname = "tf_weapon_flaregun"
        item_id = 740
        flags = (FLAG_WARPAINT_AND_UNUSUAL)
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    ["thermal_thruster"] = {
        display_name = "Thermal Thruster"
        classname = "tf_weapon_rocketpack"
        item_id = 1179
        unequipable = true
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    ["gas_passer"] = {
        display_name = "Gas Passer"
        classname = "tf_weapon_jar_gas"
        item_id = 1180
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Secondary
    },
    //PYRO MELEE
    ["axe"] = {
        display_name = "Axe"
        classname = "tf_weapon_fireaxe"
        item_id = 2
        item_id_override = 192
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variants = ["lollichop" "pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["lollichop"] = {
        display_name = "Lollichop"
        classname = "tf_weapon_fireaxe"
        item_id = 739
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["axtinguisher"] = {
        display_name = "Axtinguisher"
        classname = "tf_weapon_fireaxe"
        item_id = 38
        used_by_classes = [TF_CLASS_PYRO]
        flags = (FLAG_AUSTRAILIUM)
        slot = WeaponSlot.Melee
        variants = ["aus_axtinguisher" "axtinguisher_festive" "postal_pummeler"]
    },
    ["axtinguisher_festive"] = {
        display_name = "Festive Axtinguisher"
        classname = "tf_weapon_fireaxe"
        item_id = 1000
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["postal_pummeler"] = {
        display_name = "Postal Pummeler"
        classname = "tf_weapon_fireaxe"
        item_id = 457
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["homewrecker"] = {
        display_name = "Homewrecker"
        classname = "tf_weapon_fireaxe"
        item_id = 153
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variants = ["maul"]
    },
    ["maul"] = {
        display_name = "Maul"
        classname = "tf_weapon_fireaxe"
        item_id = 466
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["powerjack"] = {
        display_name = "Powerjack"
        classname = "tf_weapon_fireaxe"
        item_id = 214
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    ["backscratcher"] = {
        display_name = "Back Scratcher"
        classname = "tf_weapon_fireaxe"
        item_id = 326
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    ["volcano_fragment"] = {
        display_name = "Sharpened Volcano Fragment"
        classname = "tf_weapon_fireaxe"
        item_id = 348
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    ["third_degree"] = {
        display_name = "Third Degree"
        classname = "tf_weapon_fireaxe"
        item_id = 593
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    ["neon_annihilator"] = {
        display_name = "Neon Annihilator"
        classname = "tf_weapon_breakable_sign"
        item_id = 813
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    ["hot_hand"] = {
        display_name = "Hot Hand"
        classname = "tf_weapon_slap"
        item_id = 1181
        used_by_classes = [TF_CLASS_PYRO]
        slot = WeaponSlot.Melee
    },
    //DEMO PRIMARY
    ["grenade_launcher"] = {
        display_name = "Grenade Launcher"
        classname = "tf_weapon_grenadelauncher"
        item_id = 19
        item_id_override = 206
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_AUSTRAILIUM)
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
        variants = ["aus_grenade_launcher" "grenade_launcher_festive"]
    },
    ["grenade_launcher_festive"] = {
        display_name = "Festive Grenade Launcher"
        classname = "tf_weapon_grenadelauncher"
        item_id = 1007
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["loch_n_load"] = {
        display_name = "Loch-n-Load"
        classname = "tf_weapon_grenadelauncher"
        item_id = 308
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
    },
    ["booties"] = {
        display_name = "Ali Baba's Wee Booties"
        classname = "tf_wearable"
        item_id = 405
        unequipable = true
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
        variants = ["bootlegger"]
    },
    ["bootlegger"] = {
        display_name = "Bootlegger"
        classname = "tf_wearable"
        item_id = 608
        unequipable = true
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["loose_cannon"] = {
        display_name = "Loose Cannon"
        classname = "tf_weapon_cannon"
        item_id = 996
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
    },
    ["base_jumper_demo"] = {
        display_name = "B.A.S.E. Jumper"
        classname = "tf_weapon_parachute"
        item_id = 1101
        unequipable = true
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
    },
    ["iron_bomber"] = {
        display_name = "Iron Bomber"
        classname = "tf_weapon_grenadelauncher"
        item_id = 1151
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Primary
    },
    //DEMO SECONDARY
    ["stickybomb_launcher"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        item_id_override = 207
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_stickybomb_launcher" "stickybomb_launcher_festive" "silver_bk_stickybomb_launcher_mk1" "gold_bk_stickybomb_launcher_mk1" "rust_bk_stickybomb_launcher_mk1" "blood_bk_stickybomb_launcher_mk1" "carbonado_bk_stickybomb_launcher_mk1" "diamond_bk_stickybomb_launcher_mk1" "silver_bk_stickybomb_launcher_mk2" "gold_bk_stickybomb_launcher_mk2"]
    }),
    ["stickybomb_launcher_festive"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Festive Stickybomb Launcher"
        item_id = 661,
        variant = true
    }),
    ["silver_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Silver Botkiller Stickybomb Launcher Mk.I"
        item_id = 797
        variant = true
    }),
    ["gold_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Gold Botkiller Stickybomb Launcher Mk.I"
        item_id = 806
        variant = true
    }),
    ["rust_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Rust Botkiller Stickybomb Launcher Mk.I"
        item_id = 886
        variant = true
    }),
    ["blood_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Blood Botkiller Stickybomb Launcher Mk.I"
        item_id = 895
        variant = true
    }),
    ["carbonado_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Carbonado Botkiller Stickybomb Launcher Mk.I"
        item_id = 904
        variant = true
    }),
    ["diamond_bk_stickybomb_launcher_mk1"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Diamond Botkiller Stickybomb Launcher Mk.I"
        item_id = 913
        variant = true
    }),
    ["silver_bk_stickybomb_launcher_mk2"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Silver Botkiller Stickybomb Launcher Mk.II"
        item_id = 962
        variant = true
    }),
    ["gold_bk_stickybomb_launcher_mk2"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Gold Botkiller Stickybomb Launcher Mk.II"
        item_id = 971
        variant = true
    }),
    ["scottish_resistance"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Scottish Resistance"
        item_id = 130
    }),
    ["chargein_targe"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Chargin' Targe"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 131
        variants = ["chargein_targe_festive"]
    }),
    ["chargein_targe_festive"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Festive Chargin' Targe"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 1144
        variant = true
    }),
    ["sticky_jumper"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Sticky Jumper"
        item_id = 265
    }),
    ["splendid_screen_classic"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Splendid Screen (Classic)"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 406
        variants = ["splendid_screen_spike" "splendid_screen_arrow" "splendid_screen_spikeandarrow"]
    }),
    ["splendid_screen_spike"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Splendid Screen (Spike)"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 406
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 1, -1);
        }
    }),
    ["splendid_screen_arrow"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Splendid Screen (Arrow)"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 406
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 2, -1);
        }
    }),
    ["splendid_screen_spikeandarrow"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Splendid Screen (Spike and Arrow)"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 406
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 3, -1);
        }
    }),
    ["tide_turner"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Tide Turner"
        classname = "tf_wearable_demoshield"
        unequipable = true
        item_id = 1099
    }),
    ["quickiebomb_launcher"] = combinetables(clone(WEP_BASE_STICKYBOMBLAUNCHER), {
        display_name = "Quickiebomb Launcher"
        item_id = 1150
    }),
    //DEMO MELEE
    ["bottle"] = {
        display_name = "Bottle"
        classname = "tf_weapon_bottle"
        item_id = 1
        item_id_override = 191
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variants = ["scottish_handshake" "pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["scottish_handshake"] = {
        display_name = "Scottish Handshake"
        classname = "tf_weapon_bottle"
        item_id = 609
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["eyelander"] = {
        display_name = "Eyelander"
        classname = "tf_weapon_sword"
        item_id = 132
        flags = FLAG_AUSTRAILIUM
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variants = ["aus_eyelander" "eyelander_festive" "hhh_headtaker" "nessie_nine_iron"]
    },
    ["eyelander_festive"] = {
        display_name = "Festive Eyelander"
        classname = "tf_weapon_sword"
        item_id = 1082
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["hhh_headtaker"] = {
        display_name = "Horseless Headless Horsemann's Headtaker"
        classname = "tf_weapon_sword"
        item_id = 266
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["nessie_nine_iron"] = {
        display_name = "Nessie's Nine Iron"
        classname = "tf_weapon_sword"
        item_id = 482
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["skullcutter"] = {
        display_name = "Scotsman's Skullcutter"
        classname = "tf_weapon_sword"
        item_id = 172
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    ["caber"] = {
        display_name = "Ullapool Caber"
        classname = "tf_weapon_stickbomb"
        item_id = 307
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    ["claidheamh_mor"] = {
        display_name = "Claidheamh Mòr"
        classname = "tf_weapon_sword"
        item_id = 327
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    ["persain_persuader"] = {
        display_name = "Persian Persuader"
        classname = "tf_weapon_sword"
        item_id = 404
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_DEMOMAN]
        slot = WeaponSlot.Melee
    },
    //HEAVY PRIMARY
    ["minigun"] = combinetables(clone(WEP_BASE_MINIGUN), {
        item_id_override = 202
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_minigun" "minigun_festive" "iron_curtain" "silver_bk_minigun_mk1" "gold_bk_minigun_mk1" "rust_bk_minigun_mk1" "blood_bk_minigun_mk1" "carbonado_bk_minigun_mk1" "diamond_bk_minigun_mk1" "silver_bk_minigun_mk2" "gold_bk_minigun_mk2"]
    }),
    ["minigun_festive"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Festive Minigun"
        item_id = 654,
        variant = true
    }),
    ["iron_curtain"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Iron Curtain"
        item_id = 298,
        variant = true
    }),
    ["silver_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Silver Botkiller Minigun Mk.I"
        item_id = 793
        variant = true
    }),
    ["gold_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Gold Botkiller Minigun Mk.I"
        item_id = 802
        variant = true
    }),
    ["rust_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Rust Botkiller Minigun Mk.I"
        item_id = 882
        variant = true
    }),
    ["blood_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Blood Botkiller Minigun Mk.I"
        item_id = 891
        variant = true
    }),
    ["carbonado_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Carbonado Botkiller Minigun Mk.I"
        item_id = 900
        variant = true
    }),
    ["diamond_bk_minigun_mk1"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Diamond Botkiller Minigun Mk.I"
        item_id = 909
        variant = true
    }),
    ["silver_bk_minigun_mk2"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Silver Botkiller Minigun Mk.II"
        item_id = 958
        variant = true
    }),
    ["gold_bk_minigun_mk2"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Gold Botkiller Minigun Mk.II"
        item_id = 967
        variant = true
    }),
    ["natascha"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Natascha"
        item_id = 41
    }),
    ["brass_beast"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Brass Beast"
        flags = FLAG_WARPAINT_AND_UNUSUAL
        item_id = 312
    }),
    ["tomislav"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Tomislav"
        flags = FLAG_AUSTRAILIUM | FLAG_WARPAINT_AND_UNUSUAL
        item_id = 424
        variants = ["aus_tomislav"]
    }),
    ["huo_long_heater"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Huo-Long Heater"
        item_id = 811
    }),
    ["deflector"] = combinetables(clone(WEP_BASE_MINIGUN), {
        display_name = "Deflector"
        item_id = 850
        extra_code = function(weapon)
        {
            weapon.AddAttribute("attack projectiles", 1, -1);
        }
    }),
    //HEAVY SECONDARY
    ["shotgun_heavy"] = {
        display_name = "Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 11
        item_id_override = 199
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variants = ["shotgun_heavy_festive"]
    },
    ["shotgun_heavy_festive"] = {
        display_name = "Festive Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 1141
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["sandvich"] = {
        display_name = "Sandvich"
        classname = "tf_weapon_lunchbox"
        item_id = 42
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variants = ["sandvich_festive" "sandvich_robo"]
    },
    ["sandvich_festive"] = {
        display_name = "Festive Sandvich"
        classname = "tf_weapon_lunchbox"
        item_id = 1002
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["sandvich_robo"] = {
        display_name = "Robo-Sandvich"
        classname = "tf_weapon_lunchbox"
        item_id = 863
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["dalokohs_bar"] = {
        display_name = "Dalokohs Bar"
        classname = "tf_weapon_lunchbox"
        item_id = 159
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variants = ["fishcake"]
    },
    ["fishcake"] = {
        display_name = "Fishcake"
        classname = "tf_weapon_lunchbox"
        item_id = 433
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["buffalo_steak"] = {
        display_name = "Buffalo Steak Sandvich"
        classname = "tf_weapon_lunchbox"
        item_id = 311
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
    },
    ["family_business"] = {
        display_name = "Family Business"
        classname = "tf_weapon_shotgun"
        item_id = 425
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
    },
    ["second_banana"] = {
        display_name = "Second Banana"
        classname = "tf_weapon_lunchbox"
        item_id = 1190
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Secondary
    },
    //HEAVY MELEE
    ["fists"] = {
        display_name = "Fists"
        classname = "tf_weapon_fists"
        item_id = 5
        item_id_override = 195
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
        variants = ["apoco_fists" "pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["apoco_fists"] = {
        display_name = "Apoco-Fists"
        classname = "tf_weapon_fists"
        item_id = 587
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["kgb"] = {
        display_name = "Killing Gloves of Boxing"
        classname = "tf_weapon_fists"
        item_id = 43
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
    },
    ["gru"] = {
        display_name = "Gloves of Running Urgently"
        classname = "tf_weapon_fists"
        item_id = 239
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
        variants = ["gru_festive" "gru_bread"]
    },
    ["gru_festive"] = {
        display_name = "Festive Gloves of Running Urgently"
        classname = "tf_weapon_fists"
        item_id = 1084
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["gru_bread"] = {
        display_name = "Bread Bite"
        classname = "tf_weapon_fists"
        item_id = 1100
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["warrior_spirit"] = {
        display_name = "Warrior's Spirit"
        classname = "tf_weapon_fists"
        item_id = 310
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
    },
    ["fists_of_steel"] = {
        display_name = "Fists of Steel"
        classname = "tf_weapon_fists"
        item_id = 331
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
    },
    ["eviction_notice"] = {
        display_name = "Eviction Notice"
        classname = "tf_weapon_fists"
        item_id = 426
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
    },
    ["holiday_punch"] = {
        display_name = "Holiday Punch"
        classname = "tf_weapon_fists"
        item_id = 656
        used_by_classes = [TF_CLASS_HEAVY]
        slot = WeaponSlot.Melee
    },
    //ENGIE PRIMARY
    ["shotgun_engie"] = {
        display_name = "Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 9
        item_id_override = 199
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
        variants = ["shotgun_engie_festive"]
    },
    ["shotgun_engie_festive"] = {
        display_name = "Festive Shotgun"
        classname = "tf_weapon_shotgun"
        item_id = 1141
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["frontier_justice"] = {
        display_name = "Frontier Justice"
        classname = "tf_weapon_sentry_revenge"
        item_id = 141
        flags = FLAG_AUSTRAILIUM
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
        variants = ["aus_frontier_justice" "frontier_justice_festive"]
    },
    ["frontier_justice_festive"] = {
        display_name = "Festive Frontier Justice"
        classname = "tf_weapon_sentry_revenge"
        item_id = 1004
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["widowmaker"] = {
        display_name = "Widowmaker"
        classname = "tf_weapon_shotgun"
        item_id = 527
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
    },
    ["pomson_6k"] = {
        display_name = "Pomson 6000"
        classname = "tf_weapon_drg_pomson"
        item_id = 588
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
    },
    ["rescue_ranger"] = {
        display_name = "Rescue Ranger"
        classname = "tf_weapon_shotgun_building_rescue"
        item_id = 997
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Primary
    },
    //ENGIE SECONDARY
    ["engie_pistol"] = {
        display_name = "Pistol"
        classname = "tf_weapon_pistol"
        item_id = 22
        item_id_override = 209
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB)
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variants = ["lugermorph" "capper"]
    },
    ["wrangler"] = {
        display_name = "Wrangler"
        classname = "tf_weapon_laser_pointer"
        item_id = 140
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variants = ["wrangler_festive" "gigar_counter"]
    },
    ["wrangler_festive"] = {
        display_name = "Festive Wrangler"
        classname = "tf_weapon_laser_pointer"
        item_id = 1086
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["gigar_counter"] = {
        display_name = "Giger Counter"
        classname = "tf_weapon_laser_pointer"
        item_id = 30668
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["short_circuit"] = {
        display_name = "Short Circuit"
        classname = "tf_weapon_mechanical_arm"
        item_id = 528
        used_by_classes = [TF_CLASS_ENGINEER]
        slot = WeaponSlot.Secondary
    },
    //ENGIE MELEE
    ["wrench"] = combinetables(clone(WEP_BASE_WRENCH), {
        item_id_override = 197
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_AUSTRAILIUM)
        variants = ["aus_wrench" "wrench_festive" "gold_wrench" "silver_bk_wrench_mk1" "gold_bk_wrench_mk1" "rust_bk_wrench_mk1" "blood_bk_wrench_mk1" "carbonado_bk_wrench_mk1" "diamond_bk_wrench_mk1" "silver_bk_wrench_mk2" "gold_bk_wrench_mk2" "gold_pan" "saxxy" "necro_smasher" "prinny_knife" "envballs"]
    }),
    ["wrench_festive"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Festive Wrench"
        item_id = 662,
        variant = true
    }),
    ["gold_wrench"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Golden Wrench"
        item_id = 169,
        variant = true
    }),
    ["silver_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Silver Botkiller Wrench Mk.I"
        item_id = 795
        variant = true
    }),
    ["gold_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Gold Botkiller Wrench Mk.I"
        item_id = 804
        variant = true
    }),
    ["rust_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Rust Botkiller Wrench Mk.I"
        item_id = 884
        variant = true
    }),
    ["blood_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Blood Botkiller Wrench Mk.I"
        item_id = 893
        variant = true
    }),
    ["carbonado_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Carbonado Botkiller Wrench Mk.I"
        item_id = 902
        variant = true
    }),
    ["diamond_bk_wrench_mk1"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Diamond Botkiller Wrench Mk.I"
        item_id = 911
        variant = true
    }),
    ["silver_bk_wrench_mk2"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Silver Botkiller Wrench Mk.II"
        item_id = 960
        variant = true
    }),
    ["gold_bk_wrench_mk2"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Gold Botkiller Wrench Mk.II"
        item_id = 969
        variant = true
    }),
    ["gunslinger"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Gunslinger"
        classname = "tf_weapon_robot_arm"
        item_id = 142
    }),
    ["southern_hospitality"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Southern Hospitality"
        item_id = 155
    }),
    ["jag"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Jag"
        item_id = 329
        flags = FLAG_WARPAINT_AND_UNUSUAL
    }),
    ["eureka_effect"] = combinetables(clone(WEP_BASE_WRENCH), {
        display_name = "Eureka Effect"
        item_id = 589
    }),
    //MEDIC PRIMARY
    ["syringe_gun"] = {
        display_name = "Syringe Gun"
        classname = "tf_weapon_syringegun_medic"
        item_id = 17
        item_id_override = 204
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Primary
    },
    ["blutsauger"] = {
        display_name = "Blutsauger"
        classname = "tf_weapon_syringegun_medic"
        item_id = 36
        flags = FLAG_AUSTRAILIUM
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Primary
        variants = ["aus_blutsauger"]
    },
    ["crusaders_crossbow"] = {
        display_name = "Crusader's Crossbow"
        classname = "tf_weapon_crossbow"
        item_id = 305
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Primary
        variants = ["crusaders_crossbow_festive"]
    },
    ["crusaders_crossbow_festive"] = {
        display_name = "Festive Crusader's Crossbow"
        classname = "tf_weapon_crossbow"
        item_id = 1079
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["overdose"] = {
        display_name = "Overdose"
        classname = "tf_weapon_syringegun_medic"
        item_id = 412
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Primary
    },
    //MEDIC SECONDARY
    ["medigun"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        item_id_override = 211
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_medigun" "medigun_festive" "silver_bk_medigun_mk1" "gold_bk_medigun_mk1" "rust_bk_medigun_mk1" "blood_bk_medigun_mk1" "carbonado_bk_medigun_mk1" "diamond_bk_medigun_mk1" "silver_bk_medigun_mk2" "gold_bk_medigun_mk2"]
    }),
    ["medigun_festive"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Festive Medi Gun"
        item_id = 663,
        variant = true
    }),
    ["silver_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Silver Botkiller Medi Gun Mk.I"
        item_id = 796
        variant = true
    }),
    ["gold_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Gold Botkiller Medi Gun Mk.I"
        item_id = 805
        variant = true
    }),
    ["rust_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Rust Botkiller Medi Gun Mk.I"
        item_id = 885
        variant = true
    }),
    ["blood_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Blood Botkiller Medi Gun Mk.I"
        item_id = 894
        variant = true
    }),
    ["carbonado_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Carbonado Botkiller Medi Gun Mk.I"
        item_id = 903
        variant = true
    }),
    ["diamond_bk_medigun_mk1"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Diamond Botkiller Medi Gun Mk.I"
        item_id = 912
        variant = true
    }),
    ["silver_bk_medigun_mk2"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Silver Botkiller Medi Gun Mk.II"
        item_id = 961
        variant = true
    }),
    ["gold_bk_medigun_mk2"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Gold Botkiller Medi Gun Mk.II"
        item_id = 970
        variant = true
    }),
    ["kritzkrieg"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Kritzkrieg"
        item_id = 35
    }),
    ["quickfix"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Quick-Fix"
        item_id = 411
    }),
    ["vaccinator"] = combinetables(clone(WEP_BASE_MEDIGUN), {
        display_name = "Vaccinator"
        item_id = 998
    }),
    //MEDIC MELEE
    ["bonesaw"] = {
        display_name = "Bonesaw"
        classname = "tf_weapon_bonesaw"
        item_id = 8
        item_id_override = 198
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
        variants = ["bonesaw_festive" "pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["bonesaw_festive"] = {
        display_name = "Festive Bonesaw"
        classname = "tf_weapon_bonesaw"
        item_id = 1143
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["ubersaw"] = {
        display_name = "Ubersaw"
        classname = "tf_weapon_bonesaw"
        item_id = 37
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
        variants = ["ubersaw_festive"]
    },
    ["ubersaw_festive"] = {
        display_name = "Festive Ubersaw"
        classname = "tf_weapon_bonesaw"
        item_id = 1003
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
        variant = true
    },
    ["vitasaw"] = {
        display_name = "Vita-Saw"
        classname = "tf_weapon_bonesaw"
        item_id = 173
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
    },
    ["amputator"] = {
        display_name = "Amputator"
        classname = "tf_weapon_bonesaw"
        item_id = 304
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
    },
    ["solemn_vow"] = {
        display_name = "Solemn Vow"
        classname = "tf_weapon_bonesaw"
        item_id = 413
        used_by_classes = [TF_CLASS_MEDIC]
        slot = WeaponSlot.Melee
    },
    //SNIPER PRIMARY
    ["sniperrifle"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        item_id_override = 201
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        variants = ["aus_sniperrifle" "sniperrifle_festive" "awperhand" "silver_bk_sniperrifle_mk1" "gold_bk_sniperrifle_mk1" "rust_bk_sniperrifle_mk1" "blood_bk_sniperrifle_mk1" "carbonado_bk_sniperrifle_mk1" "diamond_bk_sniperrifle_mk1" "silver_bk_sniperrifle_mk2" "gold_bk_sniperrifle_mk2"]
    }),
    ["sniperrifle_festive"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Festive Sniper Rifle"
        item_id = 664,
        variant = true
    }),
    ["awperhand"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "AWPer Hand"
        item_id = 851,
        variant = true
    }),
    ["silver_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Silver Botkiller Sniper Rifle Mk.I"
        item_id = 792
        variant = true
    }),
    ["gold_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Gold Botkiller Sniper Rifle Mk.I"
        item_id = 801
        variant = true
    }),
    ["rust_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Rust Botkiller Sniper Rifle Mk.I"
        item_id = 881
        variant = true
    }),
    ["blood_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Blood Botkiller Sniper Rifle Mk.I"
        item_id = 890
        variant = true
    }),
    ["carbonado_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Carbonado Botkiller Sniper Rifle Mk.I"
        item_id = 899
        variant = true
    }),
    ["diamond_bk_sniperrifle_mk1"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Diamond Botkiller Sniper Rifle Mk.I"
        item_id = 908
        variant = true
    }),
    ["silver_bk_sniperrifle_mk2"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Silver Botkiller Sniper Rifle Mk.II"
        item_id = 957
        variant = true
    }),
    ["gold_bk_sniperrifle_mk2"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Gold Botkiller Sniper Rifle Mk.II"
        item_id = 966
        variant = true
    }),
    ["huntsman"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Huntsman"
        classname = "tf_weapon_compound_bow"
        item_id = 56
        variants = ["huntsman_festive", "fortified_compound"]
    }),
    ["huntsman_festive"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Festive Huntsman"
        classname = "tf_weapon_compound_bow"
        item_id = 1005
        variant = true
    }),
    ["fortified_compound"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Fortified Compound"
        classname = "tf_weapon_compound_bow"
        item_id = 1092
        variant = true
    }),
    ["sydney_sleeper"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Sydney Sleeper"
        item_id = 230
    }),
    ["bazaar_bargain"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Bazaar Bargain"
        classname = "tf_weapon_sniperrifle_decap"
        flags = FLAG_WARPAINT_AND_UNUSUAL
        item_id = 402
    }),
    ["machina"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Machina"
        item_id = 526
        variants = ["shooting_star"]
    }),
    ["shooting_star"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Shooting Star"
        item_id = 30665
        variant = true
    }),
    ["hitmans_heatmaker"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Hitman's Heatmaker"
        item_id = 752
    }),
    ["classic_sniperrifle"] = combinetables(clone(WEP_BASE_SNIPERRIFLE), {
        display_name = "Classic"
        classname = "tf_weapon_sniperrifle_classic"
        item_id = 1098
    }),
    //SNIPER SECONDARY
    ["smg"] = {
        display_name = "SMG"
        classname = "tf_weapon_smg"
        item_id = 16
        item_id_override = 203
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB | FLAG_AUSTRAILIUM)
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
        variants = ["aus_smg" "smg_festive"]
    },
    ["smg_festive"] = {
        display_name = "Festive SMG"
        classname = "tf_weapon_smg"
        item_id = 1149
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["razorback"] = {
        display_name = "Razorback"
        classname = "tf_wearable_razorback"
        item_id = 57
        unequipable = true
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
    },
    ["jarate"] = {
        display_name = "Jarate"
        classname = "tf_weapon_jar"
        item_id = 58
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
        variants = ["jarate_festive" "jarate_alien"]
    },
    ["jarate_festive"] = {
        display_name = "Festive Jarate"
        classname = "tf_weapon_jar"
        item_id = 1083
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["jarate_alien"] = {
        display_name = "Self-Aware Beauty Mark"
        classname = "tf_weapon_jar"
        item_id = 1105
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["darwin_danger_shield"] = {
        display_name = "Darwin's Danger Shield"
        classname = "tf_wearable"
        item_id = 231
        unequipable = true
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
    },
    ["cozy_camper"] = {
        display_name = "Cozy Camper"
        classname = "tf_wearable"
        item_id = 642
        unequipable = true
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
    },
    ["cleaners_carbine"] = {
        display_name = "Cleaner's Carbine"
        classname = "tf_weapon_charged_smg"
        item_id = 751
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Secondary
    },
    //SNIPER MELEE
    ["kukri"] = {
        display_name = "Kukri"
        classname = "tf_weapon_club"
        item_id = 3
        item_id_override = 193
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
        variants = ["pan" "gold_pan" "saxxy" "memory_maker" "bat_outta_hell" "bat_outta_hell_scout" "bat_outta_hell_demo" "bat_outta_hell_soldier" "objector" "ham_shank" "necro_smasher" "freedom_staff" "crossing_guard" "prinny_knife" "envballs"]
    },
    ["tribalman_shiv"] = {
        display_name = "Tribalman's Shiv"
        classname = "tf_weapon_club"
        item_id = 171
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
    },
    ["bushwacka"] = {
        display_name = "Bushwacka"
        classname = "tf_weapon_club"
        item_id = 232
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
    },
    ["shahanshah"] = {
        display_name = "Shahanshah"
        classname = "tf_weapon_club"
        item_id = 401
        flags = FLAG_WARPAINT_AND_UNUSUAL
        used_by_classes = [TF_CLASS_SNIPER]
        slot = WeaponSlot.Melee
    },
    //SPY SECONDARY
    ["revolver"] = {
        display_name = "Revolver"
        classname = "tf_weapon_revolver"
        item_id = 24
        item_id_override = 210
        flags = FLAG_WARPAINT_AND_UNUSUAL | FLAG_ACCEPTS_ENERGYORB
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
        variants = ["revolver_festive" "big_kill"]
    },
    ["revolver_festive"] = {
        display_name = "Festive Revolver"
        classname = "tf_weapon_revolver"
        item_id = 1142
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["big_kill"] = {
        display_name = "Big Kill"
        classname = "tf_weapon_revolver"
        item_id = 161
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["ambassador"] = {
        display_name = "Ambassador"
        classname = "tf_weapon_revolver"
        item_id = 61
        flags = FLAG_AUSTRAILIUM
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
        variants = ["aus_ambassador" "ambassador_festive"]
    },
    ["ambassador_festive"] = {
        display_name = "Festive Ambassador"
        classname = "tf_weapon_revolver"
        item_id = 1006
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
        variant = true
    },
    ["letranger"] = {
        display_name = "L'Etranger"
        classname = "tf_weapon_revolver"
        item_id = 224
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
    },
    ["enforcer"] = {
        display_name = "Enforcer"
        classname = "tf_weapon_revolver"
        item_id = 460
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
    },
    ["diamondback"] = {
        display_name = "Diamondback"
        classname = "tf_weapon_revolver"
        item_id = 525
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Primary
    },
    //SPY MELEE
    ["knife"] = combinetables(clone(WEP_BASE_KNIFE), {
        item_id_override = 194
        flags = (FLAG_WARPAINT_AND_UNUSUAL | FLAG_AUSTRAILIUM)
        variants = ["aus_knife" "knife_festive" "sharp_dresser" "blackrose_teamcolor" "blackrose_baccara" "silver_bk_knife_mk1" "gold_pan" "saxxy" "prinny_knife" "gold_bk_knife_mk1" "rust_bk_knife_mk1" "blood_bk_knife_mk1" "carbonado_bk_knife_mk1" "diamond_bk_knife_mk1" "silver_bk_knife_mk2" "gold_bk_knife_mk2" "envballs"]
    }),
    ["knife_festive"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Festive Knife"
        item_id = 665,
        variant = true
    }),
    ["sharp_dresser"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Sharp Dresser"
        item_id = 638,
        variant = true
    }),
    ["blackrose_teamcolor"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Black Rose (Mystery and True Love)"
        item_id = 727,
        variant = true
    }),
    ["blackrose_baccara"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Black Rose (Baccara)"
        item_id = 727,
        variant = true
        extra_code = function(weapon)
        {
            weapon.AddAttribute("item style override", 1, -1);
        }
    }),
    ["silver_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Silver Botkiller Knife Mk.I"
        item_id = 794
        variant = true
    }),
    ["gold_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Gold Botkiller Knife Mk.I"
        item_id = 803
        variant = true
    }),
    ["rust_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Rust Botkiller Knife Mk.I"
        item_id = 883
        variant = true
    }),
    ["blood_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Blood Botkiller Knife Mk.I"
        item_id = 892
        variant = true
    }),
    ["carbonado_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Carbonado Botkiller Knife Mk.I"
        item_id = 901
        variant = true
    }),
    ["diamond_bk_knife_mk1"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Diamond Botkiller Knife Mk.I"
        item_id = 910
        variant = true
    }),
    ["silver_bk_knife_mk2"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Silver Botkiller Knife Mk.II"
        item_id = 959
        variant = true
    }),
    ["gold_bk_knife_mk2"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Gold Botkiller Knife Mk.II"
        item_id = 968
        variant = true
    }),
    ["gold_bk_knife_mk2"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Gold Botkiller Knife Mk.II"
        item_id = 968
        variant = true
    }),
    ["eternal_reward"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Eternal Reward"
        item_id = 225
        variants = ["wanga_prick"]
    }),
    ["wanga_prick"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Wanga Prick"
        item_id = 574
        variant = true
    }),
    ["kunai"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Conniver's Kunai"
        item_id = 356
    }),
    ["big_earner"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Big Earner"
        item_id = 461
    }),
    ["spycicle"] = combinetables(clone(WEP_BASE_KNIFE), {
        display_name = "Spy-cicle"
        item_id = 649
    }),
    //SPY WATCH
    ["invis_watch"] = {
        display_name = "Invis Watch"
        classname = "tf_weapon_invis"
        item_id = 30
        unequipable = true
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.InvisWatch
        variants = ["timepiece_watch" "quackenbirdt_watch"]
    },
    ["timepiece_watch"] = {
        display_name = "Enthusiast's Timepiece"
        classname = "tf_weapon_invis"
        item_id = 297
        unequipable = true
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.InvisWatch
        variant = true
    },
    ["quackenbirdt_watch"] = {
        display_name = "Quackenbirdt"
        classname = "tf_weapon_invis"
        item_id = 947
        unequipable = true
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.InvisWatch
        variant = true
    },
    ["dead_ringer"] = {
        display_name = "Dead Ringer"
        classname = "tf_weapon_invis"
        item_id = 59
        unequipable = true
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.InvisWatch
    },
    ["cloak_and_dagger"] = {
        display_name = "Cloak and Dagger"
        classname = "tf_weapon_invis"
        item_id = 60
        unequipable = true
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.InvisWatch
    },
    //SPY SAPPER
    ["sapper"] = {
        display_name = "Sapper"
        classname = "tf_weapon_builder"
        item_id = 736
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Secondary
        variants = ["sapper_festive" "ap_sap" "snack_attack"]
    },
    ["sapper_festive"] = {
        display_name = "Festive Sapper"
        classname = "tf_weapon_sapper"
        item_id = 1080
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["ap_sap"] = {
        display_name = "Ap-Sap"
        classname = "tf_weapon_sapper"
        item_id = 933
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["snack_attack"] = {
        display_name = "Snack Attack"
        classname = "tf_weapon_sapper"
        item_id = 1102
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Secondary
        variant = true
    },
    ["red_tape_sapper"] = {
        display_name = "Red-Tape Recorder"
        classname = "tf_weapon_sapper"
        item_id = 810
        used_by_classes = [TF_CLASS_SPY]
        slot = WeaponSlot.Secondary
    },
}

::WEARABLE_LOOKUP <- {};

::CreateWearableReverseLookups <- function()
{
    foreach(weapon_id, weapon_table in WEAPONS)
    {
        if(weapon_table.classname.find("tf_wearable") == null)
            continue;

        WEARABLE_LOOKUP[weapon_table.item_id] <- clone(weapon_table);
    }
}
CreateWearableReverseLookups()

::STOCK_LOOKUP <- {};

//for skins to look through, stupid but works for now
::CreateStockWeaponReverseLookups <- function()
{
    foreach(weapon_id, weapon_table in WEAPONS)
    {
        if(!("item_id_override" in weapon_table))
            continue;

        STOCK_LOOKUP[weapon_table.item_id_override] <- clone(weapon_table);
    }
}
CreateStockWeaponReverseLookups()
::LookupStockFromSingularReplacementTable <- function(table)
{
    foreach(weapon_index, weapon_table in STOCK_LOOKUP)
    {
        if(weapon_index in table)
            return weapon_table.display_name;
    }
}


::CreateFlagWeaponVariantIndexes <- function()
{
    local variant_wep_table = {};

    foreach(weapon_id, weapon_table in WEAPONS)
    {
        if(GetWeaponIndexFlags(weapon_id) & FLAG_AUSTRAILIUM)
        {
            variant_wep_table["aus_" + weapon_id] <- combinetables(clone(weapon_table), {
                display_name = "Australium " + weapon_table.display_name
                variant = true
                flags = weapon_table.flags & FLAG_WARPAINT_AND_UNUSUAL ? weapon_table.flags - FLAG_WARPAINT_AND_UNUSUAL : weapon_table.flags
                extra_code = function(weapon)
                {
                    weapon.AddAttribute("item style override", 1, -1);
                    weapon.AddAttribute("loot rarity", 1, -1);
                    weapon.AddAttribute("is australium item", 1, -1);
                }
            })
        }
    }

    WEAPONS = combinetables(clone(WEAPONS), variant_wep_table)
}
CreateFlagWeaponVariantIndexes()