::CHANGELOG <- [
	{
		name = "v1.7.2"
		changelog = [
			"Updated the items_game."
			"Changelog now sorts in reverse. (Newest -> Oldest)"
			"Further reduced overall lightmap quality."
			"Removed remnants of a test command that was added\nin the previous update that caused issues."
			"Fixed an issue where errors would appear if the\nlast player that spawned bots would disconnect."
		]
	}
	{
		name = "v1.7.1"
		changelog = [
			"Added Halloween 2025 Content."
			"Reduced lightmap quality overall."
		]
	}
	{
		name = "v1.7"
		changelog = [
			"Updated the items_game."
			"Made the chroma key room\nchange color consistently."
			"Chroma key room color can now\nbe changed on a scale of 0.01."
			"Holding left or right on a menu\nitem will now cause it to slowly scroll faster."
			"Changed how the buttons appear on\nthe Supertest menu to better\nindicate how to trigger certain actions."
			"Removed a test print to console when\nchanging the chroma key room color."
			"Added the option for the sentry in the\nbuilding range to spawn with a wrangler shield."
			"Added CVar \"weapon_medigun_charge_rate\" to\nthe CVar menu, allowing faster Übercharge build."
			"Added CVar \"tf_force_holidays_off\" to\nthe CVar menu, forcibly turning off all holidays."
			"Added an additional set of\npickups in the spawn area."
			"Added inteligence briefcases,\na capture point, payload carts and a\npair of spell pickups outside."
			"Fixed major issues causing not being\nable to open the scoreboard or\nchange class or team after certain actions."
			"Fixed not being able to\nunequip cosmetic override medals."
			"Fixed an error from occuring when\nequipping weapons with cosmetics."
		]
	}
	{
		name = "v1.6.1"
		changelog = [
			"Added Summer 2025 Content."
			"Fixed tank damage being\ninconsistent with expected values."
			"Bots can now only be spawned every 5\nseconds to prevent lag related bugs."
			"Overhauled the chroma key room, colors\ncan be adjusted in the new chroma key menu."
		]
	}
	{
		name = "v1.6 - Building Range & Bot Enhancement Update"
		changelog = [
			"Added the changelog menu, showing\nwhat was added between versions."
			"Fixed an issue where the Secretly Serviced\nwar paint was misnamed as \"Pacific Peacemaker\""
			"Fixed an issue where the Current Event Scattergun\nSkin was misnamed as and took the slot of the\nCurrent Event Rocket Launcher Skin"
			"Fixed the tank not appearing on\nthe workshop edition of supertest."
			"Fixed an issue where setting the Bot Skin to\nZombie would set the wrong CVar\nif halloween cosmetics are disabled."
			"Fixed an issue where the error:\n\"Inserted trigger_particle with no model\"\nwould appear in console"
			"Chat messages relating to bots joining and\nleaving the server, joining teams and CVars changing\nvalues from the supertest menu will no longer appear."
			"Bots spawned in the supertest menu will have their\nnames be their class name, not a random bot name."
			"Bots are now restricted to a configurable weapon slot."
			"Bots can now copy weapon overides and cosmetic\nloadouts from the last player who spawned them."
			"Bots can be given a killstreak value on spawn\nfrom the last player who spawned them."
			"Added a new area to the map, the Building Range"
			"Added the building range menu, allowing you to\nsummon and adjust parameters of spawned buildings"
		]
	}
	{
		name = "v1.5.1"
		changelog = [
			"Added a 7th cosmetic slot per prefab\ndedicated to community and tournament medals."
			"Community and Tournament medals\nare now in the generated data."
			"Added a Stats menu which displays many items exist."
			"Added a new player setting: Respawn at Death Point.\nWhen respawning, you will be at the point you\ndied with the same velocity and eye angles."
			"The menu now displays an extra menu item below."
			"Fixed an issue where Frozen Aurora didn't\nexist in the war paint menu."
			"Fixed the name of the Giger Counter."
			"Loading the supertest script manually will respawn\nall players making sure they\ncan open the menu without errors."
			"Loading the supertest script manually on a map\nwithout upgrade stations will make it so that when\nthey touch a resupply cabinet, it will open the upgrades menu."
		]
	}
	{
		name = "v1.5 - Cosmetics & Unusuals Update"
		changelog = [
			"Added a cosmetics selection menu, allowing you to\nequip any cosmetic, select a style,\npaint it and modify the unusual on it."
			"Cosmetic and Unusual selection menus can be\nsearched through by typing\nin chat while the menu is open."
			"Added cosmetic selection prefabs, allowing you\nto save up to 6 prefabs per class,\nwith 6 cosmetics per prefab."
			"Cosmetic, Unusual and Taunt data is now automatically\ngenerated from a python file from the Github repository,\nallowing easy updating when need be by grabbing data from the TF2 API."
			"Saving has been changed to use namespaces, multiple\nsave files now exist per player to store different data,\nas such, previous save files are now incompatable."
			"Menus now display their directory dynamically\ninstead of using pre generated images."
			"Menus will now cache the current menu item\ndescription to save on resources each tick."
			"Menus will now scroll faster when\nholding down the button for a long time."
			"Menus will no longer loop when attempted using\nDAI Inputs by default, a manual press is required."
			"Added chat messages when toggling player modifiers."
			"In the Player Modifiers menu, added a killstreak setter."
			"Added the Player Settings menu, allowing\ntoggling of stuff that affects the client,\nsuch as stuff pertaining to the HUD and Menus."
			"Moved the Condition and Show Keys HUD to the\nPlayer Settings menu, also made their desired\nsetting save so that it's persistent between sessions."
			"In the Player Settings menu, added a toggle to\nchange the opacity of the supertest menu."
			"In the Player Settings menu, added a toggle to\nre-enable looping through the menu with DAI inputs."
			"In the Player Settings menu, added a toggle to\nalways instantly respawn upon death."
			"In the Taunt menu, added an option to select an\nunusual that will appear when taunting with the menu.\nThis can be searched through by typing in chat."
			"Added the Mirror Room adjacent to the Bot Range."
			"The CVar \"tf_player_movement_restart_freeze\" will\nnow be set to 0 on new rounds, preventing\ndelay in movement when spawning for the first time."
			"Switching teams will now instantly respawn you and\nmaintain your previous position, eye angles\nand velocity as it would a normal death."
			"Spy bots in the bot range will no longer disguise."
			"The Uber Pickup has been given a model\nmore consistent with the other pickups."
		]
	}
	{
		name = "v1.4"
		changelog = [
			"Added CVar menu, allowing you to\nfind / change important variables\nfor easier testing."
			"Added server cookies, cvars changed in\nthe menu and the selected bot skin will\nbe remembered and respected through sessions."
			"Added Player Modifier menu, a menu containing\noptions to modify yourself in various ways."
			"In the Player Modifier menu, Added the option to\ngrant and remove specific conditions on you,\naswell as remove all conditions."
			"In the Player Modifier menu, Added the\noption to give yourself any spell."
			"In the Player Modifier menu, Added the option to\nset yourself to be invulnerable, grant infinite\nweapon clip and grant infinite reserve ammo."
			"In the Player Modifier menu, Added the\noption to disable the infinite MvM cash."
			"In the Player Modifier menu, Added\nthe Condition and Key HUD display."
			"The menu hint that appears on spawn will\nnow only show if 30 seconds have passed\nsince the last time it was shown."
			"Reorganized pickup clusters to more\neasily pickup the desired item."
			"Added a mini-crit pickup\nto the pickup clusters."
			"Fixed an issue where demo shields equipped via\nthe econ inventory would have incorrect visuals."
			"Fixed an issue where an error relating to\n\"RemoveInstancedProps\" not existing would appear\nin console when a client disconnects."
			"Fixed an issue where\n\"The Flying Guillotine (Thirsty)\" would appear\nas it's \"Thirstier\" variant."
		]
	}
	{
		name = "v1.3"
		changelog = [
			"Adjusted map lighting to be more\nneutral and less saturated"
			"Adjust lightmap luxel scale to be more\nappropiate for the improved lightmap filtering"
			"Adjusted position of the menu and added\nan extra line for selected menu item descriptions"
			"Fixed an issue where the attribute:\n\"Unusual Effect: Invalid Particle\" would appear\non override weapons without an unusual set"
			"Fixed an issue where an error relating\nto the \"SkinType\" enum would appear\nin console on map launch"
			"Fixed an issue where\n\"Inserted func_regenerate with no model\"\nwould appear in console"
			"Adjusted the position of the\nscout bot spawn position in\nthe bot range to be farther back"
			"Added an option to spawn bots\nwith a Zombie or Robot skin"
			"Added an option to equip\nall / bots of a class with a\nspecified item from the items_game"
		]
	}
	{
		name = "v1.2.2"
		changelog = [
			"Added the Iron Curtain"
		]
	}
	{
		name = "v1.2.1"
		changelog = [
			"Replaced the \"base_boss tank\" with an actual\nboss_tank for accurate damage readings"
		]
	}
	{
		name = "v1.2 - Bot Range Update"
		changelog = [
		"Added a new area to the map, the Bot Range"
		"Added the bot range menu, allowing you to\nspawn bots of a specific team, kick them or teleport\nto the range at a predefined location for showcases"
		"Added MvM Upgrade Stations, functioning for both\nregular and override weapons, also canteens"
		"Did a lightmap pass to reduce\nthe quality of some lightmaps"
		"Added lightmaps to some props"
		"Added detail to the 3D Skybox"
		"Added the previously missing Austrailium\nAmbassador to the weapon override selection"
		]
	}
	{
		name = "v1.1"
		changelog = [
		"Moved the menu upwards, allowing you\nto better see your equipped weapon"
		"Added weapon mod: \"Stat Clock\".\nShows a stat clock on skinned override weapons"
		"Added the \"Cubemap Balls\" melee variant override"
		"Improved Visuals"
		]
	}
	{
		name = "v1.0"
		changelog = [
		"Initial Release"
		]
	}
]

DefineMenu(class extends Menu{
    id = "changelog"
    menu_name = "changelog"
    function constructor(){
        items = []

		foreach(table in CHANGELOG)
		{
			local new_titles = []
			local new_descriptions = []
			foreach(i, changelog_desc in table.changelog)
			{
				if(table.changelog.len() != 1)
					new_titles.append(table.name + " (" + (i + 1) + "/" + table.changelog.len() + ")")
				else
					new_titles.append(table.name)
				new_descriptions.append(changelog_desc)
			}


			items.append(class extends MenuItem{
				titles = new_titles
				descriptions = new_descriptions

				function GenerateDesc(player)
				{
					return descriptions[index]
				}
			})
		}
    }
})