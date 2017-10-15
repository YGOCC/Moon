--Mecha Girl Computing
function c12375.initial_effect(c)
	--ATK1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(c12375.condition)
	e1:SetTarget(c12375.target)
	e1:SetOperation(c12375.operation)
	c:RegisterEffect(e1)
	--ATK2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12375,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c12375.condition2)
	e2:SetCost(c12375.cost)
	e2:SetTarget(c12375.target2)
	e2:SetOperation(c12375.operation2)
	c:RegisterEffect(e2)
end
function c12375.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c12375.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.IsExistingMatchingCard(c12375.atkfilter,tp,LOCATION_MZONE,0,1,nil)end
end
function c12375.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3052)
end
function c12375.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c12375.atkfilter,tp,LOCATION_MZONE,0,nil)
	if g1:GetCount()==0 then return end
	local atk=g2:GetCount()*-500
	local tc=g1:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
	end
end
function c12375.condition2(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()~=tp
end
function c12375.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12375.filter(c)
	return c:IsFaceup()
end
function c12375.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12375.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12375.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12375.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c12375.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-500)
		tc:RegisterEffect(e1)
	end
end
