--Teutonic Knight - Ventalitarian
function c12000127.initial_effect(c)
--Special Summon From Hand
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000127,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12000127)
	e1:SetCondition(c12000127.spcon)
	e1:SetCost(c12000127.spcost)
	e1:SetTarget(c12000127.sptg)
	e1:SetOperation(c12000127.spop)
	c:RegisterEffect(e1)
--Search/Set
local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000127,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12000227)
	e2:SetCondition(c12000127.rmcon)
	e2:SetTarget(c12000127.thtg)
	e2:SetOperation(c12000127.thop)
	c:RegisterEffect(e2)
--Halve ATK/DEF and Negate Effect of 1 Monster
local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000127,2))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12000127.cost)
	e3:SetTarget(c12000127.target)
	e3:SetOperation(c12000127.operation)
	c:RegisterEffect(e3)
end
--Special Summon From Hand
function c12000127.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c12000127.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c12000127.spfilter1(c,e,tp)
	return c:IsSetCard(0x857) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12000127.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c12000127.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12000127.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c12000127.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
--Search/Set
function c12000127.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x857) or re:GetHandler():IsSetCard(0x858) and not re:GetHandler():IsCode(12000127)
end
function c12000127.thfilter(c)
	return c:IsSetCard(0x858) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetAble())
end
function c12000127.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000127.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000127.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12000127,3))
    local g=Duel.SelectMatchingCard(tp,c12000127.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
    local tc=g:GetFirst()
    if tc then
        local b1=tc:IsAbleToHand()
        local b2=tc:GetActivateEffect():IsActivatable(tp)
        if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(12000127,2))) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,tc)
        else
            Duel.SSet(tp,g:GetFirst())
            Duel.ConfirmCards(1-tp,g)
        end
    end
end
--Halve ATK and Negate Effect of 1 Monster
function c12000127.cfilter(c)
	return c:IsSetCard(0x857) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c12000127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000127.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12000127.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12000127.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c12000127.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(tc:GetAttack()/2)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(tc:GetDefense()/2)
        tc:RegisterEffect(e2)
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE)
        e3:SetReset(RESET_EVENT+0x1fe1000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_DISABLE_EFFECT)
        e4:SetValue(RESET_TURN_SET)
        e4:SetReset(RESET_EVENT+0x1fe1000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e4)
        if tc:IsType(TYPE_TRAPMONSTER) then
            local e5=Effect.CreateEffect(c)
            e5:SetType(EFFECT_TYPE_SINGLE)
            e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
            e5:SetReset(RESET_EVENT+0x1fe1000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e5)
        end
    end
end

