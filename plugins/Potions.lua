-- This plugin will use combat haste potions and potions of power attack when needed. Start by typing /chp
function OnCreate()
    chp = false
    this:RegisterCommand("chp", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end

function OnLTick1s()
    if (chp == true) then
        me = GetMe()
        if (me:GotBuff(25094) == false) then
            UseItem(23060) -- Potion of Power Attack
        end
        if (me:GotBuff(25099) == false) then
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
