DefineMenu(class extends Menu{
    id = "stats"
    menu_name = "stats"
    function constructor(){
        items = [
            class extends MenuItem{
                titles = [];

                function OnMenuOpened(player){
                    local pre = "Weapons ("
                    local classes = ["All Classes" "Scout" "Soldier" "Pyro" "Demoman" "Heavy" "Engineer" "Medic" "Sniper" "Spy"]
                    titles = []
                    foreach (class_name in classes)
                    {
                        titles.append(pre + class_name + ")")
                    }
                }

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(weapon in WEAPONS)
                    {
                        if("variant" in weapon && weapon["variant"])
                            continue;
                        
                        if(index != 0)
                        {
                            local class_index = TF_CLASS_REMAP_INV[index - 1];

                            if("used_by_classes" in weapon && weapon["used_by_classes"].find(class_index) == null)
                                continue;
                        }

                        count++;
                    }

                    local subtract_count = 0;
                    
                    if(index == 0)
                    {
                        //minus three for the four class shotgun variants
                        //minus one for the two pistol variants
                        //minus one for engi's panic attack
                        subtract_count += 5;
                    }

                    local pre = "";
                    switch(index)
                    {
                        case 0: pre = "There are"; break;
                        case 1: pre = "Scout has"; break;
                        case 2: pre = "Soldier has"; break;
                        case 3: pre = "Pyro has"; break;
                        case 4: pre = "Demoman has"; break;
                        case 5: pre = "Heavy has"; break;
                        case 6: pre = "Engineer has"; break;
                        case 7: pre = "Medic has"; break;
                        case 8: pre = "Sniper has"; break;
                        case 9: pre = "Spy has"; break;
                    }

                    return pre + " a total of " + (count - subtract_count) + " unique weapons.";
                }
            },
            class extends MenuItem{
                titles = [];

                function OnMenuOpened(player){
                    local pre = "Weapons + Reskins ("
                    local classes = ["All Classes" "Scout" "Soldier" "Pyro" "Demoman" "Heavy" "Engineer" "Medic" "Sniper" "Spy"]
                    titles = []
                    foreach (class_name in classes)
                    {
                        titles.append(pre + class_name + ")")
                    }
                }

                function GenerateDesc(player)
                {
                    local count = 0;

                    if(index == 0)
                    {
                        count = WEAPONS.len()
                    }
                    else
                    {
                        foreach(weapon in WEAPONS)
                        {
                            local class_index = TF_CLASS_REMAP_INV[index - 1];

                            if("used_by_classes" in weapon && weapon["used_by_classes"].find(class_index) == null)
                                continue;

                            count++;
                        }
                    }

                    //minus one for envballs
                    local subtract_count = 1;
                    
                    if(index == 0)
                    {
                        //minus one for engi's panic attack
                        //minus three for the four class shotgun variants
                        //minus three for the four class shotgun festive variants
                        //minus one for the two pistol variants
                        subtract_count += 8;
                    }

                    if(index == 0 || TF_CLASS_REMAP_INV[index - 1] == TF_CLASS_SOLDIER)
                    {
                        //minus one for valve rocket launcher
                        subtract_count += 1;
                    }

                    local pre = "";
                    switch(index)
                    {
                        case 0: pre = "There are"; break;
                        case 1: pre = "Scout has"; break;
                        case 2: pre = "Soldier has"; break;
                        case 3: pre = "Pyro has"; break;
                        case 4: pre = "Demoman has"; break;
                        case 5: pre = "Heavy has"; break;
                        case 6: pre = "Engineer has"; break;
                        case 7: pre = "Medic has"; break;
                        case 8: pre = "Sniper has"; break;
                        case 9: pre = "Spy has"; break;
                    }

                    return pre + " a total of " + (count - subtract_count) + " weapons, including\nreskins, festives, austrailiums and botkillers.";
                }
            },
            class extends MenuItem{
                titles = ["Weapons Skins"];

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(skin in SKINS)
                    {
                        if(skin.type != SkinType.LegacySkin)
                            continue;
                        
                        count++;
                    }

                    return "There are a total of " + count + " legacy skins\nfor weapons from Gun Mettle.";
                }
            },
            class extends MenuItem{
                titles = ["Weapons Skin Variants"];

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(skin in SKINS)
                    {
                        if(skin.type != SkinType.LegacySkin)
                            continue;
                        
                        count += skin.replacements.len();
                    }

                    return "There are a total of " + count + " legacy\nskins + weapon variants from Tough Break.";
                }
            },
            class extends MenuItem{
                titles = ["War Paints"];

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(skin in SKINS)
                    {
                        if(skin.type != SkinType.Warpaint)
                            continue;
                        
                        count++;
                    }

                    return "There are a total of " + count + " war paints.";
                }
            },
            class extends MenuItem{
                titles = ["War Paint Weapon Variants"];

                function GenerateDesc(player)
                {
                    local weapon_count = 0;

                    foreach(weapon in WEAPONS)
                    {
                        if(!("flags" in weapon))
                            continue;
                        
                        if(!(weapon.flags & FLAG_WARPAINT_AND_UNUSUAL))
                            continue;
                        
                        weapon_count++;
                    }

                    local skin_count = 0;

                    foreach(skin in SKINS)
                    {
                        if(skin.type != SkinType.Warpaint)
                            continue;
                        
                        skin_count++;
                    }

                    return "There are a total of " + (skin_count * weapon_count) + " unique war paint +\nweapon combo, not including unusual or wear.";
                }
            }
            class extends MenuItem{
                titles = [];

                function OnMenuOpened(player){
                    local pre = "Cosmetics ("
                    local classes = ["All Classes" "Scout" "Soldier" "Pyro" "Demoman" "Heavy" "Engineer" "Medic" "Sniper" "Spy"]
                    titles = []
                    foreach (class_name in classes)
                    {
                        titles.append(pre + class_name + ")")
                    }
                }

                function GenerateDesc(player)
                {
                    local allclass_count = 0;
                    local count = 0;

                    foreach(cosmetic in COSMETICS)
                    {
                        if(cosmetic.type != CosmeticType.Normal)
                            continue;
                        
                        if(index == 0)
                        {
                            count++;

                            if(!("classes" in cosmetic))
                            {
                                allclass_count++;
                            }
                        }
                        else if("classes" in cosmetic && cosmetic["classes"].find(TF_CLASS_REMAP_INV[index - 1]) != null)
                        {
                            count++;
                        }
                    }

                    local subtract_count = 0;
                    
                    if(index == 0)
                    {
                        //subtract one for the autogrant pyrovision
                        //subtract nine for the gatebot light
                        subtract_count += 10;
                    }

                    if(index != 0)
                    {
                        //minus one for the class' gatebot light
                        subtract_count += 1;

                        if(TF_CLASS_REMAP_INV[index - 1] == TF_CLASS_PYRO)
                        {
                            //subtract one for the autogrant pyrovision
                            subtract_count += 1;
                        }
                    }

                    local pre = "";
                    switch(index)
                    {
                        case 0: pre = "There are"; break;
                        case 1: pre = "Scout has"; break;
                        case 2: pre = "Soldier has"; break;
                        case 3: pre = "Pyro has"; break;
                        case 4: pre = "Demoman has"; break;
                        case 5: pre = "Heavy has"; break;
                        case 6: pre = "Engineer has"; break;
                        case 7: pre = "Medic has"; break;
                        case 8: pre = "Sniper has"; break;
                        case 9: pre = "Spy has"; break;
                    }
                    return pre + " a total of " + (count - subtract_count) + " cosmetics" + (index == 0 ? ",\nwith " + allclass_count + " of them being all-class. " : "\nthat aren't all-class.");
                }
            },
            class extends MenuItem{
                titles = ["Cosmetic Unusuals"];

                function GenerateDesc(player)
                {
                    local count = 0;
                    local count_team = 0;

                    foreach(unusual in UNUSUALS)
                    {
                        if(unusual.type != UnusualType.Cosmetic)
                            continue;
                        
                        count++;

                        if("team" in unusual && unusual["team"])
                            count_team++;
                    }

                    //minus two for flying bits and map stamps
                    return "There are a total of " + (count - 2) + " cosmetic unusuals,\nwith " + count_team + " of them being team colored.";
                }
            },
            class extends MenuItem{
                titles = [];

                function OnMenuOpened(player){
                    local pre = "Taunts ("
                    local classes = ["All Classes" "Scout" "Soldier" "Pyro" "Demoman" "Heavy" "Engineer" "Medic" "Sniper" "Spy"]
                    titles = []
                    foreach (class_name in classes)
                    {
                        titles.append(pre + class_name + ")")
                    }
                }

                function GenerateDesc(player)
                {
                    local allclass_count = 0;
                    local count = 0;

                    foreach(taunt in TAUNTS)
                    {
                        if(index == 0)
                        {
                            count++;

                            if(!("classes" in taunt))
                            {
                                allclass_count++;
                            }
                        }
                        else if("classes" in taunt && taunt["classes"].find(TF_CLASS_REMAP_INV[index - 1]) != null)
                        {
                            count++;
                        }
                    }

                    local pre = "";
                    switch(index)
                    {
                        case 0: pre = "There are"; break;
                        case 1: pre = "Scout has"; break;
                        case 2: pre = "Soldier has"; break;
                        case 3: pre = "Pyro has"; break;
                        case 4: pre = "Demoman has"; break;
                        case 5: pre = "Heavy has"; break;
                        case 6: pre = "Engineer has"; break;
                        case 7: pre = "Medic has"; break;
                        case 8: pre = "Sniper has"; break;
                        case 9: pre = "Spy has"; break;
                    }

                    return pre + " a total of " + (index == 0 ? TAUNTS.len() : count) + " taunts" + (index == 0 ? ",\nwith " + allclass_count + " of them being all-class." : "\nthat aren't all-class.");
                }
            },
            class extends MenuItem{
                titles = ["Taunt Unusuals"];

                function GenerateDesc(player)
                {
                    local count = 0;
                    local count_team = 0;

                    foreach(unusual in UNUSUALS)
                    {
                        if(unusual.type != UnusualType.Taunt)
                            continue;
                        
                        count++;

                        if("team" in unusual && unusual["team"])
                            count_team++;
                    }

                    return "There are a total of " + count + " taunt unusuals,\nwith " + count_team + " of them being team colored.";
                }
            },
            class extends MenuItem{
                titles = ["Community Medals"];

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(cosmetic in COSMETICS)
                    {
                        if(cosmetic.type != CosmeticType.CommunityMedal)
                            continue;
                        
                        count++;
                    }

                    return "There are a total of " + count + " community medals.";
                }
            },
            class extends MenuItem{
                titles = ["Tournament Medals"];

                function GenerateDesc(player)
                {
                    local count = 0;

                    foreach(cosmetic in COSMETICS)
                    {
                        if(cosmetic.type != CosmeticType.TournamentMedal)
                            continue;
                        
                        count++;
                    }

                    return "There are a total of " + count + " tournament medals.";
                }
            },
        ]
    }
})