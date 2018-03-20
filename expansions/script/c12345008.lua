--midori
function c12345008.initial_effect(c)
	c:SetSPSummonOnce(12345008)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c12345008.target)
	e1:SetOperation(c12345008.operation)
	c:RegisterEffect(e1)
end
function c12345008.tgfilter(c,rac)
	return c:IsSetCard(0x159) and c:IsRace(rac) and c:IsAbleToGrave()
end
function c12345008.rmfilter(c,tp)
	return c:IsSetCard(0x159) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c12345008.tgfilter,tp,LOCATION_DECK,0,1,nil,c:GetRace())
end
function c12345008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12345008.rmfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12345008.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12345008.rmfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c12345008.tgfilter,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst():GetRace())
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
