//================================
//Exposed Functions.
//Intended for use by your code.
//================================

//You can skip `order` parameter. Default value is 0.
::AddTimer <- function(interval, order, ...)
{
    if (typeof(order) == "function")
        return AddTimer.acall([this, interval, 0, order].extend(vargv));

    local timerFunc = vargv.remove(0);
    local scope = timerFunc.getinfos().parameters.len() - 1 < vargv.len()
        ? vargv.pop()
        : null;

    if (scope == null)
        scope = this;
    else if (typeof(scope) == "instance" && scope.IsValid())
    {
        scope.ValidateScriptScope();
        scope = scope.GetScriptScope();
    }

    if (interval < 0)
        interval = 0;
    local timerEntry = [order, timerFunc, scope.weakref(), vargv, interval, Time()];

    local size = timers.len();
    local i = 0;
    for (; i < size; i++)
        if (timers[i][0] <= order)
            break;
    timers.insert(i, timerEntry);

    return timerEntry;
}
::OnTimer <- AddTimer;

//If you pass one more parameter than the executed function takes,
//  that parameter will be taken as the scope.
//Also, thanks Mr.Burguers and Ficool2 for help.
::RunWithDelay <- function(delay, delayedFunc, ...)
{
    local scope = delayedFunc.getinfos().parameters.len() - 1 < vargv.len()
        ? vargv.pop()
        : null;

    if (scope == null)
        scope = this;
    else if (typeof(scope) == "instance" && scope.IsValid())
    {
        scope.ValidateScriptScope();
        scope = scope.GetScriptScope();
    }

    local tmpEnt = Entities.CreateByClassname("point_template");
    local name = tmpEnt.GetScriptId();
    local code = format("delays.%s[0](\"%s\")", name, name);
    delays[name] <- [function(name)
    {
        local entry = delete delays[name];
        local scope = entry[3];
        if (!scope || ("self" in scope && (!scope.self || !scope.self.IsValid())))
            return;
        entry[1].acall([scope].extend(entry[2]));
    }, delayedFunc, vargv, scope.weakref()];
    SetPropBool(tmpEnt, "m_bForcePurgeFixedupStrings", true);
    SetPropString(tmpEnt, "m_iName", code);
    EntFireByHandle(main_script_entity, "RunScriptCode", code, delay, null, null);
    EntFireByHandle(tmpEnt, "Kill", null, delay, null, null)
}
::Schedule <- RunWithDelay;

//Deletes all timers attached to a particular scope
::DeleteAllTimersFromScope <- function(scope)
{
    if (typeof(scope) == "instance" && scope.IsValid() && !(scope = scope.GetScriptScope()))
        return;
    for (local i = timers.len() - 1; i >= 0; i--)
        if (timers[i][2] == scope)
            timers.remove(i);
}

//Deletes all delayed functions attached to a particular scope
::DeleteAllDelaysFromScope <- function(scope)
{
    if (typeof(scope) == "instance" && scope.IsValid() && !(scope = scope.GetScriptScope()))
        return;
    foreach(name, delay in delays)
        if (delay[1][0] == scope)
            delay[1][0] = null;
}

//==============================
//Internal Functions.
//==============================

::timers <- [];
::delays <- {};

{
    local worldspawn = Entities.FindByClassname(null, "worldspawn");
    worldspawn.ValidateScriptScope();
    worldspawn.GetScriptScope().LizardLibThink <- function()
    {
        main_script.LizardLibThink();
        return -1;
    }
    AddThinkToEnt(worldspawn, "LizardLibThink");
}

function LizardLibThink()
{
    local time = Time();
    for (local i = timers.len() - 1; i >= 0; i --)
    {
        local entry = timers[i];
        local scope = entry[2];
        if (!scope || ("self" in scope && (!scope.self || !scope.self.IsValid())))
            timers.remove(i);
        else if (time - entry[4] >= entry[5])
        {
            entry[5] += entry[4];
            try { entry[1].acall([scope].extend(entry[3])); } catch (e) { }
        }
    }
    return -1;
}