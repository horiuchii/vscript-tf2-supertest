// BUTTONS
::CTFPlayer.GetButtons <- function()
{
    return GetPropInt(this, "m_nButtons");
}

::CTFPlayer.IsHoldingButton <- function(button)
{
    return GetButtons() & button;
}

::CTFPlayer.WasButtonJustPressed <- function(button)
{
    return !(GetVar("last_buttons") & button) && GetButtons() & button;
}

// VARIABLES
::CTFPlayer.SetVar <- function(name, value)
{
    local playerVars = this.GetScriptScope();
    playerVars[name] <- value;
    return value;
}

::CTFPlayer.GetVar <- function(name)
{
    local playerVars = this.GetScriptScope();
    try
    {
        return playerVars[name];
    }
    catch (exception)
    {
        printl("ERROR: Failed to get player var \"" + name + "\"");
        return null;
    }
}

::CTFPlayer.AddVar <- function(name, addValue)
{
    return SetVar(name, GetVar(name) + addValue);
}

::CTFPlayer.SubtractVar <- function(name, subtractValue)
{
    return SetVar(name, GetVar(name) - subtractValue);
}

::ignored_print_vars <- ["__vname", "__vrefs"];

::CTFPlayer.DrawDebugVars <- function()
{
    local playerVars = this.GetScriptScope();
    local line_offset = 0;
    foreach(variable, value in playerVars)
    {
        if(variable == null)
            continue;

        if(ignored_print_vars.find(variable) != null)
            continue;

        if(typeof value == "array")
            value = ArrayToStr(value)

        DebugDrawScreenTextLine(
            0.02, 0.17, line_offset++,
            variable + ": " + value,
            255, 255, 255, 255, 0.03
        );
    }
}

::DebugPrint <- function(message)
{
    if(DEBUG)
        printl(message)
}

::CTFPlayer.GetAccountID <- function()
{
    try
    {
        return split(GetPropString(this, "m_szNetworkIDString"), ":")[2].tointeger();
    }
    catch (exception)
    {
        return null;
    }
}

CTFPlayer.ForceTaunt <- function(taunt_id)
{
	local active_weapon = GetActiveWeapon()
	local weapon = CreateByClassname(active_weapon.GetClassname() == "tf_weapon_rocketpack" ? "tf_weapon_shotgun_pyro" : active_weapon.GetClassname())

	StopTaunt(true) // both are needed to fully clear the taunt
	RemoveCond(TF_COND_TAUNTING)

    if(weapon.GetClassname() == "tf_weapon_builder" || weapon.GetClassname() == "tf_weapon_sapper")
    {
        SetPropInt(weapon, "m_iObjectType", 3);
        SetPropInt(weapon, "m_iSubType", 3);
        SetPropInt(weapon, "m_iObjectMode", 0);
        SetPropBoolArray(weapon, "m_aBuildableObjectTypes", true, 3);
    }

	weapon.DispatchSpawn()
	SetPropInt(weapon, NETPROP_ITEMDEFINDEX, taunt_id)
	SetPropBool(weapon, NETPROP_INITIALIZED, true)
	SetPropBool(weapon, "m_bForcePurgeFixedupStrings", true)
	SetPropEntity(this, "m_hActiveWeapon", weapon)
    Weapon_Equip(weapon)
	SetPropInt(this, "m_iFOV", 0) // fix sniper rifles
	HandleTauntCommand(0)

    active_weapon.ValidateScriptScope();
    local wep_scriptscope = active_weapon.GetScriptScope();

    //if we are holding an override weapon, add ks mods so that eyes keep glowing
    if("override" in wep_scriptscope)
    {
        local ks_tier = Cookies.Get(this, "killstreak");
        if(ks_tier >= 1)
        {
            weapon.AddAttribute("killstreak tier", ks_tier, -1);

            if(ks_tier >= 2)
                weapon.AddAttribute("killstreak idleeffect", Cookies.Get(this, "killstreak_sheen"), -1);

            if(ks_tier >= 3)
                weapon.AddAttribute("killstreak effect", Cookies.Get(this, "killstreak_particle"), -1);
        }
    }

    SetVar("taunt_tick_listener", AddListener("tick_frame", 1, function(){
        if(!IsValid(active_weapon))
            RemoveListener(GetVar("taunt_tick_listener"))

        if(!InCond(TF_COND_TAUNTING))
        {
            SetPropEntity(this, "m_hActiveWeapon", active_weapon)
            KillIfValid(weapon)
            RemoveListener(GetVar("taunt_tick_listener"))
        }
    }))
}

::ParentEntity <- function(child, parent)
{
	if((!child || !child.IsValid()) || (!parent || !parent.IsValid()))
	{
		printl("ERROR: ParentEntity was called with a invalid entity, aborting! Child: " + child + " Parent: " + parent);
		return;
	}

	EntFireByHandle(child, "SetParent", "!activator", -1, parent, null);
}

//stolen from kstf2's regen script (https://github.com/kstf2/regen.nut/blob/main/regen.nut)
::CTFWeaponBase.SetReserveAmmo <- function(amount)
{
    if (this == null || this.GetOwner() == null || !this.GetOwner().IsPlayer()) return

    SetPropIntArray(this.GetOwner(), "m_iAmmo", amount, this.GetPrimaryAmmoType())
}

::CTFPlayer.PlaySoundForPlayer <- function(data, delay = 0)
{
    local base_table = {entity = this, filter_type = RECIPIENT_FILTER_SINGLE_PLAYER};

    if(safeget(data, "sound_name", null))
        PrecacheSound(safeget(data, "sound_name", null));

    if(delay)
        RunWithDelay(delay, function(){EmitSoundEx(combinetables(data, base_table));})
    else
        EmitSoundEx(combinetables(data, base_table));
}

::CTFPlayer.SendChat <- function(message)
{
    ClientPrint(this, HUD_PRINTTALK, message);
}

::SendChatAll <- function(message)
{
    ClientPrint(null, HUD_PRINTTALK, message);
}

::ArrayToStr <- function(value)
{
    local new_value = "[";
    foreach(i, array_var in value)
    {
        new_value += array_var + (i == value.len() - 1 ? "" : ", ");
    }
    new_value += "]";
    return new_value;
}

::UpperFirst <- function(string)
{
    local lower = string.slice(1);
    local upper = string.slice(0,1).toupper();
    return upper+lower;
}

::ToSnakecase <- function(string)
{
    local new_string = "";
    foreach(i, byte in string)
    {
        if(byte == '.' || byte == '\'')
            continue;

        if(byte == ' ')
        {
            new_string += "_"
        }
        else
            new_string += string[i].tochar()
    }
    return new_string.tolower();
}

::round <- function(value)
{
    return floor(value + 0.5);
}