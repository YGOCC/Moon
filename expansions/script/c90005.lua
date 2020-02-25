--"Cyberon Calling"
--by "Márcio Eduine"
local m=90005
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,90005+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c90005.activate)
    c:RegisterEffect(e1)
    --"ATK/DEF UP"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsLinkState))
    e2:SetValue(500)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
    --"Cannot Disable Summon"
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e4:SetRange(LOCATION_FZONE)
    e4:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x20aa))
    c:RegisterEffect(e4)
    --"Special Summon"
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(90005,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_FZONE)
    e5:SetCountLimit(1,90005)
    e5:SetTarget(c90005.sptg)
    e5:SetOperation(c90005.spop)
    c:RegisterEffect(e5)
    --"Extra Attack"
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(90005,2))
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetRange(LOCATION_FZONE)
    e6:SetCountLimit(1)
    e6:SetCondition(c90005.condition)
    e6:SetTarget(c90005.eatg)
    e6:SetOperation(c90005.eaop)
    c:RegisterEffect(e6)
    --"Activation Limit"
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetCode(EFFECT_CANNOT_ACTIVATE)
    e7:SetRange(LOCATION_FZONE)
    e7:SetTargetRange(0,1)
    e7:SetCondition(c90005.actcon)
    e7:SetValue(c90005.aclimit)
    c:RegisterEffect(e7)
end
function c90005.thfilter(c)
    return not c:IsCode(90005) and c:IsSetCard(0x20aa) and c:IsAbleToHand()
end
function c90005.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c90005.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(90005,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function c90005.spfilter(c,e,tp)
    return c:IsSetCard(0x20aa) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable() and Duel.GetLocationCountFromEx(tp)>0
        and Duel.IsExistingMatchingCard(c90005.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90005.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        if Duel.GetLocationCountFromEx(tp)<1 then return end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,c90005.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
        if g:GetCount()>0 then
            Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function c90005.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c90005.eafilter(c)
    return c:IsFaceup() and c:IsSetCard(0x20aa) and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_LINK)
end
function c90005.eatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c90005.eafilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c90005.eafilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c90005.eafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90005.eaop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_ATTACK_ALL)
        e1:SetValue(1)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c90005.ftarget)
    e2:SetLabel(tc:GetFieldID())
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c90005.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function c90005.cfilter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_RITUAL+TYPE_FUSION+TYPE_LINK) and c:IsSetCard(0x20aa) and c:IsControler(tp)
end
function c90005.actcon(e)
    local tp=e:GetHandlerPlayer()
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a and c90005.cfilter(a,tp)) or (d and c90005.cfilter(d,tp))
end
function c90005.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end