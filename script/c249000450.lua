--Overlay-Force Shadow-Concealment
function c249000450.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000450.condition)
	e1:SetTarget(c249000450.target)
	e1:SetOperation(c249000450.activate)
	c:RegisterEffect(e1)
end
function c249000450.confilter(c)
	return c:IsSetCard(0x1BF)
end
function c249000450.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000450.confilter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000450.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1BF) or c:IsType(TYPE_XYZ))
end
function c249000450.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c249000450.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000450.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000450.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000450.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(c249000450.efilter)
		e2:SetLabelObject(tc)
		tc:RegisterEffect(e2)
	end
end
function c249000450.efilter(e,re)
	return e:GetHandler()~=re:GetHandler() and e:GetLabelObject()~=re:GetHandler()
end
