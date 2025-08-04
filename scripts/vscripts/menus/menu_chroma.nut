const CHROMA_DELTA = 0.01

ServerCookies.AddCookie("chroma0", 0.0)
ServerCookies.AddCookie("chroma1", 1.0)
ServerCookies.AddCookie("chroma2", 0.0)

AddListener("tick_frame", 100, function()
{
	SetPropVector(worldspawn, "m_WorldMins", Vector(ServerCookies.Get("chroma0")*100, ServerCookies.Get("chroma1")*100, ServerCookies.Get("chroma2")*100))
})

DefineMenu(class extends Menu{
    id = "chroma"
    menu_name = "chroma"
    function constructor(){
        items = []

		foreach(chroma_index, name in ["Red Value" "Green Value" "Blue Value"])
		{
			local new_titles = []
			local new_descriptions = []
			for (local i = 0; i < (1 / CHROMA_DELTA) + 1; i++)
			{
				new_titles.append(name + ": " + (i * CHROMA_DELTA).tostring())
			}

			items.append(class extends MenuItem{
				titles = new_titles
				description = "Change the " + name + " of the chroma key room."
				chroma = chroma_index

				function OnMenuOpened(player)
				{
					index = ServerCookies.Get(("chroma" + chroma.tostring())) / CHROMA_DELTA
				}

				function GenerateDesc(player)
				{
					return description
				}

				function OnLeftRightInput(player, input)
				{
					local length = titles.len() - 1;

					if(length == 0)
						return false;

					local new_loc = this.index + input;

					if(new_loc < 0)
						new_loc = length;
					else if(new_loc > length)
						new_loc = 0;

					this.index = new_loc;
					player.SetVar("current_menuitem_desc", null);
					player.PlaySoundForPlayer({sound_name = "ui/cyoa_node_absent.wav"});
					ServerCookies.Set("chroma" + chroma, index * CHROMA_DELTA)
					return true;
				}
			})
		}
    }
})