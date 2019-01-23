--"Assassin - Emergency Call"
local m=1859170
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(c1859170.target)
    e1:SetOperation(c1859170.activate)
    c:RegisterEffect(e1)
end
function c1859170.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsPlayerCanSpecialSummonMonster(tp,1859171,0x50e,0x4011,2000,2000,5,RACE_WARRIOR,ATTRIBUTE_DARK) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c1859170.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsPlayerCanSpecialSummonMonster(tp,1859171,0x50e,0x4011,2000,2000,5,RACE_WARRIOR,ATTRIBUTE_DARK) then
        for i=1,3 do
            local token=Duel.CreateToken(tp,1859170+i)
            Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
        end
        Duel.SpecialSummonComplete()
    end
end