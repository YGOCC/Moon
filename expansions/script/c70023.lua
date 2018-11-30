--"Tiberius, the Lord Espadachim of Chaos"
local m=70023
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Materials"
    c:EnableReviveLimit()
    aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x509),2,99,70022)
    --"Destroy"
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_DESTROY)
    e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(c70023.descon)
    e0:SetTarget(c70023.destg)
    e0:SetOperation(c70023.desop)
    c:RegisterEffect(e0)
    --"Activation Limit"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c70023.aclimit)
    e1:SetCondition(c70023.actcon)
    c:RegisterEffect(e1)
    --"ATK"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c70023.atkcon)
    e2:SetValue(3000)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_MATERIAL_CHECK)
    e3:SetValue(c70023.valcheck)
    e3:SetLabelObject(e2)
    c:RegisterEffect(e3)
end
c70023.material_setcode={0x509}
c70023.espadachim_fusion=true
function c70023.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c70023.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local ct=e:GetHandler():GetMaterialCount()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c70023.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end
function c70023.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c70023.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
function c70023.atkfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x509)
end
function c70023.atkcon(e)
    if e:GetLabel()==1 then
    return Duel.GetMatchingGroupCount(c70023.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)>=3
    end
end
function c70023.valcheck(e,c)
    local g=c:GetMaterial()
    if g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then
        e:GetLabelObject():SetLabel(1)
    else
        e:GetLabelObject():SetLabel(0)
    end
end