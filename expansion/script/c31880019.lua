--Soul Rapture
function c31880019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c31880019.cost)
	e1:SetTarget(c31880019.target)
	e1:SetOperation(c31880019.activate)
	c:RegisterEffect(e1)
end
function c31880019.dfilter(c)
	return c:IsSetCard(0x7C88) and c:IsDiscardable()
end
function c31880019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31880019.dfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c31880019.dfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c31880019.filter(c)
	return c:IsFaceup()
end
function c31880019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31880019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c31880019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,sg:GetCount(),0,0)
end
function c31880019.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c31880019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT)
end