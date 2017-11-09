--Wyndbreaker Claire
function c97671886.initial_effect(c)
    --reg
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_BATTLE_DAMAGE)
    e1:SetOperation(c97671886.regop)
    c:RegisterEffect(e1)
    --pierce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(97671886,0))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e3:SetCountLimit(1)
    e3:SetCondition(c97671886.rmcon)
    e3:SetTarget(c97671886.rmtg)
    e3:SetOperation(c97671886.rmop)
    c:RegisterEffect(e3)
end
function c97671886.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(97671886,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c97671886.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(97671886)~=0
end
function c97671886.filter(c,e,tp)
    return c:IsType(TYPE_NORMAL) and c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c97671886.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c97671886.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c97671886.rmop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c97671886.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end