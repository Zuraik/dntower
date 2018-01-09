function OnCreate()
    chp = false
    hasCHP = true
    hasPPA = true
    this:RegisterCommand("chp", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end

function OnLTick1s()
    if (chp == true) then
        inventory = GetInventory()
        me = GetMe()
        if inventory:FindById(23060) == nil and hasPPA then
            hasPPA = false
            ShowToClient("Out of", "Potion of Power Attack")
        end
        if inventory:FindById(23065) == nil and hasCHP then
            hasCHP = false
            ShowToClient("Out of", "Combat Haste Potion")
        end
        if (me:GotBuff(25094) == false) and hasPPA then
            UseItem(23060) -- Potion of Power Attack
        end
        if (me:GotBuff(25099) == false) and hasCHP then
            UseItem(23065) -- Combat Haste Potion
        end
    end
end
function OnCommand_chp(vCommandChatType, vNick, vCommandParam)
    if (chp == false) then
        chp = true
        ShowToClient("CHP/PPA", "Enabled!")
    else
        chp = false
        ShowToClient("CHP/PPA", "Disabled!")
    end
end
