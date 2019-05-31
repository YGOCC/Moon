--Protector of the Fae
function c32900002.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(32900002,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c32900002.sptg)
    e1:SetOperation(c32900002.spop)
    c:RegisterEffect(e1)
    --negate attack
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32900002,2))
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_ATTACK_ANNOUNCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(c32900002.condition)
    e2:SetTarget(c32900002.target)
    e2:SetOperation(c32900002.operation)
    c:RegisterEffect(e2)
    --search
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(32900002,3))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCondition(c32900002.thcon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(c32900002.thtg)
    e3:SetOperation(c32900002.thop)
    c:RegisterEffect(e3)
    c32900002.banish_effect=e3
end
function c32900002.spfilter(c,e,tp)
    return c:IsSetCard(0x13b) and not c:IsCode(32900002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32900002.tfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x13b) and c:IsAbleToHand()
end
function c32900002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c32900002.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c32900002.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c32900002.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
       local dg=Duel.GetMatchingGroup(c32900002.tfilter,tp,LOCATION_REMOVED,0,1,nil)
       if dg:GetCount()>0 and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_GRAVE,0,nil,32900001)>=3 and Duel.SelectYesNo(tp,aux.Stringid(32900002,1)) then
            Duel.BreakEffect()
            local dg=Duel.SelectMatchingCard(tp,c32900002.tfilter,tp,LOCATION_REMOVED,0,1,1,nil)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
            Duel.SendtoHand(dg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,dg)
        end
    end
end
function c32900002.condition(e,tp,eg,ep,ev,re,r,rp)
    return tp~=Duel.GetTurnPlayer()
end
function c32900002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
    Duel.SetTargetCard(tg)
end
function c32900002.operation(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsRelateToEffect(e) then
        Duel.NegateAttack()
    end
end
function c32900002.thcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()==e:GetHandler():GetTurnID()+1
end
function c32900002.thfilter(c)
    return c:IsSetCard(0x13b) and not c:IsCode(32900002) and c:IsAbleToHand()
end
function c32900002.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c32900002.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32900002.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c32900002.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end