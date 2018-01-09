ShowToClient("Resurrection", "ON!")

resurrectionSkill = 1016
massResSkill = 1254

function resTarget(user, count)
    if GetSkills():FindById(resurrectionSkill):CanBeUsed() and user:GetDistance() < 900 then
        Target(user:GetName())
        UseSkillRaw(resurrectionSkill, false, false)
    else
        if count > 1 then
            if GetSkills():FindById(massResSkill) ~= nil then
                if GetSkills():FindById(massResSkill):CanBeUsed() and user:GetDistance() < 1000 then
                    UseSkillRaw(massResSkill, false, false)
                end
            end
        end
    end
end

repeat
    Sleep(500)
    party = GetPartyList()
    local deadCount = 0
    for member in party.list do
        if (member:IsAlikeDeath()) then
            deadCount = deadCount + 1
            resTarget(member, deadCount)
            ClearTarget()
            break
        end
    end
until false
