function OnCreate()
    eva = false
    this:RegisterCommand("eva", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end
function OnMagicSkillUse(user, target, skillId, skillLvl, skillHitTime, skillReuseTime)
    if (eva == true) then
        if (user:GetName() == GetMe():GetName()) then
            -- ShowToClient("skillid", skillId .. ".")
            if ((skillId == 5563) and (skillLvl == 3) and GetZoneType() ~= 12) then
                UseSkillRaw(787, false, false)
            end
        end
    end
end
function OnLTick1s()
    if (eva == true) then
        if
            ((GetMe():GotBuff(786) == false) and (GetMe():GotBuff(787) == false) and (GetMe():GotBuff(5563) == false) and
                GetZoneType() ~= 12) and
                GetSkills():FindById(786):CanBeUsed()
         then
            UseSkillRaw(786, false, false)
        end
    end
end
function OnCommand_eva(vCommandChatType, vNick, vCommandParam)
    if (eva == false) then
        eva = true
        ShowToClient("eva", "Enabled!")
    else
        eva = false
        ShowToClient("eva", "Disabled!")
    end
end
