--Abscheulicher Stolz
function c10100109.initial_effect(c)
    --To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100109,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,10100109+EFFECT_COUNT_CODE_OATH)
	e3:SetCost(c10100109.cost)
	e3:SetTarget(c10100109.target3)
	e3:SetOperation(c10100109.activate3)
	c:RegisterEffect(e3)
end
function c10100109.cfilter(c)
	return c:IsSetCard(0x328) and not c:IsPublic()
end
function c10100109.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100109.cfilter,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c10100109.cfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c10100109.filter3(c)
	return c:IsAbleToGrave()
end
function c10100109.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100109.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c10100109.filter3,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c10100109.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100109.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,POS_FACEUP,REASON_EFFECT)
	end
end
