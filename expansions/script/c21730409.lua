--S.G. Timestride
function c21730409.initial_effect(c)
	--activate (return entire field to hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730409,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21730409+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c21730409.retcost)
	e1:SetTarget(c21730409.rettg)
	e1:SetOperation(c21730409.retop)
	c:RegisterEffect(e1)
end
--return entire field to hand
function c21730409.retfilter(c)
	return c:IsSetCard(0x719) and c:IsDiscardable()
end
function c21730409.retcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730409.retfilter,tp,LOCATION_HAND,0,1,nil,e:GetHandler()) end
	Duel.DiscardHand(tp,c21730409.retfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c21730409.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c21730409.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end