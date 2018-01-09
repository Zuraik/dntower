function OnCreate()
    fi = false
    this:RegisterCommand("fi", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end
function OnMagicSkillUse(user, target, skillId, skillLvl, skillHitTime, skillReuseTime)
    if (fi == true) then
        if (user:GetName() == GetMe():GetName()) then
            ShowToClient("skillid", skillId .. ".")
            if ((skillId == 5562) and (skillLvl == 3) and (GetMe():GotBuff(789) == false) and GetZoneType() ~= 12) then
                UseSkillRaw(785, false, false)
            end
        end
    end
end
function OnLTick1s()
    -- 784 = Spirit of Phoenix; 785 Activated Spirit of Phoenix; 5562 Flame Icon
    if (fi == true) then
        if
            ((GetMe():GotBuff(784) == false) and (GetMe():GotBuff(785) == false) and (GetMe():GotBuff(5562) == false) and
                (GetMe():GotBuff(789) == false) and
                GetZoneType() ~= 12) and
                GetSkills():FindById(784):CanBeUsed()
         then
            UseSkillRaw(784, false, false)
        end
    end
end
function OnCommand_fi(vCommandChatType, vNick, vCommandParam)
    if (fi == false) then
        fi = true
        ShowToClient("fi", "Enabled!")
    else
        fi = false
        ShowToClient("fi", "Disabled!")
    end
end
