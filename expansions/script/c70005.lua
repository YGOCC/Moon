--"Espadachim - Red Master"
local m=70005
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Summon"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x509),2,2)
    --"ATK Twice"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EXTRA_ATTACK)
    e1:SetCondition(c70005.dircon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --"Special Summon"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(70005,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1,70005)
    e2:SetCondition(c70005.spcon)
    e2:SetTarget(c70005.sptg)
    e2:SetOperation(c70005.spop)
    c:RegisterEffect(e2)
end
function c70005.dirfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and not c:IsCode(70005)
end
function c70005.dircon(e)
    return Duel.IsExistingMatchingCard(c70005.dirfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c70005.cfilter(c,tp)
    return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
        and c:IsSetCard(0x509)
end
function c70005.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c70005.cfilter,1,nil,tp)
end
function c70005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c70005.spfilter(c,e,tp)
    return c:IsLevelBelow(4) and c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70005.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.GetFirstMatchingCard(c70005.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end