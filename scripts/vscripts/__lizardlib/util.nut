::isRoundSetup <- true;

::IsRoundSetup <- function()
{
    return isRoundSetup;
}

OnGameEvent("teamplay_setup_finished", function()
{
    isRoundSetup = false;
});

::CreateAoE <- function(origin, radius, applyFunc)
{
    foreach(target in GetAlivePlayers())
    {
        local normalVector = target.GetOrigin() - origin;
        local distance = normalVector.Norm();
        if (distance <= radius)
            applyFunc(target, normalVector, distance);
    }

    for (local target = null; target = Entities.FindByClassname(target, "obj_*");)
    {
        local normalVector = target.GetOrigin() - origin;
        local distance = normalVector.Norm();
        if (distance <= radius)
            applyFunc(target, normalVector, distance);
    }
}

::CreateAoEAABB <- function(origin, min, max, applyFunc)
{
    local min = origin + min;
    local max = origin + max;
    foreach(target in GetAlivePlayers())
    {
        local targetOrigin = target.GetCenter();
        if (targetOrigin.x >= min.x
            && targetOrigin.y >= min.y
            && targetOrigin.z >= min.z
            && targetOrigin.x <= max.x
            && targetOrigin.y <= max.y
            && targetOrigin.z <= max.z)
            {
                local normalVector = targetOrigin - origin;
                applyFunc(target, normalVector, normalVector.Norm());
            }
    }

    for (local target = null; target = Entities.FindByClassname(target, "obj_*");)
    {
        local targetOrigin = target.GetCenter();
        if (targetOrigin.x >= min.x
            && targetOrigin.y >= min.y
            && targetOrigin.z >= min.z
            && targetOrigin.x <= max.x
            && targetOrigin.y <= max.y
            && targetOrigin.z <= max.z)
            {
                local normalVector = targetOrigin - origin;
                applyFunc(target, normalVector, normalVector.Norm());
            }
    }
}

::clampCeiling <- function(valueA, valueB)
{
    if (valueA < valueB)
        return valueA;
    return valueB;
}
::min <- clampCeiling;

::clampFloor <- function(valueA, valueB)
{
    if (valueA > valueB)
        return valueA;
    return valueB;
}
::max <- clampFloor;

::clamp <- function(value, min, max)
{
    if (max < min)
    {
        local tmp = min;
        min = max;
        max = tmp;
    }
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}

::remapclamped <- function(value, inA, inB, outA, outB)
{
    if(inA == inB)
        return value >= inB ? outB : outA;
    local cVal = (value - inA) / (inB - inA);
    cVal = clamp(cVal, 0, 1);

    return outA + (outB - outA) * cVal;
}

::safeget <- function(table, field, defValue)
{
    return table && field in table ? table[field] : defValue;
}

::SetPersistentVar <- function(name, value)
{
    local persistentVars = tf_gamerules.GetScriptScope();
    persistentVars[name] <- value;
}

::GetPersistentVar <- function(name, defValue = null)
{
    local persistentVars = tf_gamerules.GetScriptScope();
    return name in persistentVars ? persistentVars[name] : defValue;
}

::SetEntityColor <- function(entity, rgba)
{
    local color = rgba[0] | (rgba[1] << 8) | (rgba[2] << 16) | (rgba[3] << 24);
    SetPropInt(entity, "m_clrRender", color);
}

::ShuffleArray <- function(array)
{
    local currentIndex = array.len() - 1;
    local swap;
    local randomIndex;

    while (currentIndex > 0)
    {
        randomIndex = RandomInt(0, currentIndex);
        currentIndex -= 1;

        swap = array[currentIndex];
        array[currentIndex] = array[randomIndex];
        array[randomIndex] = swap;
    }

    return array;
}

::RandomElement <- function(array)
{
    local len = array.len();
    return len > 0 ? array[RandomInt(0, len - 1)] : null;
}

::combinetables <- function(tableA, tableB)
{
    local new_table = {};
    foreach(k, v in tableA)
        new_table[k] <- v;
    foreach(k, v in tableB)
        new_table[k] <- v;
    return new_table;
}

::IsValid <- function(entity)
{
    return entity && entity.IsValid();
}

::KillIfValid <- function(entity)
{
    if (entity && entity.IsValid())
        entity.Kill();
    return null;
}