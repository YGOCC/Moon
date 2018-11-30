--"Espadachim - Demon Herald"
local m=70022
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c70022.matfilter,2)
    --"Cannot Select Battle Target"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetRange(LOCATION_MZONE)
    e0:SetTargetRange(0,LOCATION_MZONE)
    e0:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e0:SetValue(c70022.atlimit)
    c:RegisterEffect(e0)
    --"Cannot Select Effect Target"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetTarget(c70022.efftg)
    e1:SetValue(aux.tgoval)
    c:RegisterEffect(e1)
    --"ATK UP"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c70022.atkcon)
    e2:SetOperation(c70022.atkop)
    c:RegisterEffect(e2)
    --"Special Summon"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(70022,0))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,70022)
    e3:SetCost(c70022.spcost1)
    e3:SetTarget(c70022.sptg1)
    e3:SetOperation(c70022.spop1)
    c:RegisterEffect(e3)
    --"To Extra Deck"
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCost(c70022.thcost)
    e4:SetTarget(c70022.thtg)
    e4:SetOperation(c70022.thop)
    c:RegisterEffect(e4)
end
function c70022.matfilter(c)
    return c:IsLinkSetCard(0x509) and c:IsLinkType(TYPE_LINK)
end
function c70022.atlimit(e,c)
    return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x509)
end
function c70022.efftg(e,c)
    return c:IsSetCard(0x509) and c~=e:GetHandler()
end
function c70022.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c70022.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local atk=0
    local tc=g:GetFirst()
    while tc do
        local lk=tc:GetLink()
        atk=atk+lk
        tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(atk*300)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
    c:RegisterEffect(e1)
end
function c70022.cfilter(c,g,tp,zone)
    return (c:IsSetCard(0x509) and c:IsLevelBelow(5)) and g:IsContains(c)
        and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c70022.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    local zone=e:GetHandler():GetLinkedZone(tp)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c70022.cfilter,1,nil,lg,tp,zone) end
    local g=Duel.SelectReleaseGroup(tp,c70022.cfilter,1,1,nil,lg,tp,zone)
    Duel.Release(g,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end
function c70022.spfilter1(c,e,tp)
    return (c:IsSetCard(0x509) and c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_LINK)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70022.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local cc=e:GetLabelObject()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
        and chkc~=cc and c70022.spfilter1(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c70022.spfilter1,tp,LOCATION_GRAVE,0,1,cc,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c70022.spfilter1,tp,LOCATION_GRAVE,0,1,1,cc,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c70022.spop1(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone(tp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c70022.thfilter(c)
    return c:IsSetCard(0x509) and c:IsAbleToDeckAsCost()
end
function c70022.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70022.thfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c70022.thfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
    Duel.SendtoDeck(g,nil,3,REASON_COST)
end
function c70022.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c70022.thop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
    end
end