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
    return playerVars[name];
}

::CTFPlayer.AddVar <- function(name, addValue)
{
    local playerVars = this.GetScriptScope();
    local value = playerVars[name];
    return playerVars[name] <- value + addValue;
}

::CTFPlayer.SubtractVar <- function(name, subtractValue)
{
    local playerVars = this.GetScriptScope();
    local value = playerVars[name];
    return playerVars[name] <- value - subtractValue;
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
	SetPropInt(weapon, "m_AttributeManager.m_Item.m_iItemDefinitionIndex", taunt_id)
	SetPropBool(weapon, "m_AttributeManager.m_Item.m_bInitialized", true)
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

::CTFPlayer.CreateInstancedProp <- function(model)
{
    PrecacheModel(model);
    local prop = CreateByClassname("obj_teleporter"); // not using SpawnEntityFromTable as that creates spawning noises
    prop.DispatchSpawn();

    prop.AddEFlags(EFL_NO_THINK_FUNCTION); // prevents the entity from disappearing
    SetPropBool(prop, "m_bPlacing", true);
    SetPropInt(prop, "m_fObjectFlags", 2); // sets "attachment" flag, prevents entity being snapped to player feet
    SetPropEntity(prop, "m_hBuilder", this);

    prop.SetModel(model);
    prop.KeyValueFromInt("disableshadows", 1);

    return prop;
}

::CTFPlayer.RemoveInstancedProps <- function()
{
    local entity = null
    while(entity = FindByClassname(entity, "obj_teleporter"))
    {
        if(GetPropEntity(entity, "m_hBuilder") == this)
            entity.Destroy();
    }
}

::ConstructTwoDimArray <- function(size1, size2, default_value)
{
	local return_array = array(size1);
	for(local i = 0; i < size1; i++)
		return_array[i] = array(size2, default_value);

	return return_array;
}

::ParentEntity <- function(child, parent)
{
	if((!child || !child.IsValid()) || (!parent || !parent.IsValid()))
	{
		DebugPrint("ERROR: ParentEntity was called with a invalid entity, aborting! Child: " + child + " Parent: " + parent);
		return;
	}

    child.AcceptInput("SetParent", "!activator", parent, null);
}

::VLerp <- function(a,b,t)
{
    return (a + (b - a) * t)
}

::deg <- function(radians)
{
    return radians * (180.0 / PI);
}

::is_zero_approx <- function(v)
{
    return fabs(v) < Epsilon
}

::is_equal_approx <- function(a, b)
{
    if(a == b)
        return true;

    local tolerance = Epsilon * abs(a);
    if(tolerance < Epsilon)
        tolerance = Epsilon;
    return abs(a - b) < tolerance;
}

::wrapf <- function(v, min, max)
{
    local range = max - min;
    if(is_zero_approx(range))
        return min;

    local result = v - (range * floor((v - min) / range));
    if(is_equal_approx(result, max))
        return min;

    return result;
}

::sign <- function(val)
{
    return (0 < val).tointeger() - (val < 0).tointeger()
}

::move_towards_angle <- function(from, to, delta)
{
    local diff = (to - from + 540) % 360 - 180;
    if (fabs(diff) <= delta)
        return to;
    return from + sign(diff) * delta;
}


::move_towards <- function(from, to, delta)
{
    return fabs(to - from) <= delta ? to : from + sign(to - from) * delta
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

::round <- function(val, decimalPoints)
{
	local f = pow(10, decimalPoints) * 1.0;
	local newVal = val * f;
	newVal = floor(newVal + 0.5);
	newVal = (newVal * 1.0) / f;

	return newVal;
}

::RotateVector <- function(origin, rotation, input)
{
    input -= origin;
    input = RotatePosition(origin, rotation, input);
    return input += origin;
}

::RotateVectorDirectDegrees <- function(vector, degrees)
{
    local radians = degrees * (PI / 180.0);
    local cos_angle = cos(radians);
    local sin_angle = sin(radians);

    local new_x = vector.x * cos_angle - vector.y * sin_angle;
    local new_y = vector.x * sin_angle - vector.y * cos_angle;

    return Vector(new_x, new_y, vector.z);
}

::TicksToTime <- function(ticks)
{
    return ticks * TICKRATE_TIME;
}

::FormatTime <- function(input_time)
{
	local input_time_type = type(input_time);

	if(input_time_type == "integer")
	{
		local Min = input_time / 60;
		local Sec = input_time - (Min * 60);
		local SecString = format("%s%i", Sec < 10 ? "0" : "", Sec);
		return (Min + ":" + SecString).tostring();
	}

	if(input_time_type == "float")
	{
		local timedecimal = split((round(input_time - input_time.tointeger(), 3)).tostring(), ".");
		local Min = input_time.tointeger() / 60;
		local Sec = input_time.tointeger() - (Min * 60);
		local SecString = format("%s%i", Sec < 10 ? "0" : "", Sec);
		return (Min + ":" + SecString + "." + (timedecimal.len() == 1 ? "000" : timedecimal[1].len() == 1 ? timedecimal[1].tostring() + "0" : timedecimal[1].tostring())).tostring();
	}

	return input_time.tostring();
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

::CombineInt32ToInt64 <- function(high, low)
{
    return (high << 32) | (low & 0xFFFFFFFF);
}

::Convert32BitTo64Bit <- function(value32) {
    // Shift the 32-bit value left by 32 bits
    local value64 = value32 << 32;
    return value64;
}

::IsAtleastOne <- function(comparee, array)
{
    foreach(comparison in array)
    {
        if(comparee == comparison)
            return true;
    }

    return false;
}