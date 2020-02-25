--"Cyberon Gate Two"
--by "Márcio Eduine"
local m=90002
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Pendulum Attribute"
    aux.EnablePendulumAttribute(c)
    --"Special Summon Limit"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_PZONE)
    e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e0:SetTargetRange(1,0)
    e0:SetTarget(c90002.splimit)
    c:RegisterEffect(e0)
    --"To Hand"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90002,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,90002)
    e1:SetTarget(c90002.thtg)
    e1:SetOperation(c90002.thop)
    c:RegisterEffect(e1)
    --"Special Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90002,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SUMMON_SUCCESS)
    e2:SetCountLimit(1,90002)
    e2:SetTarget(c90002.sptg)
    e2:SetOperation(c90002.spop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
end
function c90002.splimit(e,c,tp,sumtp,sumpos)
    return not c:IsSetCard(0x20aa) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c90002.thfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x20aa) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c90002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90002.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c90002.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c90002.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c90002.filter(c,e,tp)
    return not c:IsCode(90002) and c:IsSetCard(0x20aa) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c90002.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c90002.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c90002.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end