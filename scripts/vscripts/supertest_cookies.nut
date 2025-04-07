::SAVE_DIR <- "supertest/"
::SAVE_EXTENSION <- ".sav"
::KEY_VALUE_SPLITTER <- "="
::DATA_SPLITTER <- "\n"

class Cookies
{
    PlayerData = {}
    PlayerBannedSaving = {}
    loaded_cookies = false

    CookieData = {}

    function AddCookie(name, default_value)
    {
        CookieData[name] <- default_value
    }

    function Get(player, cookie)
    {
        return PlayerData[player.entindex()][cookie];
    }

    function Set(player, cookie, value, save = true)
    {
        PlayerData[player.entindex()][cookie] <- value;

        if(save)
        {
            SetPersistentVar("player_cookies", PlayerData);
            SavePlayerData(player);
        }

        return PlayerData[player.entindex()][cookie];
    }

    function Add(player, cookie, value, save = true)
    {
        PlayerData[player.entindex()][cookie] <- PlayerData[player.entindex()][cookie] + value;

        if(save)
        {
            SetPersistentVar("player_cookies", PlayerData);
            SavePlayerData(player);
        }

        return PlayerData[player.entindex()][cookie];
    }

    function Reset(player)
    {
        local default_cookies = {};
        foreach (name, cookie in CookieData)
        {
            default_cookies[name] <- cookie;
        }

        PlayerData[player.entindex()] <- default_cookies;

        SetPersistentVar("player_cookies", PlayerData);
    }

    function CreateCache(player)
    {
        Reset(player);

        if(!player.GetAccountID())
        {
            PlayerBannedSaving[player.GetUserID()] <- true;
            player.SendChat("Something went wrong when trying to get your cookies. Rejoining may fix.");
            return;
        }

        if(!loaded_cookies)
        {
            LoadPersistentCookies();
        }

        LoadPlayerData(player)
    }

    function LoadPersistentCookies()
    {
        local cookies_to_load = GetPersistentVar("player_cookies", null);
        if(cookies_to_load)
            PlayerData = cookies_to_load;

        loaded_cookies = true;
    }

    function SavePlayerData(player)
    {
        if(player.GetUserID() in PlayerBannedSaving)
        {
            player.SendChat("Refusing to save your cookies due to a previous error. Rejoining may fix.");
            return;
        }

        local save = "";

        foreach (name, cookie in CookieData)
        {
            local cookie_value = Cookies.Get(player, name);

            switch(type(cookie_value))
            {
                case "string": cookie_value = cookie_value.tostring(); break;
                case "float": cookie_value = cookie_value.tofloat(); break;
                case "bool":
                case "integer": cookie_value = cookie_value.tointeger(); break;
            }

            save += name + KEY_VALUE_SPLITTER + cookie_value + DATA_SPLITTER
        }

        StringToFile(SAVE_DIR + player.GetAccountID() + SAVE_EXTENSION, save);
    }

    function LoadPlayerData(player)
    {
        if(player.GetUserID() in PlayerBannedSaving)
        {
            player.SendChat("Refusing to load your cookies due to a previous error. Rejoining may fix.");
            return;
        }

        local save = FileToString(SAVE_DIR + player.GetAccountID() + SAVE_EXTENSION);

        if(save == null)
            return false;

        try
        {
            local split_save = split(save, DATA_SPLITTER, true);
            foreach (save_entry in split_save)
            {
                local entry_array = split(save_entry, KEY_VALUE_SPLITTER);
                local key_buffer = entry_array[0];
                local value_buffer = entry_array[1];
                if(key_buffer in CookieData)
                {
                    switch(type(CookieData[key_buffer]))
                    {
                        case "string": value_buffer = value_buffer.tostring(); break;
                        case "float": value_buffer = value_buffer.tofloat(); break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }
                    Cookies.Set(player, key_buffer, value_buffer, false);
                }
            }

            SetPersistentVar("player_cookies", PlayerData);
            return true;
        }
        catch(exception)
        {
            player.SendChat("\x07" + "FF0000" + "Your cookies failed to load. Please alert a server admin and provide the text below.");
            player.SendChat("\x07" + "FFA500" + "Save: " + "tf/scriptdata/" + SAVE_DIR + player.GetAccountID() + SAVE_EXTENSION);
            player.SendChat("\x07" + "FFA500" + "Error: " + exception);
        }
    }
}
::Cookies <- Cookies();

class ServerCookies
{
    ServerData = {}

    CookieData = {}

    function AddCookie(name, default_value)
    {
        CookieData[name] <- default_value
    }

    function Get(cookie)
    {
        return safeget(ServerData, cookie, CookieData[cookie]);
    }

    function Set(cookie, value, save = true)
    {
        ServerData[cookie] <- value;

        if(save)
        {
            SaveServerData();
        }

        return ServerData[cookie];
    }

    function SaveServerData()
    {
        local save = "";

        foreach (name, cookie in CookieData)
        {
            local cookie_value = ServerCookies.Get(name);

            switch(type(cookie_value))
            {
                case "string": cookie_value = cookie_value.tostring(); break;
                case "float": cookie_value = cookie_value.tofloat(); break;
                case "bool":
                case "integer": cookie_value = cookie_value.tointeger(); break;
            }

            save += name + KEY_VALUE_SPLITTER + cookie_value + DATA_SPLITTER
        }

        StringToFile(SAVE_DIR + "server" + SAVE_EXTENSION, save);
    }

    function LoadServerData()
    {
        local save = FileToString(SAVE_DIR + "server" + SAVE_EXTENSION);

        if(save == null)
            return false;

        try
        {
            local split_save = split(save, DATA_SPLITTER, true);
            foreach (save_entry in split_save)
            {
                local entry_array = split(save_entry, KEY_VALUE_SPLITTER);
                local key_buffer = entry_array[0];
                local value_buffer = entry_array[1];
                if(key_buffer in CookieData)
                {
                    switch(type(CookieData[key_buffer]))
                    {
                        case "string": value_buffer = value_buffer.tostring(); break;
                        case "float": value_buffer = value_buffer.tofloat(); break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }
                    ServerCookies.Set(key_buffer, value_buffer, false);
                }
            }
            return true;
        }
        catch(exception)
        {
            SendChatAll("\x07" + "FF0000" + "Server cookies failed to load. Please alert a server admin and provide the text below.");
            SendChatAll("\x07" + "FFA500" + "Save: " + "tf/scriptdata/" + SAVE_DIR + "server" + SAVE_EXTENSION);
            SendChatAll("\x07" + "FFA500" + "Error: " + exception);
        }
    }
}
::ServerCookies <- ServerCookies();