function OnCreate()
    sos = false
    this:RegisterCommand("sos", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
end
function OnMagicSkillUse(user, target, skillId, skillLvl, skillHitTime, skillReuseTime)
    if (sos == true) then
        if (user:GetName() == GetMe():GetName()) then
            if ((skillId == 5564) and (skillLvl == 3) and (GetMe():GotBuff(785) == false)) then
                UseSkillRaw(789, false, false)
            end
        end
    end
end
function OnLTick500ms()
    -- 788 = Pain of Shilen; 789 Activated Pain Of Shilen; 5564 Spirit of Shilen
    if (sos == true) then
        if
            ((GetMe():GotBuff(788) == false) and (GetMe():GotBuff(789) == false) and (GetMe():GotBuff(5564) == false) and
                (GetMe():GotBuff(785) == false) and
                GetZoneType() ~= 12) and
                GetSkills():FindById(788):CanBeUsed()
         then
            UseSkillRaw(788, false, false)
        end
    end
end
function OnCommand_sos(vCommandChatType, vNick, vCommandParam)
    if (sos == false) then
        sos = true
        ShowToClient("sos", "Enabled!")
    else
        sos = false
        ShowToClient("sos", "Disabled!")
    end
end
