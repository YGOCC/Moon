--Cyberse Enchanter Recoded
function c249000974.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000974.cost)
	e1:SetTarget(c249000974.target)
	e1:SetOperation(c249000974.operation)
	c:RegisterEffect(e1)
end
function c249000974.cfilter(c)
	return (c:IsSetCard(0x1FE) or c:IsCode(70238111)) and not c:IsPublic()
end
function c249000974.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000974.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c249000974.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c249000974.filter(c,e,tp,m1,m2,ft)
	if not c:IsRace(RACE_CYBERSE) or not c:IsType(TYPE_LINK) or c:GetLink() < 4 or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false) then return false end
	local mg=m1
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetLevel,c:GetLink()*2,c)
	else
		return ft>-1 and mg:IsExists(c249000974.mfilterf,1,nil,tp,mg,c)
	end
end
function c249000974.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetLevel,rc:GetLink()*2,rc)
	else return false end
end
function c249000974.mfilter(c)
	return c:GetLevel()>0 and (c:IsSetCard(0x1FE) or c:IsCode(70238111)) and c:IsAbleToRemove()
end
function c249000974.mfilter0(c,tp)
	return c:IsRace(RACE_CYBERSE) and c:GetLevel()>0 and Duel.IsPlayerCanRelease(tp,c)
end
function c249000974.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(c249000974.mfilter0,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)
		local mg2=Duel.GetMatchingGroup(c249000974.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c249000974.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
function c249000974.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(c249000974.mfilter0,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)
	local mg2=Duel.GetMatchingGroup(c249000974.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000974.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1
		mg:Merge(mg2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetLevel,tc:GetLink()*2,tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c249000974.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetLevel,tc:GetLink()*2,tc)
			mat:Merge(mat2)
		end
		local tc2=mat:GetFirst()
		while tc2 do
			if tc2:IsLocation(LOCATION_GRAVE) then Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT) else Duel.Release(tc2,REASON_EFFECT) end
			tc2=mat:GetNext()
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end