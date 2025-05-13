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
    "Contract Campaigner"

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
        replacements = {[202] = 15125, [197] = 15140, [206] = 15117, [194] = 15119, [210] = 15128}
    },
    ["high_roller"] = {
        display_name = "High Roller"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 1
        replacements = {[211] = 15122, [203] = 15134, [205] = 15130}
    },
    ["coffin_nail"] = {
        display_name = "Coffin Nail"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 2
        replacements = {[205] = 15129, [200] = 15131, [199] = 15132, [206] = 15116, [208] = 15115, [211] = 15123, [202] = 15123, [210] = 15127, [201] = 15135, [207] = 15137}
    },
    ["dressed_to_kill"] = {
        display_name = "Dressed to Kill"
        collection = SkinCollection.Gentlemanne
        type = SkinType.LegacySkin
        order = 3
        replacements = {[194] = 15118, [211] = 15121, [202] = 15124, [209] = 15126, [199] = 15133, [201] = 15136, [207] = 15138, [197] = 15139}
    },



    ["rainbow"] = {
        display_name = "Rainbow"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 0
        replacements = {[206] = 15091, [201] = 15112, [208] = 15090}
    },
    ["balloonicorn"] = {
        display_name = "Balloonicorn"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 1
        replacements = {[201] = 15112, [208] = 15089}
    },
    ["sweet_dreams"] = {
        display_name = "Sweet Dreams"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 2
        replacements = {[206] = 15092, [207] = 15113}
    },
    ["mister_cuddles"] = {
        display_name = "Mister Cuddles"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 3
        replacements = {[202] = 15099}
    },
    ["blue_mew"] = {
        display_name = "Blue Mew"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 4
        replacements = {[194] = 15094, [209] = 15100, [205] = 15104, [200] = 15106, [203] = 15110}
    },
    ["shot_to_hell"] = {
        display_name = "Shot to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 5
        replacements = {[200] = 15108, [209] = 15102}
    },
    ["torqued_to_hell"] = {
        display_name = "Torqued to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 6
        replacements = {[197] = 15114}
    },
    ["stabbed_to_hell"] = {
        display_name = "Stabbed to Hell"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 7
        replacements = {[194] = 15096}
    },
    ["brain_candy"] = {
        display_name = "Brain Candy"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 8
        replacements = {[194] = 15095, [202] = 15098, [209] = 15101, [205] = 15105}
    },
    ["flower_power"] = {
        display_name = "Flower Power"
        collection = SkinCollection.Pyroland
        type = SkinType.LegacySkin
        order = 9
        replacements = {[211] = 15097, [210] = 15103, [200] = 15107, [199] = 15109}
    },



    ["killer_bee"] = {
        display_name = "Killer Bee"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 0
        replacements = {[200] = 15151}
    },
    ["warhawk"] = {
        display_name = "Warhawk"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 1
        replacements = {[205] = 15150, [206] = 15142, [208] = 15141}
    },
    ["red_bear"] = {
        display_name = "Red Bear"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 2
        replacements = {[199] = 15152}
    },
    ["butcher_bird"] = {
        display_name = "Butcher Bird"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 3
        replacements = {[202] = 15147, [206] = 15158}
    },
    ["airwolf"] = {
        display_name = "Airwolf"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 4
        replacements = {[201] = 15154, [194] = 15144, [197] = 15156}
    },
    ["blitzkrieg"] = {
        display_name = "Blitzkrieg"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 5
        replacements = {[207] = 15155, [211] = 15145, [209] = 15148, [210] = 15149, [203] = 15153, [194] = 15143}
    },
    ["corsair"] = {
        display_name = "Corsair"
        collection = SkinCollection.Warbird
        type = SkinType.LegacySkin
        order = 6
        replacements = {[211] = 15146, [200] = 15157}
    },



    ["park_pigmented"] = {
        display_name = "Park Pigmented"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 0
        index = 301
    },
    ["sax_waxed"] = {
        display_name = "Sax Waxed"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 1
        index = 304
    },
    ["yeti_coated"] = {
        display_name = "Yeti Coated"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 2
        index = 300
    },
    ["croc_dusted"] = {
        display_name = "Croc Dusted"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 3
        index = 308
    },
    ["macaw_masked"] = {
        display_name = "Macaw Masked"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 4
        index = 303
    },
    ["pina_polished"] = {
        display_name = "Piña Polished"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 5
        index = 309
    },
    ["anodized_aloha"] = {
        display_name = "Anodized Aloha"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 6
        index = 305
    },
    ["bamboo_brushed"] = {
        display_name = "Bamboo Brushed"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 7
        index = 306
    },
    ["leopard_printed"] = {
        display_name = "Leopard Printed"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 8
        index = 310
    },
    ["mannana_peeled"] = {
        display_name = "Mannana Peeled"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 9
        index = 302
    },
    ["tiger_buffed"] = {
        display_name = "Tiger Buffed"
        collection = SkinCollection.JungleInferno1
        type = SkinType.Warpaint
        order = 10
        index = 307
    },



    ["fire_glazed"] = {
        display_name = "Fire Glazed"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 0
        index = 205
    },
    ["bonk_varnished"] = {
        display_name = "Bonk Varnished"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 1
        index = 207
    },
    ["dream_piped"] = {
        display_name = "Dream Piped"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 2
        index = 212
    },
    ["freedom_wrapped"] = {
        display_name = "Freedom Wrapped"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 3
        index = 210
    },
    ["bank_rolled"] = {
        display_name = "Bank Rolled"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 4
        index = 202
    },
    ["clover_camo"] = {
        display_name = "Clover Camo'd"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 5
        index = 209
    },
    ["kill_covered"] = {
        display_name = "Kill Covered"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 6
        index = 204
    },
    ["pizza_polished"] = {
        display_name = "Pizza Polished"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 7
        index = 206
    },
    ["bloom_buffed"] = {
        display_name = "Bloom Buffed"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 8
        index = 200
    },
    ["cardboard_boxed"] = {
        display_name = "Cardboard Boxed"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 9
        index = 211
    },
    ["merc_stained"] = {
        display_name = "Merc Stained"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 10
        index = 203
    },
    ["quack_canvassed"] = {
        display_name = "Quack Canvassed"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 11
        index = 201
    },
    ["star_crossed"] = {
        display_name = "Star Crossed"
        collection = SkinCollection.JungleInferno2
        type = SkinType.Warpaint
        order = 12
        index = 208
    },



    ["carpet_bomber_mk2"] = {
        display_name = "Carpet Bomber Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 0
        index = 104
    },
    ["woodland_warrior_mk2"] = {
        display_name = "Woodland Warrior Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 1
        index = 106
    },
    ["wrapped_reviver_mk2"] = {
        display_name = "Wrapped Reviver Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 2
        index = 102
    },
    ["forest_fire_mk2"] = {
        display_name = "Forest Fire Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 3
        index = 109
    },
    ["night_owl_mk2"] = {
        display_name = "Night Owl Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 4
        index = 114
    },
    ["woodsy_widowmaker_mk2"] = {
        display_name = "Woodsy Widowmaker Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 5
        index = 113
    },
    ["autumn_mk2"] = {
        display_name = "Autumn Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 6
        index = 160
    },
    ["plaid_potshotter_mk2"] = {
        display_name = "Plaid Potshotter Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 7
        index = 122
    },
    ["civil_servant_mk2"] = {
        display_name = "Civil Servant Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 8
        index = 139
    },
    ["civic_duty_mk2"] = {
        display_name = "Civic Duty Mk.II"
        collection = SkinCollection.JungleInferno3
        type = SkinType.Warpaint
        order = 9
        index = 144
    },



    ["bovine_blazemaker_mk2"] = {
        display_name = "Bovine Blazemaker Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 0
        index = 130
    },
    ["dead_reckoner_mk2"] = {
        display_name = "Dead Reckoner Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 1
        index = 151
    },
    ["backwoods_boomstick_mk2"] = {
        display_name = "Backwoods Boomstick Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 2
        index = 112
    },
    ["masked_mender_mk2"] = {
        display_name = "Masked Mender Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 3
        index = 105
    },
    ["iron_wood_mk2"] = {
        display_name = "Iron Wood Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 4
        index = 120
    },
    ["macabre_web_mk2"] = {
        display_name = "Macabre Web Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 5
        index = 163
    },
    ["nutcracker_mk2"] = {
        display_name = "Nutcracker Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 6
        index = 161
    },
    ["smalltown_bringdown_mk2"] = {
        display_name = "Smalltown Bringdown Mk.II"
        collection = SkinCollection.JungleInferno4
        type = SkinType.Warpaint
        order = 7
        index = 143
    },



    ["dragon_slayer"] = {
        display_name = "Dragon Slayer"
        collection = SkinCollection.SaxtonSelect
        type = SkinType.Warpaint
        order = 0
        index = 390
    },



    ["smissmas_sweater"] = {
        display_name = "Smissmas Sweater"
        collection = SkinCollection.Event
        type = SkinType.Warpaint
        order = 0
        index = 391
    },



    ["miami_element"] = {
        display_name = "Miami Element"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 0
        index = 213
    },
    ["jazzy"] = {
        display_name = "Jazzy"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 1
        index = 230
    },
    ["mosaic"] = {
        display_name = "Mosaic"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 2
        index = 228
    },
    ["cosmic_calamity"] = {
        display_name = "Cosmic Calamity"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 3
        index = 225
    },
    ["hana"] = {
        display_name = "Hana"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 4
        index = 223
    },
    ["neo_tokyo"] = {
        display_name = "Neo Tokyo"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 5
        index = 214
    },
    ["uranium"] = {
        display_name = "Uranium"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 6
        index = 218
    },
    ["alien_tech"] = {
        display_name = "Alien Tech"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 7
        index = 232
    },
    ["bomber_soul"] = {
        display_name = "Bomber Soul"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 8
        index = 217
    },
    ["cabin_fevered"] = {
        display_name = "Cabin Fevered"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 9
        index = 220
    },
    ["damascus_and_mahogany"] = {
        display_name = "Damascus and Mahogany"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 10
        index = 234
    },
    ["dovetailed"] = {
        display_name = "Dovetailed"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 11
        index = 224
    },
    ["geometrical_teams"] = {
        display_name = "Geometrical Teams"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 12
        index = 215
    },
    ["hazard_warning"] = {
        display_name = "Hazard Warning"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 13
        index = 226
    },
    ["polar_suprise"] = {
        display_name = "Polar Surprise"
        collection = SkinCollection.Winter2017
        type = SkinType.Warpaint
        order = 14
        index = 221
    },

    ["electroshocked"] = {
        display_name = "Electroshocked"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 0
        index = 241
    },
    ["ghost_town"] = {
        display_name = "Ghost Town"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 1
        index = 242
    },
    ["tumor_toasted"] = {
        display_name = "Tumor Toasted"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 2
        index = 243
    },
    ["calavera_canvas"] = {
        display_name = "Calavera Canvas"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 3
        index = 244
    },
    ["spectral_shimmered"] = {
        display_name = "Spectral Shimmered"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 4
        index = 237
    },
    ["skull_study"] = {
        display_name = "Skull Study"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 5
        index = 235
    },
    ["haunted_ghosts"] = {
        display_name = "Haunted Ghosts"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 6
        index = 236
    },
    ["horror_holiday"] = {
        display_name = "Horror Holiday"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 7
        index = 239
    },
    ["spirit_of_halloween"] = {
        display_name = "Spirit of Halloween"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 8
        index = 238
    },
    ["totally_boned"] = {
        display_name = "Totally Boned"
        collection = SkinCollection.Halloween2018
        type = SkinType.Warpaint
        order = 9
        index = 240
    },



    ["winterland_wrapped"] = {
        display_name = "Winterland Wrapped"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 0
        index = 254
    },
    ["smissmas_camo"] = {
        display_name = "Smissmas Camo"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 1
        index = 250
    },
    ["smissmas_village"] = {
        display_name = "Smissmas Village"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 2
        index = 247
    },
    ["frost_ornamented"] = {
        display_name = "Frost Ornamented"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 3
        index = 246
    },
    ["sleighin_style"] = {
        display_name = "Sleighin' Style"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 4
        index = 251
    },
    ["snow_covered"] = {
        display_name = "Snow Covered"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 5
        index = 245
    },
    ["alpine"] = {
        display_name = "Alpine"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 6
        index = 252
    },
    ["gift_wrapped"] = {
        display_name = "Gift Wrapped"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 7
        index = 253
    },
    ["igloo"] = {
        display_name = "Igloo"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 8
        index = 248
    },
    ["seriously_snowed"] = {
        display_name = "Seriously Snowed"
        collection = SkinCollection.Winter2019
        type = SkinType.Warpaint
        order = 9
        index = 249
    },



    ["spectrum_splattered"] = {
        display_name = "Spectrum Splattered"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 0
        index = 257
    },
    ["pumpkin_pied"] = {
        display_name = "Pumpkin Pied"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 1
        index = 259
    },
    ["mummified_mimic"] = {
        display_name = "Mummified Mimic"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 2
        index = 268
    },
    ["helldriver"] = {
        display_name = "Helldriver"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 3
        index = 255
    },
    ["sweet_toothed"] = {
        display_name = "Sweet Toothed"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 4
        index = 260
    },
    ["crawlspace_critters"] = {
        display_name = "Crawlspace Critters"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 5
        index = 261
    },
    ["raving_dead"] = {
        display_name = "Raving Dead"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 6
        index = 264
    },
    ["spiders_cluster"] = {
        display_name = "Spider's Cluster"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 7
        index = 266
    },
    ["candy_coated"] = {
        display_name = "Candy Coated"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 8
        index = 258
    },
    ["portal_plastered"] = {
        display_name = "Portal Plastered"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 9
        index = 262
    },
    ["death_deluxe"] = {
        display_name = "Death Deluxe"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 10
        index = 263
    },
    ["eyestalker"] = {
        display_name = "Eyestalker"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 11
        index = 265
    },
    ["gourdy_green"] = {
        display_name = "Gourdy Green"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 12
        index = 267
    },
    ["spider_season"] = {
        display_name = "Spider Season"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 13
        index = 269
    },
    ["organically_hellraised"] = {
        display_name = "Organ-ically Hellraised"
        collection = SkinCollection.Halloween2020
        type = SkinType.Warpaint
        order = 14
        index = 256
    },



    ["starlight_serenity"] = {
        display_name = "Starlight Serenity"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 0
        index = 280
    },
    ["saccharine_striped"] = {
        display_name = "Saccharine Striped"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 1
        index = 271
    },
    ["frosty_delivery"] = {
        display_name = "Frosty Delivery"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 2
        index = 281
    },
    ["cookie_fortress"] = {
        display_name = "Cookie Fortress"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 3
        index = 283
    },
    ["frozen_aurora"] = {
        display_name = "Frozen Aurora"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 4
        index = 279
    },
    ["elfin_enamel"] = {
        display_name = "Elfin Enamel"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 5
        index = 272
    },
    ["smissmas_spycrabs"] = {
        display_name = "Smissmas Spycrabs"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 6
        index = 278
    },
    ["gingerbread_winner"] = {
        display_name = "Gingerbread Winner"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 7
        index = 270
    },
    ["peppermint_swirl"] = {
        display_name = "Peppermint Swirl"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 8
        index = 273
    },
    ["gifting_manns_wrapping_paper"] = {
        display_name = "Gifting Mann's Wrapping Paper"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 9
        index = 276
    },
    ["glacial_glazed"] = {
        display_name = "Glacial Glazed"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 10
        index = 282
    },
    ["snow_globalization"] = {
        display_name = "Snow Globalization"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 11
        index = 275
    },
    ["snowflake_swirled"] = {
        display_name = "Snowflake Swirled"
        collection = SkinCollection.Winter2020
        type = SkinType.Warpaint
        order = 12
        index = 277
    },



    ["misfortunate"] = {
        display_name = "Misfortunate"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 0
        index = 287
    },
    ["broken_bones"] = {
        display_name = "Broken Bones"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 1
        index = 291
    },
    ["party_phantoms"] = {
        display_name = "Party Phantoms"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 2
        index = 294
    },
    ["necromanced"] = {
        display_name = "Necromanced"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 3
        index = 297
    },
    ["neon_ween"] = {
        display_name = "Neon-ween"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 4
        index = 289
    },
    ["polter_guised"] = {
        display_name = "Polter-Guised"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 5
        index = 295
    },
    ["swashbuckled"] = {
        display_name = "Swashbuckled"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 6
        index = 285
    },
    ["kiln_and_conquer"] = {
        display_name = "Kiln and Conquer"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 7
        index = 296
    },
    ["potent_poison"] = {
        display_name = "Potent Poison"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 8
        index = 292
    },
    ["sarsaparilla_sprayed"] = {
        display_name = "Sarsaparilla Sprayed"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 9
        index = 284
    },
    ["searing_souls"] = {
        display_name = "Searing Souls"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 10
        index = 293
    },
    ["simple_spirits"] = {
        display_name = "Simple Spirits"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 11
        index = 290
    },
    ["skull_cracked"] = {
        display_name = "Skull Cracked"
        collection = SkinCollection.Halloween2021
        type = SkinType.Warpaint
        order = 12
        index = 286
    },



    ["sacred_slayer"] = {
        display_name = "Sacred Slayer"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 0
        index = 403
    },
    ["bonzo_gnawed"] = {
        display_name = "Bonzo Gnawed"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 1
        index = 405
    },
    ["ghoul_blaster"] = {
        display_name = "Ghoul Blaster"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 2
        index = 400
    },
    ["metalized_soul"] = {
        display_name = "Metalized Soul"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 3
        index = 404
    },
    ["pumpkin_plastered"] = {
        display_name = "Pumpkin Plastered"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 4
        index = 409
    },
    ["chilly_autumn"] = {
        display_name = "Chilly Autumn"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 5
        index = 410
    },
    ["sunriser"] = {
        display_name = "Sunriser"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 6
        index = 402
    },
    ["health_and_hell"] = {
        display_name = "Health and Hell"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 7
        index = 406
    },
    ["health_and_hell_green"] = {
        display_name = "Health and Hell (Green)"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 8
        index = 407
    },
    ["hypergon"] = {
        display_name = "Hypergon"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 9
        index = 408
    },
    ["cream_corned"] = {
        display_name = "Cream Corned"
        collection = SkinCollection.Halloween2022
        type = SkinType.Warpaint
        order = 10
        index = 401
    },



    ["sky_stallion"] = {
        display_name = "Sky Stallion"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 0
        index = 413
    },
    ["business_class"] = {
        display_name = "Business Class"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 1
        index = 415
    },
    ["deadly_dragon"] = {
        display_name = "Deadly Dragon"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 2
        index = 416
    },
    ["mechanized_monster"] = {
        display_name = "Mechanized Monster"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 3
        index = 420
    },
    ["steel_brushed"] = {
        display_name = "Steel Brushed"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 4
        index = 411
    },
    ["warborn"] = {
        display_name = "Warborn"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 5
        index = 418
    },
    ["bomb_carrier"] = {
        display_name = "Bomb Carrier"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 6
        index = 414
    },
    ["pacific_peacemaker"] = {
        display_name = "Pacific Peacemaker"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 7
        index = 419
    },
    ["secretly_serviced"] = {
        display_name = "Pacific Peacemaker"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 8
        index = 412
    },
    ["team_serviced"] = {
        display_name = "Team Serviced"
        collection = SkinCollection.Summer2023
        type = SkinType.Warpaint
        order = 9
        index = 417
    },



    ["broken_record"] = {
        display_name = "Broken Record"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 0
        index = 432
    },
    ["necropolish"] = {
        display_name = "Necropolish"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 1
        index = 430
    },
    ["stardust"] = {
        display_name = "Stardust"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 2
        index = 421
    },
    ["graphite_gripped"] = {
        display_name = "Graphite Gripped"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 3
        index = 425
    },
    ["piranha_mania"] = {
        display_name = "Piranha Mania"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 4
        index = 427
    },
    ["stealth_specialist"] = {
        display_name = "Stealth Specialist"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 5
        index = 426
    },
    ["blackout"] = {
        display_name = "Blackout"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 6
        index = 431
    },
    ["brawlers_iron"] = {
        display_name = "Brawler's Iron"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 7
        index = 429
    },
    ["gobi_glazed"] = {
        display_name = "Gobi Glazed"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 8
        index = 423
    },
    ["sleek_greek"] = {
        display_name = "Sleek Greek"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 9
        index = 424
    },
    ["team_charged"] = {
        display_name = "Team Charged"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 10
        index = 428
    },
    ["team_detail"] = {
        display_name = "Team Detail"
        collection = SkinCollection.Halloween2024
        type = SkinType.Warpaint
        order = 11
        index = 422
    },
}

::IsSkinValid <- function(skin)
{
    return skin && skin != "null" && (skin in SKINS);
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

    skin_array.sort(function(a,b){return a.order <=> b.order;});
    return skin_array;
}

function GenerateSelectCollectionMenu()
{
    local menu = class extends Menu{id = "weapon_mod_skins"; menu_name = "skins"; items = []};
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
            player.SendChat(CHAT_PREFIX + "Unequipped your weapon override skin.");
            SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
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
                return "Select a skin to equip inside of\nthe " + collection_name + " Collection."
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
        local menu = class extends Menu{id = "weapon_mod_skins_" + ToSnakecase(SkinCollectionName[collection_index]); menu_name = ToSnakecase(SkinCollectionName[collection_index]); items = []};
        foreach(skin_table in skin_collection)
        {
            menu.items.append(class extends MenuItem
            {
                skin_id = skin_table.id
                replacements = ("replacements" in skin_table ? skin_table.replacements : null);
                titles = [skin_table.display_name];

                function GenerateDesc(player)
                {
                    local desc_prefix = "Equip the " + titles[0] + " skin.\nApplies to ";

                    if(replacements)
                    {
                        if(replacements.len() == 1)
                            return desc_prefix + "the " + LookupStockFromSingularReplacementTable(replacements) + ".";
                        else
                            return desc_prefix + replacements.len() + " stock weapons.";
                    }
                    else
                        return desc_prefix + "warpaintable weapons.";
                }

                function OnSelected(player)
                {
                    Cookies.Set(player, "skin", skin_id);
                    player.SendChat(CHAT_PREFIX + "Equipped the " + titles[0] + " as your weapon override skin.");
                    SendGlobalGameEvent("post_inventory_application" {userid = player.GetUserID()});
                }
            })
        }
        DefineMenu(menu);
    }
}
GenerateSkinSelectCollectionMenu();