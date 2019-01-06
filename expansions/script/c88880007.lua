--Mecha Blade Skydia
local m=88880007
local cm=_G["c"..m]
function cm.initial_effect(c)
    -- Negate 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetCondition(cm.discon)
    e1:SetOperation(cm.disop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetOperation(cm.regop)
    c:RegisterEffect(e2)
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
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
-- Reduce ATK
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType(TYPE_XYZ)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_DISABLED) and c:GetFlagEffect(m)~=0 and c:GetOverlayCount()>1
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(50)
    e1:SetReset(RESET_EVENT+0x1ff0000)
    c:RegisterEffect(e1)
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