--Royal Raid General
function c90000048.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),11,3)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c90000048.condition1)
	e1:SetValue(c90000048.value1)
	c:RegisterEffect(e1)
	--ATK X2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c90000048.cost2)
	e2:SetTarget(c90000048.target2)
	e2:SetOperation(c90000048.operation2)
	c:RegisterEffect(e2)
	--Unattackable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c90000048.value3)
	c:RegisterEffect(e3)
end
function c90000048.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c90000048.value1(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() and not te:GetOwner():IsSetCard(0x1c) then
		local rk=e:GetHandler():GetRank()
		local ec=te:GetOwner()
		if ec:IsType(TYPE_XYZ) then
			return ec:GetOriginalRank()<rk
		else
			return ec:GetOriginalLevel()<rk
		end
	else
		return false
	end
end
function c90000048.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetAttackAnnouncedCount()==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c90000048.filter2(c)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_XYZ)
end
function c90000048.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000048.filter2,tp,LOCATION_MZONE,0,1,nil) end
end
function c90000048.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000048.filter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c90000048.filter3(c,rk)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsType(TYPE_XYZ) and c:GetRank()>rk
end
function c90000048.value3(e,c)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c90000048.filter3,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetRank())
end