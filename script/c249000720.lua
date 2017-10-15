--Shimmer-Familiar Reflective Knight
function c249000720.initial_effect(c)
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79418153,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000720.piercecon)
	e1:SetTarget(c249000720.piercetg)
	e1:SetOperation(c249000720.pierceop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5818294,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c249000720.negcon)
	e2:SetCost(c249000720.negcost)
	e2:SetTarget(c249000720.negtg)
	e2:SetOperation(c249000720.negop)
	c:RegisterEffect(e2)
end
function c249000720.piercecon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:IsControler(tp) and d:IsDefensePos()
end
function c249000720.piercetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.GetAttacker():CreateEffectRelation(e)
end
function c249000720.pierceop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToEffect(e) and a:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
	end
end
function c249000720.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and (c:IsSetCard(0x1EA) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO))
end
function c249000720.confilter(c)
	return c:IsSetCard(0x1EA) and not c:IsCode(249000720)
end
function c249000720.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c249000720.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(c249000720.confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function c249000720.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c249000720.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c249000720.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end 