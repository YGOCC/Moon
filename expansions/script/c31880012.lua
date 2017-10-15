--Deathly Winds
function c31880012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c31880012.target)
	e1:SetOperation(c31880012.activate)
	c:RegisterEffect(e1)
end
function c31880012.filter(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c31880012.hfilter(c)
	return c:IsSetCard(0x7C88)
end
function c31880012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31880012.filter,tp,0,LOCATION_SZONE,1,nil) and Duel.IsExistingMatchingCard(c31880012.hfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c31880012.filter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c31880012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c31880012.filter,tp,0,LOCATION_SZONE,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_HAND,0,1,1,nil,0x7C88)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end