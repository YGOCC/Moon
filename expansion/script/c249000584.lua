--Demi Angel Gardna
function c249000584.initial_effect(c)
	--setcode
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_SETCODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(0x1D3)
	e1:SetRange(LOCATION_HAND)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5818294,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,249000584)
	e2:SetCondition(c249000584.negcon)
	e2:SetCost(c249000584.negcost)
	e2:SetTarget(c249000584.negtg)
	e2:SetOperation(c249000584.negop)
	c:RegisterEffect(e2)
end
function c249000584.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup()
	and (c:IsSetCard(0x1D1) or c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ))
end
function c249000584.confilter(c)
	return c:IsSetCard(0x1D1) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000584.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c249000584.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(c249000584.confilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil)
end
function c249000584.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c249000584.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c249000584.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end