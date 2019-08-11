--Sabatiel the Philosopher's Gem
function c249000934.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000934,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000934)
	e1:SetCost(c249000934.cost)
	e1:SetTarget(c249000934.target)
	e1:SetOperation(c249000934.activate)
	c:RegisterEffect(e1)
	--add from deck to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_DECK)
	e2:SetCountLimit(1,249000934)
	e2:SetCondition(c249000934.condition)
	e2:SetTarget(c249000934.target2)
	e2:SetOperation(c249000934.operation)
	c:RegisterEffect(e2)
end
function c249000934.costfilter(c)
	return c:IsSetCard(0x47) and c:IsAbleToRemoveAsCost()
end
function c249000934.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000934.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c249000934.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c249000934.filter(c)
	return c:IsType(TYPE_SPELL) and c:GetActivateEffect() and c:GetActivateEffect():GetCategory() and bit.band(c:GetActivateEffect():GetCategory(),CATEGORY_SPECIAL_SUMMON)~=0 and c:IsAbleToHand()
end
function c249000934.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000934.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000934.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000934.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000934.cfilter2(c,tp)
	return c:IsSetCard(0x10a4) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c249000934.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000934.cfilter2,1,nil,tp)
end
function c249000934.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() and e:GetHandler():IsLocation(LOCATION_DECK) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c249000934.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_DECK) then return end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end