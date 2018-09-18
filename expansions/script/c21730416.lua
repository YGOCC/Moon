--A.O. Timestride
function c21730416.initial_effect(c)
	--activate (return entire field to hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730416,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21730416+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c21730416.rettg)
	e1:SetOperation(c21730416.retop)
	c:RegisterEffect(e1)
end
--return entire field to hand
function c21730416.retfilter(c)
	return c:IsSetCard(0x719) and c:IsDiscardable()
end
function c21730416.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c21730416.retfilter,tp,LOCATION_HAND,0,1,c)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c21730416.retop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c21730416.retfilter,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end