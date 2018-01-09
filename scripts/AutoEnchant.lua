-- This script will enchant all items in the inventory that have the name listed on the "armors" dictionary
-- Update the maxItemsToEnchant variable to enchant more of the same items after success (e.g a maxItemsToEnchant = 1 will stop enchanting vesper shoes if at least 1 vesper shoe succeeded to reach the maximum enchant)

-- SCRIPT CONFIGURATION!
enchant_name = "Scroll: Enchant Armor (S-Grade)"
blessed_enchant_name = "Blessed Scroll: Enchant Weapon (W-Grade)"
max_enchant = 6
max_safe_enchant = 3
maxItemsToEnchant = 1 -- This indicates how many items of the same type will be enchanted

armors = {
    -- --Vesper Items
    "Sealed Vesper Leather Helmet",
    "Sealed Vesper Helmet",
    "Sealed Vesper Circlet",
    "Sealed Vesper Sigil",
    "Sealed Vesper Breastplate",
    "Sealed Vesper Leather Breastplate",
    "Sealed Vesper Tunic",
    "Sealed Vesper Gaiters",
    "Sealed Vesper Gauntlet",
    "Sealed Vesper Boots",
    "Sealed Vesper Shield",
    "Sealed Vesper Leather Leggings",
    "Sealed Vesper Leather Gloves",
    "Sealed Vesper Leather Boots",
    "Sealed Vesper Stockings",
    "Sealed Vesper Gloves",
    "Sealed Vesper Shoes",
    "Sealed Vesper Earring",
    "Sealed Vesper Necklace",
    "Sealed Vesper Ring",
    "Sealed Vorpal Earring"
}

delay = math.random(1400, 1500)

-- END OF SCRIPT CONFIGURATION
-- Control variables
item_name = nil
armorsCount = {}
statsCount = {}
for i, v in ipairs(armors) do
    armorsCount[v] = 0
    statsCount[v] = 0
end

-- HELPER FUNCTIONS
function enchantResult()
    return GetEnchantManager():getLastResult()
end

function getItemByName(name, maxenchant)
    invList = GetInventory()
    for item in invList.list do
        if item.Name == name and item.Enchanted < maxenchant then
            return item
        end
    end
end
------ Inventos mios

x = nil
for j, v in ipairs(armors) do
    local inv = GetInventory()
    for item in inv.list do
        if item.Name == v and item.Enchanted >= max_enchant then
            armorsCount[item.Name] = armorsCount[item.Name] + 1
        end
    end
end
-- MAIN LOOP!
while true do
    local armor = nil
    for i, v in pairs(armorsCount) do
        if armorsCount[i] < maxItemsToEnchant then
            item = getItemByName(i, max_enchant)
            if item ~= nil then
                armor = item
                item_name = i
            end
        end
    end

    if (armor == nil) then
        ShowToClient("Out of items to enchant", ".")
        -- for k, v in pairs(statsCount) do
        --     ShowToClient("Broke", statsCount[k] .. " " .. k)
        -- end
        break
    end
    -- find proper enchant scroll
    enchant = nil

    if (armor.Enchanted >= max_safe_enchant) then
        enchant = getItemByName(blessed_enchant_name, 20)
    else
        enchant = getItemByName(enchant_name, 20)
    end

    if enchant == nil then
        ShowToClient("Out of enchants", ".")
        -- for k, v in pairs(statsCount) do
        --     ShowToClient("Broke", statsCount[k] .. " " .. k)
        -- end
        break
    end

    GetEnchantManager():setDelay(delay)
    GetEnchantManager():setEnchantId(enchant.objectId)
    GetEnchantManager():setItemId(armor.objectId)
    GetEnchantManager():Enchant()

    while (enchantResult() == Enchant.ENCHANT_PENDING) do
        Sleep(200)
    end

    if (enchantResult() == Enchant.ENCHANT_SUCCESS) then
        Sleep(500) -- sleep so item data is updated
        armor = GetInventory():FindById(armor.objectId)
        if (armor.Enchanted == max_enchant) then
            armorsCount[item_name] = armorsCount[item_name] + 1
            ShowToClient("Success with", item_name .. ".")
        end
    elseif (enchantResult() == Enchant.ENCHANT_FAILURE) then
        statsCount[item_name] = statsCount[item_name] + 1
        Sleep(500) -- sleep so item data is updated
    end
end
