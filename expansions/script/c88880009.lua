--Mecha Blade Sky Angel
local m=88880009
local cm=_G["c"..m]
function c88880009.initial_effect(c)
--xyz summon
    c:EnableReviveLimit()
    --alternative proc
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(88880009,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCategory(CATEGORY_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCountLimit(2)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c88880009.cost)
    e1:SetTarget(c88880009.target)
    e1:SetOperation(c88880009.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetValue(c88880009.atkval)
    c:RegisterEffect(e2)
end
function c88880009.atkval(e,c)
    return c:GetOverlayCount()*100
end
--filters
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.cfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.ovfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and not c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil)
    and Duel.GetFlagEffect(tp,m)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
    if g:GetCount()>=0 then
        Duel.Overlay(e:GetHandler(),g)
    end
end
function c88880009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880009.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(400)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function c88880009.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c88880009.tgfilter(c)
    return c:IsCode(88880006)
end