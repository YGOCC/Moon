--Mecha Blade Night Stalker
local m=88880209
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddXyzProcedure(c,cm.mfilter,4,2,cm.ovfilter,aux.Stringid(m,0),2,cm.xyzop)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,1))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
    e1:SetLabel(3)
    e1:SetCondition(cm.tgcon)
    e1:SetCost(cm.tgcost)
    e1:SetTarget(cm.tgtg)
    e1:SetOperation(cm.tgop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(cm.reptg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_UPDATE_ATTACK)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.atkcon)
    e3:SetLabel(2)
    e3:SetValue(cm.atkval)
    c:RegisterEffect(e3)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetValue(cm.efilter)
    e5:SetCondition(cm.effcon)
    e5:SetLabel(4)
    c:RegisterEffect(e5)
end
--effect
function cm.ovfilter(c)
    return c:IsFaceup()
        and ((c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,88880005))
        or (c:IsCode(88880006) and c:GetOverlayGroup():GetCount()>0))
end
function cm.xyzop(e,tp,chk,mc)
    if chk==0 then return mc:CheckRemoveOverlayCard(tp,1,REASON_COST) end
    mc:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.mfilter(c)
    return c:IsSetCard(0xffd)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function cm.atkval(e,c)
    return c:GetOverlayCount()*200
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local oppo=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
    local self=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
    return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE and oppo>self and e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
    if not e:GetHandler():IsLocation(LOCATION_ONFIELD) then ct=ct-1 end
    if chk==0 then return ct>0 and g:IsExists(Card.IsAbleToGrave,ct,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
    if ct>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local sg=g:FilterSelect(tp,Card.IsAbleToGrave,ct,ct,nil)
        Duel.SendtoGrave(sg,REASON_EFFECT)
    end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayCount()>=e:GetLabel()
end
function cm.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
        and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    if Duel.SelectEffectYesNo(tp,c,96) then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
        return true
    else return false end
end
