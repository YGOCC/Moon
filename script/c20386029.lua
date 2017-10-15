--FFX - Farplane Wind
function c20386029.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c20386029.condition)
	e1:SetTarget(c20386029.target)
	e1:SetOperation(c20386029.activate)
	c:RegisterEffect(e1)
end
function c20386029.cfilter(c)
	return c:IsFaceup() and c:IsCode(20386000)
end
function c20386029.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c20386029.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c20386029.filter(c)
	return c:IsFaceup() and not (c:IsSetCard(0x31C55) or c:IsCode(20386000))
end
function c20386029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c20386029.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c20386029.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20386029.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end