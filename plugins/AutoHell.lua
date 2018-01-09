function OnCreate()
    hell = false
    this:RegisterCommand("hell", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end
function OnMagicSkillUse(user, target, skillId, skillLvl, skillHitTime, skillReuseTime)
    if (hell == true) then
        if (user:GetName() == GetMe():GetName()) then
            if ((skillId == 5561) and (skillLvl == 3) and GetZoneType() ~= 12) then
                UseSkillRaw(762, false, false)
            end
        end
    end
end
function OnLTick1s()
    if (hell == true) then
        if
            ((GetMe():GotBuff(761) == false) and (GetMe():GotBuff(5561) == false) and GetZoneType() ~= 12) and
                GetSkills():FindById(761):CanBeUsed()
         then
            UseSkillRaw(761, false, false)
        end
    end
end
function OnCommand_hell(vCommandChatType, vNick, vCommandParam)
    if (hell == false) then
        hell = true
        ShowToClient("hell", "Enabled!")
    else
        hell = false
        ShowToClient("hell", "Disabled!")
    end
end
