--Kitseki Patience
--Script by XGlitchy30
function c88523892.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c88523892.cost)
	e1:SetTarget(c88523892.target1)
	e1:SetOperation(c88523892.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88523892,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c88523892.condition)
	e2:SetCost(c88523892.cost)
	e2:SetTarget(c88523892.target2)
	e2:SetOperation(c88523892.activate)
	c:RegisterEffect(e2)
end
--Activate
function c88523892.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,88523892)+1
	if chk==0 then return Duel.CheckLPCost(tp,ct*400) end
	Duel.PayLPCost(tp,ct*400)
	Duel.RegisterFlagEffect(e,88523892,RESET_PHASE+PHASE_END,0,1)
end
function c88523892.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return true end
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer() and tg:IsOnField() and tg:IsCanBeEffectTarget(e) and Duel.IsPlayerCanDiscardDeck(1-tp,1) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.SetTargetCard(tg)
	else e:SetProperty(0) end
end
function c88523892.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c88523892.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and tg:IsOnField() and tg:IsCanBeEffectTarget(e) and Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetTargetCard(tg)
end
function c88523892.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.IsPlayerCanDiscardDeck(1-tp,1) then
		if Duel.NegateAttack() then
			Duel.DiscardDeck(1-tp,1,REASON_EFFECT)
		end
	end
end