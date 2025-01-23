//This class is the most likely to change, as API_GetString("myKey") isn't a neat way to access the values.

//================================
//Exposed Functions.
//Intended for use by your code.
//================================

::API_GetString <- function(key)
{
    if (key in API_VALUES)
        return API_VALUES[key];
    return API_DEF_VALUES[key];
}

::API_GetInt <- function(key)
{
    if (key in API_VALUES)
        try { return API_VALUES[key].tointeger(); } catch(e) { }
    return API_DEF_VALUES[key].tointeger();
}

::API_GetBool <- function(key)
{
    if (key in API_VALUES)
    {
        if (API_VALUES[key] == "true")
            return true;
        else if (API_VALUES[key] == "false")
            return false;
        return API_GetInt(key) > 0;
    }
    else
    {
        if (API_DEF_VALUES[key] == "true")
            return true;
        else if (API_DEF_VALUES[key] == "false")
            return false;
    }
    return API_GetInt(key) > 0;
}

::API_GetFloat <- function(key)
{
    if (key in API_VALUES)
        try { return API_VALUES[key].tofloat(); } catch(e) { }
    return API_DEF_VALUES[key].tofloat();
}

//==============================
//Internal Functions.
//==============================

if (!("API_DEF_VALUES" in getroottable()))
    ::API_DEF_VALUES <- {};

::API_VALUES <- {};

for (local configEnt = null; configEnt = Entities.FindByName(configEnt, "api_config");)
{
    local key = "error";
    for (local i = 0; i < 63; i++)
    {
        local entry = strip(GetPropString(configEnt, "m_iszControlPointNames["+i+"]"));
        if (entry.len() == 0)
            continue;
        if (i % 2 == 0)
            key = entry;
        else
            API_VALUES[key] <- entry;
    }
}