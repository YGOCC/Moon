--"Cyberon Strategist"
--by "Márcio Eduine"
local m=90011
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Material"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsCode,90000),1)
    --"Gain ATK"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90011,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,90011)
    e1:SetTarget(c90011.target)
    e1:SetOperation(c90011.operation)
    c:RegisterEffect(e1)
    --"Destroy"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90011,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,90011)
    e2:SetCondition(c90011.descon)
    e2:SetCost(c90011.descost)
    e2:SetTarget(c90011.destg)
    e2:SetOperation(c90011.desop)
    c:RegisterEffect(e2)
end
function c90011.cfilter(c,g)
    return c:IsFaceup() and g:IsContains(c) and c:GetAttack()>0
end
function c90011.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    if chk==0 then return Duel.IsExistingMatchingCard(c90011.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lg) end
    local g=Duel.SelectTarget(tp,c90011.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lg)
end
function c90011.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e1:SetValue(math.ceil(0))
        tc:RegisterEffect(e1)
        if c:IsRelateToEffect(e) and c:IsFaceup() then
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_UPDATE_ATTACK)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e2:SetValue(math.ceil(atk))
            c:RegisterEffect(e2)
        end
    end
end
function c90011.descon(e)
    return e:GetHandler():GetAttack()>0
end
function c90011.desfilter(c,g,tp,zone)
    return c:IsSetCard(0x20aa) and g:IsContains(c)
        and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c90011.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    local zone=e:GetHandler():GetLinkedZone(tp)
    if chk==0 then return Duel.CheckReleaseGroup(tp,c90011.desfilter,1,nil,lg,tp,zone) end
    local g=Duel.SelectReleaseGroup(tp,c90011.desfilter,1,1,nil,lg,tp,zone)
    Duel.Release(g,REASON_COST)
    e:SetLabelObject(g:GetFirst())
    if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
    e:GetHandler():RegisterEffect(e1)
end
function c90011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c90011.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end