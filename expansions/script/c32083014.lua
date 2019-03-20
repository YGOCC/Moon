--32083014
function c32083014.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32083014,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32083014)
	e1:SetCost(c32083014.descost)
	e1:SetTarget(c32083014.destg)
	e1:SetOperation(c32083014.desop)
	c:RegisterEffect(e1)
		--double
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,32083014)
	e2:SetCondition(c32083014.condition)
	e2:SetCost(c32083014.cost)
	e2:SetTarget(c32083014.target)
	e2:SetOperation(c32083014.operation)
	c:RegisterEffect(e2)
end
function c32083014.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)))
end
function c32083014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c32083014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function c32083014.operation(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) then
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c32083014.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32083014.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32083014.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32083014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c32083014.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
