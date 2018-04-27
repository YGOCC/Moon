-- Magenic Body Dhin [Script by Naab]
function c24951010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_REMOVE)
	e1:SetCondition(c24951010.condition)
	e1:SetOperation(c24951010.operation)
	c:RegisterEffect(e1)
end
function c24951010.condition(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.IsPlayerCanSpecialSummonMonster(tp,24951013,0,0x5F453A,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (Duel.IsExistingMatchingCard(c24951010.banfilter,tp,(LOCATION_ONFIELD+LOCATION_GRAVE),(LOCATION_ONFIELD+LOCATION_GRAVE),1,nil)))
end
function c24951010.banfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsStatus(STATUS_DISABLED)) and c:IsAbleToRemove(tp)
end
function c24951010.operation(e,tp,eg,ep,ev,re,r,rp)
	local selectoption1 = 0 
	local selectoption2 = 0
	if Duel.IsExistingMatchingCard(c24951010.banfilter,tp,(LOCATION_ONFIELD+LOCATION_GRAVE),(LOCATION_ONFIELD+LOCATION_GRAVE),1,nil) then
		selectoption1 = 1
	end	
	if (Duel.IsPlayerCanSpecialSummonMonster(tp,24951013,0,0x5F453A,1500,1500,4,RACE_SPELLCASTER,ATTRIBUTE_LIGHT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then
		selectoption2 = 1
	end
	if selectoption1 == 1 and selectoption2 == 1 then
		if not Duel.SelectYesNo(tp,aux.Stringid(24951010,0)) then		
			selectoption1 = 0
		end
	end
	if selectoption1 == 1 then
		local g=Duel.SelectMatchingCard(tp,c24951010.banfilter,tp,(LOCATION_ONFIELD+LOCATION_GRAVE),(LOCATION_ONFIELD+LOCATION_GRAVE),1,1,nil,e,tp)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		if tc then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
		if selectoption2 == 1 then
			if Duel.SelectYesNo(tp,aux.Stringid(24951010,1)) then
				Duel.BreakEffect()
			else
				selectoption2 = 0
			end
		end
	end
	if selectoption2 == 1 then
		local token=Duel.CreateToken(tp,24951015)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local tc2 = token
		tc2:RegisterFlagEffect(24951010,RESET_EVENT+0x1fe0000,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		token:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		token:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end