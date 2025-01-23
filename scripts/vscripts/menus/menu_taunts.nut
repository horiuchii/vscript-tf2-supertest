::TAUNTS <- {
    [TF_CLASS_SCOUT] = {
        [1117] = "Battin' a Thousand",
        [1119] = "Deep Fried Desire",
        [1168] = "Carlton",
        [1197] = "Scooty Scoot",
        [30572] = "Boston Breakdance",
        [30917] = "Trackman's Touchdown",
        [30920] = "Bunnyhopper",
        [30921] = "Runner's Rhythm",
        [31156] = "Boston Boarder",
        [31161] = "Spin-to-Win",
        [31233] = "Homerunner's Hobby",
        [31354] = "Killer Signature",
        [31414] = "Foul Play",
        [31466] = "Peace Out"
    },
    [TF_CLASS_SOLDIER] = {
        [1113] = "Fresh Brewed Victory",
        [1196] = "Panzer Pants",
        [30673] = "Soldier's Requiem",
        [30761] = "Fubar Fanfare",
        [31155] = "Rocket Jockey",
        [31202] = "Profane Puppeteer",
        [31347] = "Star-Spangled Strategy",
        [31381] = "Neck Snap",
        [31438] = "Can It!"
    },
    [TF_CLASS_PYRO] = {
        [1112] = "Party Trick",
        [30570] = "Pool Party",
        [30763] = "Balloonibouncer",
        [30919] = "Skating Scorcher",
        [31157] = "Scorcher's Solo",
        [31239] = "Hot Wheeler",
        [31322] = "Roasty Toasty",
        [31439] = "Cremator's Condolences"
    },
    [TF_CLASS_DEMOMAN] = {
        [1114] = "Spent Well Spirits",
        [1120] = "Oblooterated",
        [30671] = "Bad Pipes",
        [30840] = "Scotsmann's Stagger",
        [31153] = "Pooped Deck",
        [31201] = "Drunken Sailor",
        [31291] = "Drunk Mann's Cannon",
        [31292] = "Shanty Shipmate",
        [31380] = "Roar O'War",
        [31493] = "Fore-Head Slice"
    },
    [TF_CLASS_HEAVY] = {
        [1174] = "Table Tantrum",
        [1175] = "Boiling Point",
        [30616] = "Proletariat Posedown",
        [30843] = "Russian Arms Race",
        [30844] = "Soviet Strongarm",
        [31207] = "Bare Knuckle Beatdown",
        [31320] = "Russian Rubdown",
        [31352] = "Road Rager",
        [31465] = "Crushing Defeat"
    },
    [TF_CLASS_ENGINEER] = {
        [1115] = "Rancho Relaxo",
        [30618] = "Bucking Bronco",
        [30842] = "Dueling Banjo",
        [30845] = "Jumping Jack",
        [31160] = "Texas Truckin",
        [31286] = "Texas Twirl 'Em"
    },
    [TF_CLASS_MEDIC] = {
        [477] = "Meet the Medic",
        [1109] = "Results Are In",
        [30918] = "Surgeon's Squeezebox",
        [31154] = "Time Out Therapy",
        [31203] = "Mannbulance!",
        [31236] = "Doctor's Defibrillators",
        [31349] = "Head Doctor",
        [31382] = "Borrowed Bones"
    },
    [TF_CLASS_SNIPER] = {
        [1116] = "I See You",
        [30609] = "Killer Solo",
        [30614] = "Most Wanted",
        [30839] = "Didgeridrongo",
        [31237] = "Shooter's Stakeout",
        [31440] = "Straight Shooter Tutor"
    },
    [TF_CLASS_SPY] = {
        [1108] = "Buy A Life",
        [30615] = "Box Trot",
        [30762] = "Disco Fever",
        [30922] = "Luxury Lounge",
        [31289] = "The Crypt Creeper",
        [31290] = "Travel Agent",
        [31321] = "Tailored Terminal",
        [31351] = "Teufort Tango",
        [31468] = "The Punchline",
        [31491] = "Curtain Call"
    }
}

::ALLCLASS_TAUNTS <- {
    [167] = "High Five!",
    [438] = "Director's Vision",
    [463] = "Schadenfreude",
    [1015] = "Shred Alert",
    [1106] = "Square Dance",
    [1107] = "Flippin' Awesome",
    [1110] = "Rock, Paper, Scissors",
    [1111] = "Skullcracker",
    [1118] = "Conga",
    [1157] = "Kazotsky Kick",
    [1162] = "Mannrobics",
    [1172] = "Victory Lap",
    [1182] = "Yeti Punch",
    [1183] = "Yeti Smash",
    [30621] = "Burstchester",
    [30672] = "Zoomin' Broom",
    [30816] = "Second Rate Sorcery",
    [31162] = "Fist Bump",
    [31288] = "The Scaredy-cat!",
    [31348] = "Killer Joke",
    [31467] = "Commending Clap",
    [31412] = "Cheers!",
    [31413] = "Mourning Mercs",
    [31441] = "Unleashed Rage",
    [31492] = "Peace!"
}


DefineMenu(class extends Menu{
    id = "taunts"
    items = [
    class extends MenuItem{
        titles = ["Current Class"];

        function GenerateDesc(player)
        {
            return "Pick any taunt to perform as a "+UpperFirst(TF_CLASSES[player.GetPlayerClass() - 1])+".";
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts_" + TF_CLASSES[player.GetPlayerClass()-1])
        }
    },
    class extends MenuItem{
        titles = ["All-Class Taunts"];

        function GenerateDesc(player)
        {
            return "Pick a taunt you can perform as any class.";
        }

        function OnSelected(player)
        {
            player.GoToMenu("taunts_allclass")
        }
    }
    ]
})

::SortTaunts <- function(a,b)
{
    if(a.id > b.id) return 1;
    if(a.id < b.id) return -1;
    return 0;
}

function GenerateClassTauntSelectMenu()
{
    foreach(index, name in TF_CLASSES)
    {
        local menu = class extends Menu{id = "taunts_" + name; items = []};
        local menuitems = [];
        foreach(taunt_index, taunt_name_ in TAUNTS[index+1])
        {
            menuitems.append(class extends MenuItem
            {
                taunt_name = taunt_name_;
                id = taunt_index;
                titles = [taunt_name_];

                function GenerateDesc(player)
                {
                    return taunt_name.find("!") != null ? "Perform the "+taunt_name : "Perform the "+taunt_name+".";
                }

                function OnSelected(player)
                {
                    player.CloseMenu()
                    player.ForceTaunt(id)
                }
            })
        }
        menuitems.sort(SortTaunts)
        menu.items = menuitems;
        DefineMenu(menu);
    }
}
GenerateClassTauntSelectMenu();

function GenerateAllClassTauntSelectMenu()
{
    local menu = class extends Menu{id = "taunts_allclass"; items = []};
    local menuitems = [];
    foreach(taunt_index, taunt_name_ in ALLCLASS_TAUNTS)
    {
        menuitems.append(class extends MenuItem
        {
            taunt_name = taunt_name_;
            id = taunt_index;
            titles = [taunt_name_];

            function GenerateDesc(player)
            {
                return taunt_name.find("!") != null ? "Perform the "+taunt_name : "Perform the "+taunt_name+".";
            }

            function OnSelected(player)
            {
                player.CloseMenu()
                player.ForceTaunt(id)
            }
        })
    }
    menuitems.sort(SortTaunts)
    menu.items = menuitems;
    DefineMenu(menu);
}
GenerateAllClassTauntSelectMenu();