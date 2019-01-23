--"Hacker - Big Space"
local m=90068
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Link Materials"
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c90068.matfilter,3,3)
    --"Discard Deck"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(90068,0))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e1:SetCategory(CATEGORY_DECKDES)
    e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c90068.discon)
    e1:SetTarget(c90068.distg)
    e1:SetOperation(c90068.disop)
    c:RegisterEffect(e1)
    --"Activation Limit"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,90068)
    e2:SetCondition(c90068.actcon)
    e2:SetOperation(c90068.actop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_BE_BATTLE_TARGET)
    c:RegisterEffect(e3)
end
function c90068.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_NORMAL)
end
function c90068.discon(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c90068.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c90068.disop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    local ct=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x1aa)
    if ct>0 then
        Duel.DiscardDeck(1-tp,ct,REASON_EFFECT)
    end
end
function c90068.actcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetAttacker()
    if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
    return tc and tc:IsControler(tp) and tc:IsSetCard(0x1aa) and tc:IsType(TYPE_NORMAL)
end
function c90068.actop(e,tp,eg,ep,ev,re,r,rp)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_ACTIVATE)
    e1:SetTargetRange(0,1)
    e1:SetValue(c90068.aclimit)
    e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
    Duel.RegisterEffect(e1,tp)
end
function c90068.aclimit(e,re,tp)
    return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end