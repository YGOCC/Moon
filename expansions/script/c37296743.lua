--Vampire Graveyard
function c37296743.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(37296743,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCondition(c37296743.spcon)
    e2:SetTarget(c37296743.sptg)
    e2:SetOperation(c37296743.spop)
    c:RegisterEffect(e2)
end
function c37296743.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(Card.IsRace,1,nil,RACE_ZOMBIE)
end
function c37296743.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c37296743.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,37296744,0,0x8e,1000,1000,2,RACE_ZOMBIE,ATTRIBUTE_DARK) then
        local token=Duel.CreateToken(tp,37296744)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
        if eg:IsExists(Card.IsSetCard,1,nil,0x8e) then
            local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,LOCATION_MZONE,nil,37296744)
            for tc in aux.Next(g) do
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_BASE_ATTACK)
                e1:SetValue(1800)
                e1:SetReset(RESET_EVENT+0x1fe0000)
                tc:RegisterEffect(e1)
                local e2=e1:Clone()
                e2:SetCode(EFFECT_SET_BASE_DEFENSE)
                tc:RegisterEffect(e2)
            end
        end
    end
end