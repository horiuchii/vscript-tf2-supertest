enum SkinType
{
    LegacySkin
    Warpaint
}

enum SkinCollection
{
    Teufort
    Craftsmann
    ConcealedKiller
    Powerhouse

    Harvest
    Gentlemanne
    Pyroland
    Warbird

    JungleInferno1
    JungleInferno2
    JungleInferno3
    JungleInferno4

    SaxtonSelect
    Event

    Winter2017
    Halloween2018
    Winter2019
    Halloween2020
    Winter2020
    Halloween2021
    Halloween2022
    Summer2023
    Halloween2024
    MAX
}

::SkinCollectionName <- [
    "Teufort"
    "Craftsmann"
    "Concealed Killer"
    "Powerhouse"

    "Harvest"
    "Gentlemanne's"
    "Pyroland"
    "Warbird"

    "Jungle Jackpot"
    "Infernal Reward"
    "Decorated War Hero"
    "Contract Compaigner"

    "Saxton Select"
    "Mann Co. Events"

    "Winter 2017"
    "Scream Fortress X"
    "Winter 2019"
    "Scream Fortress XII"
    "Winter 2020"
    "Scream Fortress XIII"
    "Scream Fortress XIV"
    "Summer 2023"
    "Scream Fortress XVI"
]

::SKINS <- {
    ["bovine_blazemaker"] = {
        display_name = "Bovine Blazemaker"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 0
        replacements = {[208] = 15030}
    },
    ["war_room"] = {
        display_name = "War Room"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 1
        replacements = {[202] = 15031}
    },
    ["treadplate_tormenter"] = {
        display_name = "Treadplate Tormenter"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 2
        replacements = {[203] = 15032}
    },
    ["bogtrotter"] = {
        display_name = "Bogtrotter"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 3
        replacements = {[201] = 15033}
    },
    ["earth_sky_fire"] = {
        display_name = "Earth, Sky and Fire"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 4
        replacements = {[208] = 15034}
    },
    ["team_sprayer"] = {
        display_name = "Team Sprayer"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 5
        replacements = {[203] = 15037}
    },
    ["spruce_deuce"] = {
        display_name = "Spruce Deuce"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 6
        replacements = {[200] = 15036}
    },
    ["hickory_holepuncher"] = {
        display_name = "Hickory Hole-Puncher"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 7
        replacements = {[209] = 15035}
    },
    ["rooftop_wrangler"] = {
        display_name = "Rooftop Wrangler"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 8
        replacements = {[207] = 15038}
    },
    ["civic_duty"] = {
        display_name = "Civic Duty"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 9
        replacements = {[199] = 15044}
    },
    ["civil_servant"] = {
        display_name = "Civil Servant"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 10
        replacements = {[211] = 15039}
    },
    ["local_hero"] = {
        display_name = "Local Hero"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 11
        replacements = {[209] = 15041}
    },
    ["mayor"] = {
        display_name = "Mayor"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 12
        replacements = {[210] = 15042}
    },
    ["smalltown_bringdown"] = {
        display_name = "Smalltown Bringdown"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 13
        replacements = {[205] = 15043}
    },
    ["citizen_pain"] = {
        display_name = "Citizen Pain"
        collection = SkinCollection.Teufort
        type = SkinType.LegacySkin
        order = 14
        replacements = {[202] = 15040}
    },



    ["tartan_torpedo"] = {
        display_name = "Tartan Torpedo"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 0
        replacements = {[200] = 15015}
    },
    ["lumber_down_under"] = {
        display_name = "Lumber From Down Under"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 1
        replacements = {[201] = 15019}
    },
    ["rustic_ruiner"] = {
        display_name = "Rustic Ruiner"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 2
        replacements = {[199] = 15016}
    },
    ["barn_burner"] = {
        display_name = "Barn Burner"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 3
        replacements = {[208] = 15017}
    },
    ["homemade_heater"] = {
        display_name = "Homemade Heater"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 4
        replacements = {[209] = 15018}
    },
    ["plaid_potshotter"] = {
        display_name = "Plaid Potshotter"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 5
        replacements = {[203] = 15022}
    },
    ["country_crusher"] = {
        display_name = "Country Crusher"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 6
        replacements = {[200] = 15021}
    },
    ["iron_wood"] = {
        display_name = "Iron Wood"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 7
        replacements = {[202] = 15020}
    },
    ["shot_in_the_dark"] = {
        display_name = "Shot in the Dark"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 8
        replacements = {[201] = 15023}
    },
    ["blasted_bombardier"] = {
        display_name = "Blasted Bombardier"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 9
        replacements = {[207] = 15024}
    },
    ["backcountry_blaster"] = {
        display_name = "Backcountry Blaster"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 10
        replacements = {[200] = 15029}
    },
    ["antique_annihilator"] = {
        display_name = "Antique Annihilator"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 11
        replacements = {[202] = 15026}
    },
    ["old_country"] = {
        display_name = "Old Country"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 12
        replacements = {[210] = 15027}
    },
    ["american_pastoral"] = {
        display_name = "American Pastoral"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 13
        replacements = {[205] = 15028}
    },
    ["reclaimed_reanimator"] = {
        display_name = "Reclaimed Reanimator"
        collection = SkinCollection.Craftsmann
        type = SkinType.LegacySkin
        order = 14
        replacements = {[211] = 15025}
    },



    ["red_rock_roscoe"] = {
        display_name = "Red Rock Roscoe"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 0
        replacements = {[209] = 15013}
    },
    ["sand_cannon"] = {
        display_name = "Sand Cannon"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 1
        replacements = {[205] = 15014}
    },
    ["sudden_flurry"] = {
        display_name = "Sudden Flurry"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 2
        replacements = {[207] = 15009}
    },
    ["psychedelic_slugger"] = {
        display_name = "Psychedelic Slugger"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 3
        replacements = {[210] = 15011}
    },
    ["purple_range"] = {
        display_name = "Purple Range"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 4
        replacements = {[201] = 15007}
    },
    ["night_terror"] = {
        display_name = "Night Terror"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 5
        replacements = {[200] = 15002}
    },
    ["carpet_bomber"] = {
        display_name = "Carpet Bomber"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 6
        replacements = {[207] = 15012}
    },
    ["woodland_warrior"] = {
        display_name = "Woodland Warrior"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 7
        replacements = {[205] = 15006}
    },
    ["wrapped_reviver"] = {
        display_name = "Wrapped Reviver"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 8
        replacements = {[211] = 15010}
    },
    ["forest_fire"] = {
        display_name = "Forest Fire"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 9
        replacements = {[208] = 15005}
    },
    ["night_owl"] = {
        display_name = "Night Owl"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 10
        replacements = {[201] = 15000}
    },
    ["woodsy_widowmaker"] = {
        display_name = "Woodsy Widowmaker"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 11
        replacements = {[203] = 15001}
    },
    ["backwoods_boomstick"] = {
        display_name = "Backwoods Boomstick"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 12
        replacements = {[199] = 15003}
    },
    ["king_of_the_jungle"] = {
        display_name = "King of the Jungle"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 13
        replacements = {[202] = 15004}
    },
    ["masked_mender"] = {
        display_name = "Masked Mender"
        collection = SkinCollection.ConcealedKiller
        type = SkinType.LegacySkin
        order = 14
        replacements = {[211] = 15008}
    },



    ["thunderbolt"] = {
        display_name = "Thunderbolt"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 0
        replacements = {[201] = 15059}
    },
    ["liquid_asset"] = {
        display_name = "Liquid Asset"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 1
        replacements = {[207] = 15045}
    },
    ["shell_shocker"] = {
        display_name = "Shell Shocker"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 2
        replacements = {[205] = 15052}
    },
    ["shell_shocker"] = {
        display_name = "Shell Shocker"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 3
        replacements = {[200] = 15053}
    },
    ["pink_elephant"] = {
        display_name = "Pink Elephant"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 4
        replacements = {[207] = 15048}
    },
    ["flash_fryer"] = {
        display_name = "Flash Fryer"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 5
        replacements = {[208] = 15049}
    },
    ["spark_of_life"] = {
        display_name = "Spark of Life"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 6
        replacements = {[211] = 15050}
    },
    ["dead_reckoner"] = {
        display_name = "Dead Reckoner"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 7
        replacements = {[210] = 15051}
    },
    ["black_dahlia"] = {
        display_name = "Black Dahlia"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 8
        replacements = {[209] = 15046}
    },
    ["sandstone_special"] = {
        display_name = "Sandstone Special"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 9
        replacements = {[209] = 15056}
    },
    ["lightning_rod"] = {
        display_name = "Lightning Rod"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 10
        replacements = {[199] = 15047}
    },
    ["brick_house"] = {
        display_name = "Brick House"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 11
        replacements = {[202] = 15055}
    },
    ["aqua_marine"] = {
        display_name = "Aqua Marine"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 12
        replacements = {[205] = 15057}
    },
    ["low_profile"] = {
        display_name = "Low Profile"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 13
        replacements = {[203] = 15058}
    },
    ["turbine_torcher"] = {
        display_name = "Turbine Torcher"
        collection = SkinCollection.Powerhouse
        type = SkinType.LegacySkin
        order = 14
        replacements = {[208] = 15054}
    },



    ["boneyard"] = {
        display_name = "Boneyard"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 0
        replacements = {[201] = 15071, [197] = 15075, [210] = 15062, [194] = 15062}
    },
    ["pumpkin_patch"] = {
        display_name = "Pumpkin Patch"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 1
        replacements = {[208] = 15067, [202] = 15087, [201] = 15070, [207] = 15083}
    },
    ["macabre_web"] = {
        display_name = "Macabre Web"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 2
        replacements = {[209] = 15060, [210] = 15064, [200] = 15065, [206] = 15079, [207] = 15084, [202] = 15086}
    },
    ["autumn"] = {
        display_name = "Autumn"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 3
        replacements = {[208] = 15066, [206] = 15077, [207] = 15082, [205] = 15081, [199] = 15085, [197] = 15074}
    },
    ["nutcracker"] = {
        display_name = "Nutcracker"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 4
        replacements = {[208] = 15068, [202] = 15088, [209] = 15061, [200] = 15069, [197] = 15073}
    },
    ["wildwood"] = {
        display_name = "Wildwood"
        collection = SkinCollection.Harvest
        type = SkinType.LegacySkin
        order = 5
        replacements = {[211] = 15078, [210] = 15063, [203] = 15076, [201] = 15072}
    },



    ["top_shelf"] = {
        display_name = "Top Shelf"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 0
        replacements = {}
    },
    ["high_roller"] = {
        display_name = "High Roller"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 1
        replacements = {}
    },
    ["coffin_nail"] = {
        display_name = "Coffin Nail"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 2
        replacements = {}
    },
    ["dressed_to_kill"] = {
        display_name = "Dressed to Kill"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 3
        replacements = {}
    },



    ["rainbow"] = {
        display_name = "Rainbow"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 0
        replacements = {}
    },
    ["balloonicorn"] = {
        display_name = "Balloonicorn"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 1
        replacements = {}
    },
    ["sweet_dreams"] = {
        display_name = "Sweet Dreams"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 2
        replacements = {}
    },
    ["mister_cuddles"] = {
        display_name = "Mister Cuddles"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 3
        replacements = {}
    },
    ["blue_mew"] = {
        display_name = "Blue Mew"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 4
        replacements = {}
    },
    ["shot_to_hell"] = {
        display_name = "Shot to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 5
        replacements = {}
    },
    ["torqued_to_hell"] = {
        display_name = "Torqued to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 6
        replacements = {}
    },
    ["stabbed_to_hell"] = {
        display_name = "Stabbed to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 7
        replacements = {}
    },
    ["brain_candy"] = {
        display_name = "Brain Candy"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 8
        replacements = {}
    },
    ["flower_power"] = {
        display_name = "Flower Power"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 9
        replacements = {}
    },



    ["killer_bee"] = {
        display_name = "Killer Bee"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 0
        replacements = {}
    },
    ["warhawk"] = {
        display_name = "Warhawk"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 1
        replacements = {}
    },
    ["red_bear"] = {
        display_name = "Red Bear"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 2
        replacements = {}
    },
    ["butcher_bird"] = {
        display_name = "Butcher Bird"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 3
        replacements = {}
    },
    ["airwolf"] = {
        display_name = "Airwolf"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 4
        replacements = {}
    },
    ["blitzkrieg"] = {
        display_name = "Blitzkrieg"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 5
        replacements = {}
    },
    ["corsair"] = {
        display_name = "corsair"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 6
        replacements = {}
    },



    ["park_pigmented"] = {
        display_name = "Park Pigmented"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 0
        id = 301
    },
}

::FilterSkins <- function(collection_index)
{
    local skin_array = [];
    foreach(skinidname, skin_table in SKINS)
    {
        if(skin_table.collection == collection_index)
        {
            local table = skin_table
            table.id <- skinidname
            skin_array.append(table);
        }
    }
    skin_array.sort(SortSkins);
    return skin_array;
}

::SortSkins <- function(a,b)
{
    if(a.order > b.order) return 1;
    if(a.order < b.order) return -1;
    return 0;
}

function GenerateSelectCollectionMenu()
{
    local menu = class extends Menu{id = "weapon_mod_skins"; items = []};
    menu.items.append(class extends MenuItem
    {
        titles = ["Unequip Skin"];

        function GenerateDesc(player)
        {
            return "Unequips your currently equipped skin / warpaint."
        }

        function OnSelected(player)
        {
            Cookies.Set(player, "skin", null);
        }
    })
    for (local collection_index = 0; collection_index < SkinCollection.MAX; collection_index++)
    {
        menu.items.append(class extends MenuItem
        {
            collection_name = SkinCollectionName[collection_index];
            titles = [SkinCollectionName[collection_index] + " Collection"];

            function GenerateDesc(player)
            {
                return "Select a skin to equip inside of the " + collection_name + " Collection."
            }

            function OnSelected(player)
            {
                player.GoToMenu("weapon_mod_skins_" + ToSnakecase(collection_name))
            }
        })
    }
    DefineMenu(menu);
}
GenerateSelectCollectionMenu();

function GenerateSkinSelectCollectionMenu()
{
    for (local collection_index = 0; collection_index < SkinCollection.MAX; collection_index++)
    {
        local skin_collection = FilterSkins(collection_index)
        local menu = class extends Menu{id = "weapon_mod_skins_" + ToSnakecase(SkinCollectionName[collection_index]); items = []};
        foreach(skin_table in skin_collection)
        {
            menu.items.append(class extends MenuItem
            {
                skin = skin_table
                titles = [skin_table.display_name];

                function GenerateDesc(player)
                {
                    if(skin.type == SkinType.LegacySkin)
                        if(skin.replacements.len() == 1)
                            return "Equip the " + titles[0] + " skin.\nApplies to the " + LookupStockFromSingularReplacementTable(skin.replacements) + ".";
                        else
                            return "Equip the " + titles[0] + " skin.\nApplies to " + skin.replacements.len() + " weapons.";
                    else
                        return "Equip the " + titles[0] + " skin.\nApplies to warpaintable weapons.";
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "skin", skin_table.id);
                }
            })
        }
        DefineMenu(menu);
    }
}
GenerateSkinSelectCollectionMenu();