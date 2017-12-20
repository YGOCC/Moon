--Viravolve Rabbit
function c221812200.initial_effect(c)
	--You can banish this face-up card you control: Special Summon 2 "Viravolve Rabbit" from your Deck. You can only use this effect of "Viravolve Rabbit" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,221812200)
	e1:SetCost(c221812200.spcost)
	e1:SetTarget(c221812200.sptg)
	e1:SetOperation(c221812200.spop)
	c:RegisterEffect(e1)
	--If this card is sent from the field to the GY, or detached from an Xyz Monster, inflict 200 damage to your opponent.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c221812200.thcon)
	e2:SetOperation(c221812200.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	e3:SetCondition(function(e) local c=e:GetHandler() return c:IsPreviousLocation(LOCATION_OVERLAY) and not c:IsReason(REASON_RULE) end)
	c:RegisterEffect(e3)
end
function c221812200.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c221812200.spfilter(c,e,tp)
	return c:IsCode(221812200) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c221812200.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c221812200.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c221812200.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c221812200.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	if g:GetCount()==2 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c221812200.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetPreviousLocation()
	return (bit.band and bit.band(loc,LOCATION_ONFIELD)~=0) or loc&LOCATION_ONFIELD~=0 or (loc==LOCATION_OVERLAY and not c:IsReason(REASON_RULE))
end
function c221812200.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,221812200)
	Duel.Damage(1-tp,200,REASON_EFFECT)
end
