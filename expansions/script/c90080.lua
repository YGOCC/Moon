--"Security Code"
local m=90080
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Negate & Destroy"
    local e0=Effect.CreateEffect(c)
    e0:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_CHAINING)
    e0:SetCondition(c90080.condition)
    e0:SetTarget(c90080.target)
    e0:SetOperation(c90080.activate)
    c:RegisterEffect(e0)
    --"Act in hand"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e1:SetCondition(c90080.handcon)
    c:RegisterEffect(e1)
    --"Overlay"
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1)
    e2:SetTarget(c90080.otarget)
    e2:SetOperation(c90080.oactivate)
    c:RegisterEffect(e2)
end
function c90080.condition(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x1aa) then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
        and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c90080.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function c90080.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetReset(RESET_PHASE+PHASE_END)
        e1:SetTargetRange(0,1)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_CANNOT_SUMMON)
        Duel.RegisterEffect(e2,tp)
        local e3=e2:Clone()
        e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
        Duel.RegisterEffect(e3,tp)
    end
end
function c90080.hanfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x1aa) and c:IsType(TYPE_LINK)
end
function c90080.handcon(e)
    return Duel.IsExistingMatchingCard(c90080.hanfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c90080.ofilter(c)
    return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x1aa)
end
function c90080.otarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c90080.ofilter(chkc) end
    if chk==0 then return e:IsHasType(EFFECT_TYPE_QUICK_O)
        and Duel.IsExistingTarget(c90080.ofilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c90080.ofilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90080.oactivate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
        c:CancelToGrave()
        Duel.Overlay(tc,Group.FromCards(c))
        --"Indestructable"
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e4:SetCountLimit(1)
        e4:SetValue(c90080.indval)
        e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e4)
    end
end
function c90080.indval(e,re,r,rp)
    return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end