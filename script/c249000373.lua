--Photon-Caster Spell Caller
function c249000373.initial_effect(c)
	--Add
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c249000373.cost)
	e1:SetTarget(c249000373.target)
	e1:SetOperation(c249000373.operation2)
	c:RegisterEffect(e1)
end
function c249000373.costfilter(c)
	return c:IsSetCard(0x55) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000373.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c249000373.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000373.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c249000373.tfilter(c)
	return c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsAbleToHand()
end
function c249000373.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000373.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000373.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c249000373.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_BECOME_QUICK)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	Duel.RegisterEffect(e2,tp)	
end