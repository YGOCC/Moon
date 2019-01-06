--Mecha Blade Diver
local m=88880000
local cm=_G["c"..m]
function cm.initial_effect(c)
    -- Negate 
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_NEGATE)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_CHAIN_SOLVED)
    e1:SetCondition(cm.discon)
    e1:SetTarget(cm.distg)
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
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
-- Reduce ATK
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetType(TYPE_XYZ)
        and not c:IsStatus(STATUS_BATTLE_DESTROYED) and not c:IsStatus(STATUS_DISABLED)  and c:GetFlagEffect(m)~=0 and c:GetOverlayCount()>1
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(-100)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function cm.cfilter(c)
    return c:IsFacedown() or not c:IsSetCard(0xffd)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end

function cm.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0xffd) and c:IsType(TYPE_XYZ)
end
function cm.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.matfilter(chkc) end
    if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
        and Duel.IsExistingTarget(cm.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,cm.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function cm.tgfilter(c)
    return c:IsSetCard(0xffd) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
      return c:IsReason(REASON_COST) and c:IsPreviousLocation(LOCATION_OVERLAY)
end