--Summoning-Rite Preperation Summon
function c249000234.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000234.cost)
	e1:SetTarget(c249000234.target)
	e1:SetOperation(c249000234.activate)
	c:RegisterEffect(e1)
end
function c249000234.cfilter(c)
	return c:IsSetCard(0x1B0) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c249000234.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000234.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c249000234.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c249000234.filter(c,e,tp)
	return c:IsLevelBelow(6) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000234.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000234.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c249000234.filter2(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000234.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000234.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetOperation(c249000234.desop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			tc:RegisterEffect(e1)
			local g2=Duel.GetMatchingGroup(c249000234.filter2,tp,LOCATION_HAND,0,nil,e,tp)
			if g2:GetCount() > 0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,2) then
				local sg2=Duel.SelectMatchingCard(tp,c249000234.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				local tc2=sg2:GetFirst()
				if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=0 then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetOperation(c249000234.desop)
					e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					e2:SetCountLimit(1)
					tc2:RegisterEffect(e2)
				end
			end	
		end
	end
end
function c249000234.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
