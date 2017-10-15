--Evolution-Disciple Sorceress
function c249000568.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c249000568.cost)
	e1:SetTarget(c249000568.target)
	e1:SetOperation(c249000568.operation)
	c:RegisterEffect(e1)
end
function c249000568.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsDiscardable()
end
function c249000568.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000568.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000568.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c249000568.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000568.drawfilter(c,e)
	return c:IsSetCard(0x1D0) and not c:IsCode(e:GetHandler():GetCode())
end
function c249000568.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(c249000568.drawfilter,tp,LOCATION_GRAVE,0,1,nil,e) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,1108) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
