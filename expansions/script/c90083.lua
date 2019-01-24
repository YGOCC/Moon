--"Hacker - Cyber Pirate"
local m=90083
local cm=_G["c"..m]
function cm.initial_effect(c)
    c:EnableReviveLimit()
    --"Special Summon Condition"
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(0)
    c:RegisterEffect(e1)
    --"Special Summon #1"
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90083,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCondition(c90083.spcon)
    e2:SetTarget(c90083.sptg)
    e2:SetOperation(c90083.spop)
    c:RegisterEffect(e2)
    --"ATK UP"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(90083,1))
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetTarget(c90083.tdtg)
    e3:SetOperation(c90083.tdop)
    c:RegisterEffect(e3)
    --"Special Summon #2"
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(90083,0))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,90083)
    e4:SetTarget(c90083.sptg2)
    e4:SetOperation(c90083.spop2)
    c:RegisterEffect(e4)
    --"Destroy"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(90083,2))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c90083.descon)
    e5:SetCost(c90083.descost)
    e5:SetTarget(c90083.destg)
    e5:SetOperation(c90083.desop)
    c:RegisterEffect(e5)
    --"Leave"
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_LEAVE_FIELD_P)
    e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetOperation(c90083.leaveop)
    c:RegisterEffect(e6)
end
function c90083.filter(c,tp)
    return c:IsSetCard(0x1aa) and bit.band(c:GetReason(),0x41)==0x41 and c:GetPreviousControler()==tp
        and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c90083.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c90083.filter,1,nil,tp)
end
function c90083.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c90083.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
        c:CompleteProcedure()
    end
end
function c90083.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c90083.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,LOCATION_GRAVE)
    Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
    local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
        e1:SetValue(ct*200)
        c:RegisterEffect(e1)
    end
end
function c90083.spfilter2(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90083.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c90083.spfilter2(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c90083.spfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c90083.spfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90083.spop2(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c90083.descon(e,c)
    if c==nil then return Duel.IsEnvironment(90069) end
end
function c90083.desfilter(c)
    return c:IsSetCard(0x1aa) and c:IsType(TYPE_MONSTER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c90083.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c90083.desfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,c90083.desfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c90083.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90083.desop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsEnvironment(90069) then
        local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c90083.leaveop(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsFacedown() then return end
    local effp=e:GetHandler():GetControler()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SKIP_BP)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    if Duel.GetTurnPlayer()==effp then
        e1:SetLabel(Duel.GetTurnCount())
        e1:SetCondition(c90083.skipcon)
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
    else
        e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
    end
    Duel.RegisterEffect(e1,effp)
end
function c90083.skipcon(e)
    return Duel.GetTurnCount()~=e:GetLabel()
end