::SAVE_DIR <- "supertest/"
::SAVE_EXTENSION <- ".sav"
::KEY_VALUE_SPLITTER <- "="
::DATA_SPLITTER <- ";" //dont ever use /n as it is REALLY slow to save as a splitter

class Cookies
{
    PlayerData = {}
    CookieData = {}

    function AddCookieNamespace(namespace, name, default_value)
    {
        if(!(namespace in CookieData))
            CookieData[namespace] <- {};

        CookieData[namespace][name] <- default_value;
    }

    function AddCookie(name, default_value)
    {
        AddCookieNamespace("general", name, default_value);
    }

    function GetNamespace(namespace, player, cookie)
    {
        return PlayerData[player.entindex()][namespace][cookie];
    }

    function Get(player, cookie)
    {
        return GetNamespace("general", player, cookie);
    }

    function SetNamespace(namespace, player, cookie, value, save = true)
    {
        PlayerData[player.entindex()][namespace][cookie] <- value;

        if(save)
            SavePlayerData(player)

        return value;
    }

    function Set(player, cookie, value)
    {
        SetNamespace("general", player, cookie, value);
    }

    function Reset(player)
    {
        PlayerData[player.entindex()] <- {};
        foreach(namespace, cookie_table in CookieData)
        {
            PlayerData[player.entindex()][namespace] <- clone(cookie_table);
        }
    }

    function CreateCache(player)
    {
        Reset(player);

        if(!player.GetAccountID())
        {
            player.SendChat("Something went wrong when trying to get your AccountID. Rejoining may fix.");
            return;
        }

        LoadPlayerData(player);
    }

    function SavePlayerData(player)
    {
        if(!player.GetAccountID())
        {
            player.SendChat("Something went wrong when trying to get your AccountID. Rejoining may fix.");
            return;
        }

        foreach(namespace, cookie_table in CookieData)
        {
            local save = "";

            foreach(name, value in cookie_table)
            {
                local cookie_value = Cookies.GetNamespace(namespace, player, name);

                switch(type(cookie_value))
                {
                    case "string": cookie_value = cookie_value.tostring(); break;
                    case "float": cookie_value = cookie_value.tofloat(); break;
                    case "bool":
                    case "integer": cookie_value = cookie_value.tointeger(); break;
                }

                save += name + KEY_VALUE_SPLITTER + cookie_value + DATA_SPLITTER
            }

            StringToFile(SAVE_DIR + player.GetAccountID() + "_" + namespace + SAVE_EXTENSION, save);
        }
    }

    function LoadPlayerData(player)
    {
        if(!player.GetAccountID())
        {
            player.SendChat("Something went wrong when trying to get your AccountID. Rejoining may fix.");
            return;
        }

        foreach(namespace, cookie_table in CookieData)
        {
            local save = FileToString(SAVE_DIR + player.GetAccountID() + "_" + namespace + SAVE_EXTENSION);

            if(save == null)
                continue;

            try
            {
                local split_save = split(save, DATA_SPLITTER, true);
                foreach (save_entry in split_save)
                {
                    local entry_array = split(save_entry, KEY_VALUE_SPLITTER);
                    local key_buffer = entry_array[0];
                    local value_buffer = entry_array[1];
                    if(key_buffer in CookieData[namespace])
                    {
                        switch(type(CookieData[namespace][key_buffer]))
                        {
                            case "string": value_buffer = value_buffer.tostring(); break;
                            case "float": value_buffer = value_buffer.tofloat(); break;
                            case "bool": value_buffer = !!value_buffer; break;
                            case "integer": value_buffer = value_buffer.tointeger(); break;
                        }
                        SetNamespace(namespace, player, key_buffer, value_buffer, false);
                    }
                }
            }
            catch(exception)
            {
                player.SendChat("\x07" + "FF0000" + "Your cookies failed to load. Please alert a server admin and provide the text below.");
                player.SendChat("\x07" + "FFA500" + "Save: " + "tf/scriptdata/" + SAVE_DIR + player.GetAccountID() + "_" + namespace + SAVE_EXTENSION);
                player.SendChat("\x07" + "FFA500" + "Error: " + exception);
            }
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
            local cookie_value = Get(name);

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
                        case "bool": value_buffer = !!value_buffer; break;
                        case "integer": value_buffer = value_buffer.tointeger(); break;
                    }
                    Set(key_buffer, value_buffer, false);
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