--Pandemoniumgraph of Demolition
function c90266514.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--During each of your Standby Phase, Pay 1000 Life Points or destroy this card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetDescription(11)
	e1:SetCondition(c90266514.mtcon)
	e1:SetOperation(c90266514.mtop)
	c:RegisterEffect(e1)
	--Once per turn, During Either Player's turn: You can Negate the effects of 1 non-Pandemonium monster on the Field, these changes last until the End Phase.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetDescription(1131)
	e2:SetTarget(c90266514.distg)
	e2:SetOperation(c90266514.disop)
	c:RegisterEffect(e2)
	--When your opponent Declares an attack on a Pandemonium Monster you control OR Activates an Effect that targets 1 or more Pandemonium monsters you control: You can destroy this card, also negate the attack or activation, and if you do, destroy it.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetDescription(1124)
	e3:SetCondition(c90266514.bcon)
	e3:SetTarget(c90266514.tg)
	e3:SetOperation(c90266514.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c90266514.econ)
	c:RegisterEffect(e4)
end
function c90266514.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90266514.mtop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(90266514,0)) then
		Duel.PayLPCost(tp,1000)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end
function c90266514.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_PANDEMONIUM) and not c:IsDisabled()
end
function c90266514.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90266514.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c90266514.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c90266514.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c90266514.bcon(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return Duel.GetTurnPlayer()~=tp and c and c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM)
end
function c90266514.efilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c90266514.econ(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90266514.efilter,1,nil,tp)
end
function c90266514.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetAttacker() and Duel.GetAttacker():IsDestructable()) or Duel.IsChainNegatable(ev) end
	local g=Group.FromCards(e:GetHandler())
	if re then
		-- e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
			g:Merge(eg)
		end
	else
		-- e:SetCategory(CATEGORY_DESTROY)
		g:AddCard(Duel.GetAttacker())
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c90266514.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Destroy(c,REASON_EFFECT)
	local g=Group.CreateGroup()
	if Duel.GetAttacker() then g:AddCard(Duel.GetAttacker()) end
	if re then g:Merge(eg) end
	if (Duel.NegateActivation(ev) or Duel.NegateAttack())
		and (not re or re:GetHandler():IsRelateToEffect(re)) then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
