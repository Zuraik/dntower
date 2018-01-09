-- This script works to give cleanse on the selected party players
ShowToClient("Cleanse", "ON!")
cleanseskillid = 1409 -- put here the cleanse skill Id atm its Radiant Purge

--Edit under this line to cleanse the party players you want
userList = {
    "PlayerName1",
    "PlayerName2"
}
--Add here the debuffs you want
DebuffList = {
    1336, -- curse of doom
    1064, --silence
    437, --song of silence
    1394,
    102,
    1337,
    1170,
    6389,
    6392,
    1201,
    1164,
    127,
    401,
    1361,
    1360,
    1359,
    1358,
    1539,
    1492,
    1493,
    1494,
    92,
    101,
    1263,
    400,
    1236,
    1454,
    1290,
    1343,
    1340,
    1342,
    1341,
    1071,
    1074,
    1083,
    6398,
    1169
} -- put here the Debuff Skill Ids

function haveSilence()
    my = GetMe()
    if my:GotBuff(1336) or my:GotBuff(1064) or my:GotBuff(437) then
        return true
    else
        return false
    end
end
function NeedCleanse(Tehuser) -- for long debuff list better this way so we wont ask GotBuff from l2 tower many times.
    local MyBuffs = {}
    for x = 0, 50 do
        local value = nil
        value = Tehuser:GetBuffByIdx(x)
        if value ~= nil then
            MyBuffs[#MyBuffs + 1] = value.skillId
        end
    end
    for x = 1, #DebuffList do
        for t = 1, #MyBuffs do
            if (MyBuffs ~= nil) and (MyBuffs[t] == DebuffList[x]) then
                return true
            end
        end
    end
    return false
end

repeat
    me = GetMe()
    if (me ~= nil) and not haveSilence() then
        if NeedCleanse(me) then
            if not me:IsAlikeDeath() then
                TargetMe()
                if GetSkills():FindById(cleanseskillid):CanBeUsed() then
                    UseSkillRaw(cleanseskillid, false, false)
                    Sleep(1500)
                end
            end
        else
            myptlist = GetPartyList()
            for PMember in myptlist.list do
                for j = 1, #userList do
                    if PMember:GetName() == userList[j] then
                        if NeedCleanse(PMember) then
                            if not PMember:IsAlikeDeath() and (PMember:GetDistance() < 600) then
                                target = GetTarget()
                                if target == nil then
                                    Target(PMember:GetName())
                                else
                                    if (target:GetName() ~= PMember:GetName()) then
                                        Target(PMember:GetName())
                                    else
                                        GetSkills():FindById(cleanseskillid):CanBeUsed()
                                        UseSkillRaw(cleanseskillid, false, false)
                                        Sleep(1500)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    Sleep(500)
until false
