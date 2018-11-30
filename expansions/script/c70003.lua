--"Espadachim - Blue Master"
local m=70003
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Summon"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x509),2,2)
    --"indes"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetCondition(c70003.incon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetValue(c70003.inval)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_BATTLE_DESTROYED)
    e3:SetCondition(c70003.regcon)
    e3:SetOperation(c70003.regop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCondition(c70003.regcon2)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(70003,0))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_CUSTOM+70003)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTarget(c70003.sptg)
    e5:SetOperation(c70003.spop)
    c:RegisterEffect(e5)
end
function c70003.incon(e)
    return e:GetHandler():GetLinkedGroupCount()>0
end
function c70003.inval(e,re,r,rp)
    return rp~=e:GetHandlerPlayer()
end
function c70003.cfilter(c,tp,zone)
    local seq=c:GetPreviousSequence()
    if c:GetPreviousControler()~=tp then seq=seq+16 end
    return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0
end
function c70003.regcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c70003.cfilter,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c70003.cfilter2(c,tp,zone)
    return not c:IsReason(REASON_BATTLE) and c70003.cfilter(c,tp,zone)
end
function c70003.regcon2(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c70003.cfilter2,1,nil,tp,e:GetHandler():GetLinkedZone())
end
function c70003.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+70003,e,0,tp,0,0)
end
function c70003.spfilter(c,e,tp)
    return c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c70003.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c70003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c70003.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end