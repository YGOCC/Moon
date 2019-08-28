--Magium Abysslord Alaman
local m=888821
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xffc),2,2)
    --negate
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCountLimit(1,888021)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(cm.discon)
    e2:SetCost(cm.discost)
    e2:SetTarget(cm.distg)
    e2:SetOperation(cm.disop)
    c:RegisterEffect(e2)
    local e1=e2:Clone()
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCost(cm.sscos)
    e1:SetCountLimit(1,888021)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE)
    e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,888121)
    e3:SetCondition(cm.ccon)
    e3:SetTarget(cm.target)
    e3:SetOperation(cm.operation)
    c:RegisterEffect(e3)
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=re:GetHandler()
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rc~=c
end

function cm.thfilter(c)
    return c:IsCode(88810101) and c:IsAbleToDeckAsCost()
end

function cm.cfilter(c,g)
    return c:IsFaceup() and c:IsSetCard(0xffc)
        and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    local lg=e:GetHandler():GetLinkedGroup()
    if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,nil,lg) end
    local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,nil,lg)
    Duel.Release(g,REASON_COST)
end

function cm.sscos(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SendtoDeck(g,nil,1,REASON_COST)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end


function cm.filter2(c)
    return c:IsCode(88810101) and c:IsAbleToGrave()
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
