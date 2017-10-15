--Necromantia Castletown
function c5312022.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,5312022)
	e1:SetOperation(c5312022.activate)
	c:RegisterEffect(e1)
end
function c5312022.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x223) and c:IsAbleToGrave()
end
function c5312022.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c5312022.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(5312022,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end