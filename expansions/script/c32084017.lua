--Orichalcos Bronze Guard
function c32084017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c32084017.cost)
	e1:SetTarget(c32084017.target)
	e1:SetOperation(c32084017.activate)
	c:RegisterEffect(e1)
		--Immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c32084017.etarget)
	e2:SetValue(c32084017.efilter)
	c:RegisterEffect(e2)
end
function c32084017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c32084017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,32084017,0x7D54,0x21,1000,2000,4,RACE_ROCK,ATTRIBUTE_DARK) end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32084017.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,32084017,0x7D54,0x21,1000,2000,4,RACE_ROCK,ATTRIBUTE_DARK) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		c:RegisterFlagEffect(32084017,RESET_EVENT+0x1fe0000,0,1)
		Duel.SpecialSummonComplete()
	end
end
function c32084017.etarget(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7D54)
end
function c32084017.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end