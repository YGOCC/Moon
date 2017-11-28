--Blaze Wing Calamity
function c90000100.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Summon
	aux.AddFusionProcFunRep(c,c90000100.mfilter,3,true)
	--Summon Condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(c90000100.target2)
	c:RegisterEffect(e2)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c90000100.operation3)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c90000100.cost4)
	e4:SetTarget(c90000100.target4)
	e4:SetOperation(c90000100.operation4)
	c:RegisterEffect(e4)
	--Damage
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c90000100.condition5)
	e5:SetOperation(c90000100.operation5)
	c:RegisterEffect(e5)
	--Special Summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCost(c90000100.cost6)
	e6:SetTarget(c90000100.target6)
	e6:SetOperation(c90000100.operation6)
	c:RegisterEffect(e6)
end
function c90000100.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c90000100.target2(e,c)
	if c:GetCardTargetCount()==0 then return false end
	return c:GetCardTarget():IsContains(e:GetHandler())
end
function c90000100.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:GetCount()>0 and g:IsContains(e:GetHandler()) then
		Duel.NegateEffect(ev)
	end
end
function c90000100.filter4_1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToRemoveAsCost()
end
function c90000100.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000100.filter4_1,tp,LOCATION_GRAVE,0,7,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c90000100.filter4_1,tp,LOCATION_GRAVE,0,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c90000100.filter4_2(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk)
end
function c90000100.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c90000100.filter4_2,tp,0,LOCATION_MZONE,nil,e:GetHandler():GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c90000100.filter4_3(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(atk)
end
function c90000100.operation4(e,tp,eg,ep,ev,re,r,rp)
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(c90000100.filter4_3,nil,e:GetHandler():GetAttack())
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
function c90000100.condition5(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	e:SetLabel(c:GetBaseAttack())
	return eg:GetCount()==1 and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetBaseAttack()>0
end
function c90000100.operation5(e,tp,eg,ep,ev,re,r,rp)
	local c=eg:GetFirst()
	Duel.Damage(c:GetControler(),e:GetLabel(),REASON_EFFECT)
end
function c90000100.filter6(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsAbleToGraveAsCost()
end
function c90000100.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000100.filter6,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c90000100.filter6,tp,LOCATION_REMOVED,0,1,ft,e:GetHandler())
	e:SetLabel(g:GetCount())
	Duel.SendtoGrave(g,REASON_COST)
end
function c90000100.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,68815402,0,0x4011,1000,1000,3,RACE_PYRO,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,e:GetLabel(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,e:GetLabel(),0,0)
end
function c90000100.operation6(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<e:GetLabel() or not Duel.IsPlayerCanSpecialSummonMonster(tp,68815402,0,0x4011,1000,1000,3,RACE_PYRO,ATTRIBUTE_FIRE) then return end
	for i=1,e:GetLabel() do
		local token=Duel.CreateToken(tp,68815402)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end