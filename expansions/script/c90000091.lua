--Empire Great Escape
function c90000091.initial_effect(c)
	--Negate Effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c90000091.condition1)
	e1:SetTarget(c90000091.target1)
	e1:SetOperation(c90000091.operation1)
	c:RegisterEffect(e1)
	--Cannot Attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c90000091.condition2)
	e2:SetCost(c90000091.cost2)
	e2:SetOperation(c90000091.operation2)
	c:RegisterEffect(e2)
end
function c90000091.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5d) and c:IsControler(tp)
end
function c90000091.condition1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90000091.filter1,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c90000091.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsCanAddCounter(0x1000,1) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,eg,1,0,0x1000)
	end
end
function c90000091.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		eg:GetFirst():AddCounter(0x1000,1)
	end
end
function c90000091.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
end
function c90000091.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90000091.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c90000091.tg1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90000091.tg1(e,c)
	return c:GetCounter(0x1000)>0
end