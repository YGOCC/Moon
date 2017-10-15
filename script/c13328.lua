--Voidol On Stage!
function c13328.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c13328.cost)
	e1:SetTarget(c13328.target)
	e1:SetOperation(c13328.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c13328.cfilter(c)
	return c:IsSetCard(0x5DD) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c13328.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13328.cfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c13328.cfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c13328.filter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:GetSummonPlayer()==tp and not c:IsDisabled()
end
function c13328.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c13328.filter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c13328.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c13328.filter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
		and c:GetSummonPlayer()==tp and c:IsRelateToEffect(e)
end
function c13328.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c13328.filter2,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>0 and not tc:IsDisabled()then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
	end
		if tc:IsRelateToEffect(e)then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x5DD) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.BreakEffect()
		Duel.DisableShuffleCheck()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleHand(tp)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
end

