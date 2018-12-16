--Mecha Blade Skydia
local m=88880007
local cm=_G["c"..m]
function cm.initial_effect(c)
    -- Negate 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_F)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,8888071)
    e1:SetCondition(cm.discon)
    e1:SetCost(cm.discost)
    e1:SetTarget(cm.distg)
    e1:SetOperation(cm.disop)
    c:RegisterEffect(e1)
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCountLimit(1,m)
    e3:SetCondition(cm.tgcon)
    e3:SetTarget(cm.tgtg)
    e3:SetOperation(cm.tgop)
    c:RegisterEffect(e3)
end
-- Negate Monsters
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType(TYPE_XYZ)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
        and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev) and c:GetOverlayCount()>1
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
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function cm.filter(c,e,tp)
    return c:IsSetCard(0xffd) and c:IsAbleToHand()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end