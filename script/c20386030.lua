--FFX - Distillers
function c20386030.initial_effect(c)
	--negate activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20386030,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c20386030.condition)
	e3:SetTarget(c20386030.target)
	e3:SetOperation(c20386030.operation)
	c:RegisterEffect(e3)
end
function c20386030.efilter(c,e,tp,eg,ep,ev,re,r,rp,chk)
	return (c:IsCode(20386000) or c:IsSetCard(0x31C55)) and c:IsFaceup()
end
function c20386030.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20386030.efilter,tp,LOCATION_MZONE,0,1,nil)
end
function c20386030.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c20386030.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,POS_FACEUP,REASON_EFFECT)
	end
end