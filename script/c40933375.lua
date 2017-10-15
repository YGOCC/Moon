function c40933375.initial_effect(c)	
	--inaff
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,40933375+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c40933375.condition)
	e1:SetTarget(c40933375.target)
	e1:SetOperation(c40933375.activate)
	c:RegisterEffect(e1)
end
function c40933375.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c40933375.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g1=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
		if g:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(40933375,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g2=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),g1:GetFirst())
		e:SetLabelObject(g2:GetFirst())
	end
end
function c40933375.activate(e,tp,eg,ph,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) and tc:IsOnField() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_PHASE+(ph)+RESET_EVENT+0x1fc0000)
		e1:SetValue(c40933375.efilter)
		tc:RegisterEffect(e1)
		if hc:IsRelateToEffect(e) and hc:IsOnField() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_PHASE+(ph)+RESET_EVENT+0x1fc0000)
		e2:SetValue(c40933375.efilter)
		hc:RegisterEffect(e2)
	end
end
end
function c40933375.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end