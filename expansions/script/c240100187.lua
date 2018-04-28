--created & coded by Lyris, art by Chahine Sfar
--S・VINEの女王クライッシャ(アナザー宙)
function c240100187.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrigSpatialType(c)
	aux.AddSpatialProc(c,c240100187.mcheck,8,300,nil,aux.FilterBoolFunction(Card.IsSetCard,0x285b),c240100187.mfilter)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCost(c240100187.cost)
	e3:SetTarget(c240100187.target)
	e3:SetOperation(c240100187.operation)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1109)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) end)
	e2:SetCost(c240100187.rmcost)
	e2:SetTarget(c240100187.rmtg)
	e2:SetOperation(c240100187.rmop)
	c:RegisterEffect(e2)
end
function c240100187.mfilter(c)
	return c:IsSetCard(0x85a) or c:IsSetCard(0x85b)
end
function c240100187.mcheck(sg)
	local sg=sg:Clone()
	local vg=sg:Filter(Card.IsSetCard,nil,0x285b)
	if vg:GetCount()==sg:GetCount() then return true end
	sg:Sub(vg)
	return vg:GetFirst():GetAttack()>sg:GetFirst():GetAttack()
end
function c240100187.costfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x85a) or c:IsSetCard(0x85b)) and c:IsAbleToRemoveAsCost()
end
function c240100187.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100187.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c240100187.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c240100187.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c240100187.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c240100187.filter(c,n)
	if not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0x285b)) then return false end
	return n~=0 and c:IsAbleToHand() or c:IsAbleToRemoveAsCost()
end
function c240100187.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100187.filter,tp,LOCATION_HAND,0,1,nil,0) end
	local g=Duel.SelectMatchingCard(tp,c240100187.filter,tp,LOCATION_HAND,0,1,1,nil,0)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c240100187.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100187.filter,tp,LOCATION_DECK,0,1,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100187.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c240100187.filter,tp,LOCATION_DECK,0,1,1,nil,1)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
