--How To Use!!
-- Start With Weapon you need to augment EQUIPPED!
-- Start With Helmet on your Char!.. IF YOU REMOVE HELMET THE AUGMENTATION WILL STOP (so you can interrupt the script anytime you want)
-- Choose The Next 2 variables Correctly (Write The Exact Names with Exact Capital Letters and Same Spaces!):

local gemstoneName = "Gemstone B"
local gemstone_count = 36

------Dont Touch Under This Line---------

local npcName = "Vincenz" --  Rune Blacksmith
lifeStones = {
    "Life Stone -  Level 76",
    "Mid-Grade Life Stone -  Level 76",
    "High-Grade Life Stone -  Level 76",
    "Top-Grade Life Stone -  Level 76",
    "Life Stone -  Level 80",
    "Mid-Grade Life Stone -  Level 80",
    "High-Grade Life Stone -  Level 80",
    "Top-Grade Life Stone -  Level 80",
    "Life Stone -  Level 82",
    "Mid-Grade Life Stone -  Level 82",
    "High-Grade Life Stone -  Level 82",
    "Top-Grade Life Stone -  Level 82",
    "Life Stone -  Level 84",
    "Mid-Grade Life Stone -  Level 84",
    "High-Grade Life Stone -  Level 84",
    "Top-Grade Life Stone -  Level 84",
    "Life Stone -  Level 85",
    "Mid-Grade Life Stone -  Level 85",
    "High-Grade Life Stone -  Level 85",
    "Top-Grade Life Stone -  Level 85",
    "Life Stone -  Level 86",
    "Mid-Grade Life Stone -  Level 86",
    "High-Grade Life Stone -  Level 86",
    "Top-Grade Life Stone -  Level 86"
}


local AugStatus = 0
local count = 0
AugStatusC = 0
lifeStoneAmount = 0

function printResults()
    ShowToClient("Life Stones Used", lifeStoneAmount .. ".")
end

function getItemByName(name)
    local invList = GetInventory()
    for item in invList.list do
        if (item.Name == name) then
            return item
        end
    end
end

function openAugmentWindow(name)
    local target = GetTarget()
    if (target ~= nil) then
        if (target:GetName() ~= name) then
            Command("/target " .. name)
            Sleep(2000)
        end
    else
        Command("/target " .. name)
        Sleep(1000)
    end

    target = GetTarget()
    if (target ~= nil) and (target:GetName() == name) then
        if (name == "Vincenz") then
            Talk()
            ClickLinkAndWait("blacksmith_vincenz005.htm")
            Sleep(400)
            ClickLinkAndWait("smelting_start.htm")
            Sleep(400)
            QuestReply("menu_select?ask=-503&reply=100")
            Sleep(1500)
            return true
        end
    end
    return false
end

function openAugmentCancelWindow(name)
    count = 2
    target = GetTarget()
    if (target ~= nil) then
        if (target:GetName() ~= name) then
            Command("/target " .. name)
            Sleep(2000)
        end
    else
        Command("/target " .. name)
        Sleep(2000)
    end

    target = GetTarget()
    if (target ~= nil) and (target:GetName() == name) then
        if (name == "Vincenz") then
            Talk()
            ClickLinkAndWait("blacksmith_vincenz005.htm")
            Sleep(400)
            ClickLinkAndWait("smelting_break.htm")
            Sleep(400)
            ClickLink("menu_select?ask=-503&reply=200")
            Sleep(1400)
            return true
        end
    end
    return false
end

weaponId = GetMe():GetEquip_WeaponId()

if (weaponId == nil) or (weaponId == 0) then
    ShowToClient("AUGMENT", "You Dont have Any Weapon Equiped to augment!")
else
    weapon = GetInventory():FindById(weaponId)
    if (weapon ~= nil) and ((weapon.RefineryOp2 ~= 0) or (weapon.RefineryOp1 ~= 0)) then
        ShowToClient("AUGMENT", "You Must Start With Non Augmented weapon!")
    else
        repeat
            if (weapon.RefineryOp2 == 0) and (weapon.RefineryOp1 == 0) then
                AugStatus = 0
                lifestone = nil
                for i, v in ipairs(lifeStones) do
                    aux = getItemByName(v)
                    if aux ~= nil then
                        lifestone = aux
                    end
                end
                gemstone = getItemByName(gemstoneName)
                if (lifestone == nil) then
                    ShowToClient("AUGMENT", "Out of life stones.")
                    AugStatus = 1
                    break
                end
                if (gemstone == nil) then
                    ShowToClient("AUGMENT", "Out of gemstones.")
                    AugStatus = 1
                    break
                end
                if (gemstone.ItemNum < gemstone_count) then
                    ShowToClient("AUGMENT", "Gemstones are not enough.")
                    AugStatus = 1
                    break
                end

                AugStatusC = AugStatusC + 1
                GetAugmentManager():setItemId(weaponId)
                GetAugmentManager():setLifeStoneId(lifestone.objectId)
                GetAugmentManager():setGemstoneId(gemstone.objectId, gemstone_count)
                GetAugmentManager():Augment()
                if (openAugmentWindow(npcName) == false) then
                    ShowToClient("AUGMENT", "NPC FAIL.")
                    AugStatus = 1
                    break
                end
                lifeStoneAmount = lifeStoneAmount + 1
                repeat
                    Sleep(1000)
                    weapon = GetInventory():FindById(weaponId)
                until weapon.RefineryOp1 ~= 0

                if (weapon == nil) then
                    ShowToClient("AUGMENT", "The Weapon Couldn't be Detected!")
                    AugStatus = 1
                    break
                else
                    if
                        (GetAugmentManager():KeepAugment(weapon.RefineryOp2) == true) or
                            (GetAugmentManager():KeepAugment(weapon.RefineryOp1) == true)
                     then
                        ShowToClient("AUGMENT", "Congratulation! You have achieved a desired augment! ")
                        AugStatus = 1
                    end
                end
                count = 1
            else
                Sleep(500)
                weapon = GetInventory():FindById(weaponId)
                if weapon == nil then
                    ShowToClient("AUGMENT", "Weapon for cancel not detected.")
                    count = 3
                    AugStatus = 1
                    break
                end
                if (count == 1) then
                    GetAugmentManager():setItemId(weaponId)
                    GetAugmentManager():AugmentCancel()
                    count = 2
                end
                Sleep(500)

                if (count == 2) and (openAugmentCancelWindow(npcName) == false) then
                    ShowToClient("AUGMENT", "The NPC Dialog Is not Working Properly.")
                    count = 3
                    AugStatus = 1
                    break
                end

                repeat
                    Sleep(1000)
                    weapon = GetInventory():FindById(weaponId)
                until weapon.RefineryOp1 == 0

                if not (weapon.RefineryOp1 == 0 and weapon.RefineryOp2 == 0) then
                    ShowToClient("AUGMENT", "Augment Canceling Failed.")
                    AugStatus = 1
                    break
                end
            end
        until weapon == nil or AugStatus == 1
        ShowToClient("AUGMENT", "Have Fun!")
        printResults()
    end
end
