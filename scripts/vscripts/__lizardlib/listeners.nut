//================================
//Exposed Functions.
//Intended for use by your code.
//================================

//You can skip `order` parameter. Default value is 0.
::OnGameEvent <- function(eventName, order, listenerFunc = null, scope = null, selfListener = false)
{
    if (typeof(order) == "function")
    {
        selfListener = scope;
        scope = listenerFunc;
        listenerFunc = order;
        order = 0;
    }
    if (endswith(eventName, "_post")) //_post executes at the end of THIS tick
        return OnGameEventPostInternal(eventName.slice(0, eventName.len() - 5), order, listenerFunc, scope, selfListener, -1);
    if (endswith(eventName, "_next")) //while _next executes at the end of NEXT tick
        return OnGameEventPostInternal(eventName.slice(0, eventName.len() - 5), order, listenerFunc, scope, selfListener, 0.01);
    else if (eventName == "OnTakeDamage")
        return OnGameEventInternal(eventName, order, listenerFunc, scope, selfListener,  "OnScriptHook_", "ScriptHookCallbacks", RegisterScriptHookListener);
    else
        return OnGameEventInternal(eventName, order, listenerFunc, scope, selfListener, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener);
}

//Same as OnGameEvent, but fires ONLY if the event's player is `scope.self`.
//You can skip `order` parameter. Default value is 0.
::OnSelfEvent <- function(eventName, order, listenerFunc = null, scope = null)
{
    if (typeof(order) == "function")
    {
        scope = listenerFunc;
        listenerFunc = order;
        order = 0;
    }
    return OnGameEvent(eventName, order, listenerFunc, scope, true)
}
::OnSelfGameEvent <- OnSelfEvent;
::OnGameSelfEvent <- OnSelfEvent;

::FireCustomEvent <- null; //Will be defined later as function(eventName, params)

//Deletes all events attached to a particular scope
::DeleteAllEventsFromScope <- function(scope)
{
    if (typeof(scope) == "instance" && scope.IsValid())
    {
        scope.ValidateScriptScope();
        scope = scope.GetScriptScope();
    }
    foreach (listenerQueue in listenerTable)
        for (local i = listenerQueue.len() - 1; i >= 0; i--)
            if (listenerQueue[i][2] == scope)
                listenerQueue.remove(i);
}

//Removing listeners this way is not really intended (see `DeleteAllEventsFromScope`),
//  but in case you need it, you can store the return of `AddListener` in a variable,
//  and then pass that variable to `RemoveListener`.
::RemoveListener <- function(listenerEntry)
{
    foreach (listenerQueue in listenerTable)
    {
        local index = listenerQueue.find(listenerEntry);
        if (index != null)
        {
            listenerQueue.remove(index);
            return;
        }
    }
}

//==============================
//Internal Functions.
//==============================

::listenerTable <- {};

//The higher the value the LATER it will execute
::AddListener <- function(eventName, order, listenerFunc, scope = null, selfListener = false)
{
    if (scope == null)
        scope = this;
    else if (typeof(scope) == "instance" && scope.IsValid())
    {
        scope.ValidateScriptScope();
        scope = scope.GetScriptScope();
    }
    local scope = scope.weakref();
    local parameters = listenerFunc.getinfos().parameters; //note: parameters[0] is hidden and it's always _scope_
    local paramLen = parameters.len();
    local hasPlayer = paramLen == 3 || (paramLen == 2 && (parameters[1] == "player" || parameters[1] == "victim")) ? 1 : 0;
    local hasParams = paramLen > (hasPlayer ? 2 : 1) ? 2 : 0;
    local listenerEntry = [order, listenerFunc, scope, hasPlayer + hasParams + (selfListener ? 4 : 0)];
    if (eventName in listenerTable)
    {
        local listenerQueue = listenerTable[eventName];
        local len = listenerQueue.len();
        local i = 0;
        for (; i < len; i++)
            if (listenerQueue[i][0] >= order)
                break;
        listenerQueue.insert(i, listenerEntry);
    }
    else
        listenerTable[eventName] <- [listenerEntry];
    return listenerEntry;
}

::FireListeners <- function(eventName, params)
{
    if (!(eventName in listenerTable))
        return;

    local player = null;
    if ("userid" in params && eventName != "player_connect")
    {
        player = GetPlayerFromUserID(params.userid);
        if (!IsValidClient(player))
            return;
        //if (eventName == "player_spawn" && params.team == 0)
        //    return;
        if (eventName == "player_death" && params.death_flags & 32)
        {
            FireCustomEvent("player_death_feign", params);
            return;
        }
    }
    else if (eventName == "OnTakeDamage")
    {
        player = params.const_entity;
        if (!IsValidClient(player))
        {
            FireCustomEvent("OnTakeDamageNonPlayer", params);
            return;
        }
    }

    //Yes, we need to reevaluate the array length every step because scopes can be removed inside one of the listeners.
    local listenerQueue = listenerTable[eventName];
    for (local i = 0; i < listenerQueue.len(); i++)
    {
        local listenerEntry = listenerQueue[i];
        local scope = listenerEntry[2];
        if (!scope || ("self" in scope && (!scope.self || !scope.self.IsValid())))
        {
            listenerQueue.remove(i--);
            continue;
        }
        try
        {
            local flags = listenerEntry[3];
            if (flags & 4 && scope != player.GetScriptScope())
                continue;
            local args = [scope];
            if (flags & 1)
                args.push(player);
            if (flags & 2)
                args.push(params);
            local result = listenerEntry[1].acall(args);
            if (result == 117115)
                return;
        }
        catch (e) { } //This allows us to see the error in console, but it won't stop this cycle
    }
    if (eventName == "OnTakeDamage")
    {
        if (params.damage_custom != params.damage_stats)
            params.damage_stats = params.damage_custom;
    }
}

::OnGameEventInternal <- function(eventName, order, listenerFunc, scope, selfListener, prefix, eventType, regFunc)
{
    if (scope == null)
        scope = this;
    local eventTable = root_table[eventType];
    if (!(eventName in eventTable))
    {
        root_table[prefix + eventName] <- function(params) { FireListeners(eventName, params); };
        eventTable[eventName] <- [];
        regFunc(eventName);
    }
    if (eventTable[eventName].find(main_script) == null)
        eventTable[eventName].append(main_script.weakref());
    return AddListener(eventName, order, listenerFunc, scope, selfListener);
}

::OnGameEventPostInternal <- function(eventName, order, listenerFunc, scope, selfListener, delay)
{
    local parameters = listenerFunc.getinfos().parameters;
    local paramLen = parameters.len();
    local hasPlayer = paramLen == 3 || (paramLen == 2 && (parameters[1] == "player" || parameters[1] == "victim")) ? 1 : 0;
    local hasParams = paramLen > (hasPlayer ? 2 : 1) ? 2 : 0;

    return OnGameEvent(eventName, order, function(player, params) {
        local args = [this, delay, listenerFunc];
        if (hasPlayer)
            args.push(player);
        if (hasParams)
            args.push(params);
        args.push(this);
        RunWithDelay.acall(args);
    }, scope, selfListener);
}

::FireCustomEvent <- FireListeners;

OnGameEvent("OnTakeDamage", 0, function(victim, params)
{
    local attacker = safeget(params, "attacker", null);
    if (IsValidPlayer(attacker))
    {
        params.userid <- attacker.GetUserID();
        FireCustomEvent("OnDealDamage", params);
    }
});