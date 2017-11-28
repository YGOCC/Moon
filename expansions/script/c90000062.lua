--Alteration Wand
function c90000062.initial_effect(c)
	--Activate Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90000062)
	e1:SetTarget(c90000062.target1)
	e1:SetOperation(c90000062.operation1)
	c:RegisterEffect(e1)
	--Negate Effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c90000062.condition2)
	e2:SetCost(c90000062.cost2)
	e2:SetTarget(c90000062.target2)
	e2:SetOperation(c90000062.operation2)
	c:RegisterEffect(e2)
end
function c90000062.filter1_1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c90000062.filter1_2,tp,LOCATION_DECK,0,1,nil,tp,c:GetCode())
end
function c90000062.filter1_2(c,tp,code)
	return c:IsSetCard(0x2d) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(code) and c:GetActivateEffect():IsActivatable(tp)
end
function c90000062.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=0
		and Duel.IsExistingTarget(c90000062.filter1_1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000062.filter1_1,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function c90000062.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c90000062.filter1_2,tp,LOCATION_DECK,0,1,1,nil,tp,tc:GetCode())
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
function c90000062.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2d) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c90000062.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90000062.filter2,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c90000062.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90000062.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c90000062.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end