-- This script will talk to the npc that give talismans, and collect up to ten talismans, then delete all the unwanted talismans
    -- By default it will keep ONLY the White Talisman of Protection and delete all the rest

npcName = "Court Magician"
-- npcName = "Support Unit Captain"

-- Comment the lines of the talismans that you want to keep
talismans = {
    -- Black
    "Black Talisman - Arcane Freedom",
    "Black Talisman - Escape",
    "Black Talisman - Free Speech",
    "Black Talisman - Mending",
    "Black Talisman - Physical Freedom",
    "Black Talisman - Rescue",
    "Black Talisman - Vocalization",
    -- Red
    "Red Talisman - CP Regeneration",
    "Red Talisman - HP/CP Recovery",
    "Red Talisman - Life Force",
    "Red Talisman - Max CP",
    "Red Talisman of Maximum Clarity",
    "Red Talisman of Meditation",
    "Red Talisman of Mental Regeneration",
    "Red Talisman of Minimum Clarity",
    "Red Talisman of Recovery",
    -- Blue
    "Blue Talisman - Buff Cancel",
    "Blue Talisman - Buff Cancel",
    "Blue Talisman - Buff Steal",
    "Blue Talisman - Buff Steal",
    "Blue Talisman - Divine Protection",
    "Blue Talisman - Explosion",
    "Blue Talisman - Greater Healing",
    "Blue Talisman - Lord's Divine Protection",
    "Blue Talisman - Magic Explosion",
    "Blue Talisman - P. Atk.",
    "Blue Talisman - Self-Destruction",
    "Blue Talisman - Shield Defense",
    "Blue Talisman - Shield Protection",
    "Blue Talisman of Defense",
    "Blue Talisman of Defense",
    "Blue Talisman of Evasion",
    "Blue Talisman of Healing",
    "Blue Talisman of Invisibility",
    "Blue Talisman of Magic Defense",
    "Blue Talisman of Power",
    "Blue Talisman of Protection",
    "Blue Talisman of Reflection",
    "Blue Talisman of Wild Magic",
    -- Yellow
    "Yellow Talisman - CP Recovery Rate",
    "Yellow Talisman - Damage Transition",
    "Yellow Talisman - Evasion",
    "Yellow Talisman - Healing Power",
    "Yellow Talisman - HP Recovery Rate",
    "Yellow Talisman - Increase Force",
    "Yellow Talisman - Low Grade MP Recovery Rate",
    "Yellow Talisman - M. Atk.",
    "Yellow Talisman - P. Def.",
    "Yellow Talisman - Speed",
    "Yellow Talisman of Accuracy",
    "Yellow Talisman of Alacrity",
    "Yellow Talisman of Arcane Defense",
    "Yellow Talisman of Arcane Haste",
    "Yellow Talisman of Arcane Power",
    "Yellow Talisman of CP Regeneration",
    "Yellow Talisman of Critical Damage",
    "Yellow Talisman of Critical Dodging",
    "Yellow Talisman of Critical Reduction",
    "Yellow Talisman of Defense",
    "Yellow Talisman of Evasion",
    "Yellow Talisman of Healing",
    "Yellow Talisman of Mental Regeneration",
    "Yellow Talisman of Physical Regeneration",
    "Yellow Talisman of Power",
    "Yellow Talisman of Speed",
    "Yellow Talisman of Violent Haste",
    -- Orange
    "Orange Talisman - Elixir of Life",
    "Orange Talisman - Elixir of Mental Strength",
    "Orange Talisman - Hot Springs CP Potion",
    -- White
    "White Talisman -  All Resistance",
    "White Talisman -  Earth",
    "White Talisman - Darkness",
    "White Talisman - Fire",
    "White Talisman - Light",
    "White Talisman - Storm",
    "White Talisman - Water",
    "White Talisman of Attention",
    "White Talisman of Bandages",
    "White Talisman of Bravery",
    "White Talisman of Freedom",
    "White Talisman of Grounding",
    "White Talisman of Motion",
    -- Grey
    "Grey Talisman of Weight Training",
    "Grey Talisman of Mid-Grade Fishing",
    "Grey Talisman - Yeti Transform",
    "Grey Talisman - Buffalo Transform",
    "Grey Talisman of Upper Grade Fishing"
}

function talkToNpc()
    local target = GetTarget()
    if (target ~= nil) then
        if (target:GetName() ~= npcName) then
            Command("/target " .. npcName)
            Sleep(2000)
        end
    else
        Command("/target " .. npcName)
        Sleep(2000)
        Command("/target " .. npcName)
        Sleep(2000)
    end
    Talk()
    Sleep(1200)
    Click("01", "Obtain Talisman.")
    Sleep(1200)
    Click("01", "Give Knight's Epaulettes.")
    Sleep(1200)
end

function getItemByName(name)
    invList = GetInventory()
    for item in invList.list do
        if item.Name == name then
            return item.objectId
        end
    end
    return 0
end

function getFullItemByName(name)
    local invList = GetInventory()
    for item in invList.list do
        if (item.Name == name) then
            return item
        end
    end
end

while true do
    local hasKe = true
    -- Obtain 10 talismans
    for i = 1, 10 do
        Ke = getFullItemByName("Knight's Epaulette")
        if (Ke ~= nil) and (Ke.ItemNum >= 10) then
            talkToNpc()
        else
            hasKe = false
        end
    end
    -- Delete unwanted talismans
    repeat
        local breaker = true
        for i, v in ipairs(talismans) do
            local itemToDelete = getItemByName(v)
            if itemToDelete ~= 0 then
                DeleteItem(itemToDelete, 1)
                Sleep(1800)
                -- ShowToClient("Deleted", v .. ".")
                breaker = false
            end
        end
    until breaker
    -- Counting here how many talismans of protection we have
    local invList2 = GetInventory()
    local talismanCounter = 0
    for item in invList2.list do
        if (item.Name == name) then
            talismanCounter = talismanCounter + 1
        end
    end
    if hasKe == false or talismanCounter > 4 then
        ShowToClient("Out of Knight's Epaulette", "Enjoy!")
        break
    end
end
