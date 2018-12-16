--Mecha Blade Valkari
local m=88880001
local cm=_G["c"..m]
function cm.initial_effect(c)
    -- Negate 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,8888011)
    e1:SetCondition(cm.discon)
    e1:SetCost(cm.discost)
    e1:SetTarget(cm.distg)
    e1:SetOperation(cm.disop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.tgcon)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
end
-- Negate Spells
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType(TYPE_XYZ)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
        and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev) and c:GetOverlayCount()>1
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end
function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
      return c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
        e3:SetRange(LOCATION_MZONE)
        e3:SetCode(EFFECT_IMMUNE_EFFECT)
        e3:SetValue(cm.efilter)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
    end
end