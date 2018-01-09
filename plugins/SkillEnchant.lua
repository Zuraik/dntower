--This plugin will enchant skills automatically
    -- In order to use it, you must: edit the skill Id (skilltoenchant)
    -- Select the route on "baseSkillOption" (100 is the first route, 200 the second, etc etc)
    -- Then the max enchant rate on "skillOptionMax", by default stops in +15
    -- Then refresh the plugin and type /e to start it
    -- Finally, enchant the skill manually on the desire route until it breaks, then the scripts will continue by itself
        -- Optionally, you can type /e and use the skill you want to enchant (do NOT activate the soulshots during this)

function OnCreate()
    Event_PacketUnBlock(0xFE, 0xA7, 0x3)
    this:RegisterCommand("e", CommandChatType.CHAT_ALLY, CommandAccessLevel.ACCESS_ME)
    stopme = false
    nextSkill = true
    -- Edit under this line
    skilltoenchant = 485 --Id of the skill to enchant, can be get from: https://l2db.info/
    baseSkillOption = 200 -- From right to left of the enchant routes: 100, 200, 300, etc
    skilloptionmax = baseSkillOption + 15 -- The enchant level: + 15 is.. +15 (dah)
    -- End of edition
    skilloption = baseSkillOption
end

function OnMagicSkillUse(user, target, skillId, skillLvl, skillHitTime, skillReuseTime)
    if stopme then
        if (user:GetName() == GetMe():GetName()) then
            local oldSkill = skilltoenchant
            skilltoenchant = skillId
            nextSkill = true
            skilloption = baseSkillOption
            stopme = true
            ShowToClient("Skill Id changed from", oldSkill .. " to " .. skilltoenchant .. ".")
        end
    end
end

function OnIncomingPacket(packet)
    if (packet:GetID() == 0xFE) and (packet:GetSubID() == 0xA7) and (stopme == true) and (nextSkill) then
        packet:SetOffset(0) -- always call that at begin
        success = packet:ReadInt(4)
        if (success == 1) then
            skilloption = skilloption + 1
        else
            skilloption = baseSkillOption + 1
        end
        if (GetQuestManager():GetQuestItemCount(6622) >= 0) then
            if (skilloption <= skilloptionmax) then
                local kkk = PacketBuilder()
                kkk:AppendInt(208, 1)
                kkk:AppendInt(15, 2)
                kkk:AppendInt(skilltoenchant, 4)
                kkk:AppendInt(skilloption, 4)
                SendPacket(kkk)
            else
                ShowToClient("", "Skill enchanted successfully!")
                nextSkill = false
            end
        else
            ShowToClient("", "No more bogs")
            ShowToClient("", "Stopped")
            stopme = false
        end
    end
end

function OnCommand_e(vCommandChatType, vNick, vCommandParam)
    if stopme then
        stopme = false
        ShowToClient("", "Stopped")
    else
        stopme = true
        ShowToClient("", "Started")
    end
end
