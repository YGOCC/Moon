--"Espada Demoníaca - Obsessive Addiction"
local m=80001
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(80001,0))
    e0:SetCategory(CATEGORY_EQUIP)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetTarget(c80001.target)
    e0:SetOperation(c80001.operation)
    c:RegisterEffect(e0)
    --"Atk up"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_EQUIP)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(c80001.atkval)
    c:RegisterEffect(e1)
    --"Equip limit #1"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_EQUIP_LIMIT)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetValue(c80001.eqlimit)
    c:RegisterEffect(e2)
    --"Must Attack"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_MUST_ATTACK)
    c:RegisterEffect(e3)
    --"Equip"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(80001,0))
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,80001)
    e4:SetCondition(c80001.eqcon)
    e4:SetTarget(c80001.eqtg)
    e4:SetOperation(c80001.operation)
    c:RegisterEffect(e4)
    --"Equip limit #2"
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EQUIP_LIMIT)
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    --"Special summon"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(80001,1))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e6:SetCode(EVENT_LEAVE_FIELD)
    e6:SetCondition(c80001.spcon)
    e6:SetTarget(c80001.sptg)
    e6:SetOperation(c80001.spop)
    c:RegisterEffect(e6)
end
function c80001.eqlimit(e,c)
    return c:IsSetCard(0x509) and c:IsType(TYPE_LINK)
end
function c80001.atkval(e,c)
    return c:GetLink()*500
end
function c80001.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:IsType(TYPE_LINK)
end
function c80001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c80001.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c80001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80001.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c80001.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Equip(tp,c,tc)
    end
end
function c80001.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ec=c:GetPreviousEquipTarget()
    return c:IsReason(REASON_LOST_TARGET) and ec:IsReason(REASON_DESTROY)
end
function c80001.eqfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509) and c:IsType(TYPE_LINK)
end
function c80001.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c80001.eqfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c80001.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,c80001.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c80001.spcon(e,tp,eg,ep,ev,re,r,rp)
    local ec=e:GetHandler():GetPreviousEquipTarget()
    return e:GetHandler():IsReason(REASON_LOST_TARGET) and not ec:IsLocation(LOCATION_ONFIELD+LOCATION_OVERLAY)
end
function c80001.spfilter(c,e,tp)
    return c:IsSetCard(0x509) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c80001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c80001.spfilter,tp,0x509,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x509)
end
function c80001.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c80001.spfilter),tp,0x509,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end