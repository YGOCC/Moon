-- Magenic Body Tahir [Script by Naab]
function c24951007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_NEGATE)
	e1:SetCost(c24951007.cost)
	e1:SetCondition(c24951007.condition)
	e1:SetOperation(c24951007.operation)
	c:RegisterEffect(e1)
end
function c24951007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) 
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c24951007.condition(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.IsPlayerCanSpecialSummonMonster(tp,24951012,0,0x5F453A,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.IsExistingMatchingCard(c24951007.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)))
end
function c24951007.negfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsPosition(POS_FACEUP) and aux.disfilter1(c)
end
function c24951007.operation(e,tp,eg,ep,ev,re,r,rp)
	local selectoption1 = 0 
	local selectoption2 = 0
	if Duel.IsExistingMatchingCard(c24951007.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		selectoption1 = 1
	end	
	if (Duel.IsPlayerCanSpecialSummonMonster(tp,24951012,0,0x5F453A,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then
		selectoption2 = 1
	end
	if selectoption1 == 1 and selectoption2 == 1 then
		if not Duel.SelectYesNo(tp,aux.Stringid(24951007,0)) then		
			selectoption1 = 0
		end
	end
	if selectoption1 == 1 then
		local g=Duel.SelectMatchingCard(tp,c24951007.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if not tc:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=e1:Clone()
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e3)
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
		local token=Duel.CreateToken(tp,24951012)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local tc2 = token
		tc2:RegisterFlagEffect(24951007,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_ONFIELD)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c24951007.immfilter)
		e2:SetReset(RESET_PHASE+PHASE_END)
		token:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c24951007.immfilter(e,te,tp)
	if te:IsActiveType(TYPE_TRAP) and not te:GetHandler():GetControler() == tp then 
		return true 
	end
end