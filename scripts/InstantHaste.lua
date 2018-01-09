--This script will use instant haste potions when the user is in siege zones

local lastIHP = 0

function checkReuse(reuseDelay, lastUse)
    local diff = os.difftime(os.time(), lastUse)
    if diff > reuseDelay then
        return true
    end
    return false
end

function IHP()
    if checkReuse(14, lastIHP) then
        lastIHP = os.time()
        UseItem(10157)
    end
end

while true do
    if GetZoneType() == 11 then
        UseItem(10157)
        Sleep(14000)
    end
    Sleep(500)    
end
