--Staff of Alteration
function c90000064.initial_effect(c)
	--Activate Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90000064)
	e1:SetTarget(c90000064.target1)
	e1:SetOperation(c90000064.operation1)
	c:RegisterEffect(e1)
	--Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c90000064.target2)
	e2:SetOperation(c90000064.operation2)
	e2:SetValue(c90000064.value2)
	c:RegisterEffect(e2)
end
function c90000064.filter1_1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c90000064.filter1_2,tp,LOCATION_DECK,0,1,nil,tp,c:GetCode())
end
function c90000064.filter1_2(c,tp,code)
	return c:IsSetCard(0x2d) and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp) and not c:IsCode(code)
end
function c90000064.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>=0
		and Duel.IsExistingTarget(c90000064.filter1_1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000064.filter1_1,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function c90000064.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c90000064.filter1_2,tp,LOCATION_DECK,0,1,1,nil,tp,tc:GetCode())
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
function c90000064.filter2(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsSetCard(0x2d)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function c90000064.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c90000064.filter2,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(90000064,0))
end
function c90000064.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c90000064.value2(e,c)
	return c90000064.filter2(c,e:GetHandlerPlayer())
end