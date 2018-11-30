--"Alexander the Synchronized Demon Espadachim"
local m=70014
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Synchro Materials"
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x509),aux.NonTuner(Card.IsSetCard,0x509),2)
    c:EnableReviveLimit()
    --"Equip"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70014,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c70014.eqcon)
    e1:SetTarget(c70014.eqtg)
    e1:SetOperation(c70014.eqop)
    c:RegisterEffect(e1)
    --"Indestructable"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetCondition(c70014.indcon)
    e2:SetValue(c70014.indval)
    c:RegisterEffect(e2)
    --"Piercing"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_PIERCE)
    e3:SetCondition(c70014.pcon)
    c:RegisterEffect(e3)
    --"Destroy"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(70014,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCost(c70014.descost)
    e4:SetTarget(c70014.destg)
    e4:SetOperation(c70014.desop)
    c:RegisterEffect(e4)
end
function c70014.eqcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c70014.eqfilter(c,ec)
    return (c:IsSetCard(0x510) and c:IsType(TYPE_MONSTER)) and c:CheckEquipTarget(ec)
end
function c70014.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70014.eqfilter(chkc,e:GetHandler()) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c70014.eqfilter,tp,LOCATION_GRAVE,0,2,nil,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c70014.eqfilter,tp,LOCATION_GRAVE,0,2,2,nil,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,2,0,0)
end
function c70014.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
        Duel.Equip(tp,tc,c)
    end
end
function c70014.indcon(e)
    return e:GetHandler():GetEquipCount()>0
end
function c70014.indval(e,re)
    if not re then return false end
    local ty=re:GetActiveType()
    return bit.band(ty,TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)~=0 and bit.band(ty,TYPE_EQUIP)==0
end
function c70014.pcon(e)
    return e:GetHandler():GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x510)
end
function c70014.costfilter(c,ec)
    return c:IsFaceup() and c:GetEquipTarget()==ec and c:IsAbleToGraveAsCost()
end
function c70014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c70014.costfilter,tp,LOCATION_SZONE,0,1,nil,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c70014.costfilter,tp,LOCATION_SZONE,0,1,1,nil,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST)
end
function c70014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c70014.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end