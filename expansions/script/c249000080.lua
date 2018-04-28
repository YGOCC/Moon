--Chaos-Order Artifact
function c249000080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000080.cost)
	e1:SetTarget(c249000080.target)
	e1:SetOperation(c249000080.activate)
	c:RegisterEffect(e1)
end
function c249000080.cfilter(c,tp)
	return c:IsSetCard(0x40CF) and c:IsAbleToRemoveAsCost()
end
function c249000080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000080.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	g=Duel.SelectMatchingCard(tp,c249000080.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000080.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetRank() >= 5 and c:GetRank() <=8 and c:IsSetCard(0x48)
end
function c249000080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c249000080.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000080.overlayfilter(c)
	return (not c:IsHasEffect(EFFECT_NECRO_VALLEY)) and (not c:IsType(TYPE_MONSTER))
end
function c249000080.revealfilter(c)
	return c:IsSetCard(0x95) and not c:IsPublic()
end
function c249000080.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	if not Duel.IsExistingMatchingCard(c249000080.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000080.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) then
			local c=e:GetHandler()
			local tc=g:GetFirst()
			local og=Duel.SelectMatchingCard(tp,c249000080.overlayfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			c:CancelToGrave()
			Duel.Overlay(tc,Group.FromCards(c))
			tc:CompleteProcedure()
			local negate=true
			if Duel.IsExistingMatchingCard(c249000080.revealfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(526,1)) then
				local g1=Duel.SelectMatchingCard(tp,c249000080.revealfilter,tp,LOCATION_HAND,0,1,1,nil)
				Duel.ConfirmCards(1-tp,g1)
				Duel.ShuffleHand(tp)
				negate=false
			end
			if negate then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e3)
		end
	end
end