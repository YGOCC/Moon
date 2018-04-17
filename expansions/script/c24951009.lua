-- Magenic Body Hanu [Script by Naab]
function c24951009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetCost(c24951009.cost)
	e1:SetCondition(c24951009.condition)
	e1:SetOperation(c24951009.operation)
	c:RegisterEffect(e1)
end
function c24951009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) 
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c24951009.condition(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.IsPlayerCanSpecialSummonMonster(tp,24951013,0,0x5F453A,1000,1000,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.IsExistingMatchingCard(c24951009.modfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)))
end
function c24951009.modfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP)
end
function c24951009.operation(e,tp,eg,ep,ev,re,r,rp)
	local selectoption1 = 0 
	local selectoption2 = 0
	if Duel.IsExistingMatchingCard(c24951009.modfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		selectoption1 = 1
	end	
	if (Duel.IsPlayerCanSpecialSummonMonster(tp,24951013,0,0x5F453A,1000,1000,1,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then
		selectoption2 = 1
	end
	if selectoption1 == 1 and selectoption2 == 1 then
		if not Duel.SelectYesNo(tp,aux.Stringid(24951009,0)) then		
			selectoption1 = 0
		end
	end
	if selectoption1 == 1 then
		local g=Duel.SelectMatchingCard(tp,c24951009.modfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if tc then
			if Duel.SelectOption(tp,aux.Stringid(24951009,2),aux.Stringid(24951009,3)) == 0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(-500)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(-500)
				tc:RegisterEffect(e2)
			else
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(500)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(500)
				tc:RegisterEffect(e2)
			end
		end
		if selectoption2 == 1 then
			if Duel.SelectYesNo(tp,aux.Stringid(24951006,1)) then
				Duel.BreakEffect()
			else
				selectoption2 = 0
			end
		end
	end
	if selectoption2 == 1 then
		local token=Duel.CreateToken(tp,24951014)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local tc2 = token
		tc2:RegisterFlagEffect(24951009,RESET_EVENT+0x1fe0000,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetLabel(Duel.GetTurnCount()+1)
		e1:SetLabelObject(tc2)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCondition(c24951009.rmcon)
		e1:SetOperation(c24951009.rmop)
		Duel.RegisterEffect(e1,tp)
		Duel.SpecialSummonComplete()
	end
end
function c24951009.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local tc2=e:GetLabelObject()
	if tc2:GetFlagEffect(24951009)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function c24951009.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end