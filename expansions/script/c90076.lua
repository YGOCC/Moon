--"Hacker - Data Manager"
local m=90076
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Fusion Material"
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c90076.ffilter,3,false)
    --"Enable Cracking Counter"
    c:EnableCounterPermit(0x1dc)
    c:SetCounterLimit(0x1dc,5)
    --"Place Cracking Counter"
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(90076,0))
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e0:SetCode(EVENT_DAMAGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetCondition(c90076.condition)
    e0:SetOperation(c90076.counter)
    c:RegisterEffect(e0)
    --"Disable"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90076,1))
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,90076)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(c90076.discost)
    e1:SetTarget(c90076.distg)
    e1:SetOperation(c90076.disop)
    c:RegisterEffect(e1)
    --"Todeck"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90076,2))
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,90076)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCost(c90076.cost)
    e2:SetTarget(c90076.target)
    e2:SetOperation(c90076.operation)
    c:RegisterEffect(e2)
    --"Defense Attack"
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_DEFENSE_ATTACK)
    e3:SetCondition(c90076.atkcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    --"Destroy Replace"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DESTROY_REPLACE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c90076.desreptg)
    e4:SetOperation(c90076.desrepop)
    c:RegisterEffect(e4)
end
function c90076.ffilter(c)
    return c:IsFusionSetCard(0x1aa) and c:IsFusionType(TYPE_PENDULUM)
end
function c90076.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and bit.band(r,REASON_BATTLE)==0
end
function c90076.counter(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x1dc,1)
end
function c90076.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1dc,1,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1dc,1,REASON_COST)
end
function c90076.disfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c90076.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c90076.disfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90076.disfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,c90076.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c90076.disop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local atk=tc:GetAttack()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_UPDATE_ATTACK)
        e3:SetValue(atk)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e3)
        local e4=e3:Clone()
        e4:SetCode(EFFECT_UPDATE_DEFENSE)
        c:RegisterEffect(e4)
    end
end
function c90076.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1dc,5,REASON_COST) end
    e:GetHandler():RemoveCounter(tp,0x1dc,5,REASON_COST)
end
function c90076.filter(c)
    return c:IsSetCard(0x1aa) and c:IsAbleToDeck()
end
function c90076.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c90076.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90076.filter,tp,LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c90076.filter,tp,LOCATION_GRAVE,0,1,5,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c90076.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
    local dg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
    if ct>0 and dg:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local rg=dg:Select(tp,1,ct,nil)
        Duel.HintSelection(rg)
        Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
    end
end
function c90076.atkcon(e)
    return e:GetHandler():GetCounter(0x1dc)>=2
end
function c90076.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
        and e:GetHandler():GetCounter(0x1dc)>0 end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c90076.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveCounter(ep,0x1dc,1,REASON_DESTROY)
end