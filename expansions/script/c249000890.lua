--Vylina the Battle Mage
function c249000890.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c249000890.lcheck)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(73341839,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,2490008901)
	e1:SetCost(c249000890.spcost)
	e1:SetTarget(c249000890.sptg)
	e1:SetOperation(c249000890.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30914564,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,2490008902)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c249000890.target)
	e2:SetOperation(c249000890.operation)
	c:RegisterEffect(e2)
end
function c249000890.lcheckfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and not c:IsLinkType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK)
end
function c249000890.lcheck(g)
	return g:IsExists(c249000890.lcheckfilter,1,nil)
end
function c249000890.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c249000890.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c249000890.costfilter,2,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c249000890.costfilter,2,2,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c249000890.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000890.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) end
end
function c249000890.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000890.spellfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c249000890.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if dc:IsType(TYPE_MONSTER) and c:IsRelateToEffect(e)
	and Duel.SelectYesNo(tp,526) then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,dc)
		Duel.ShuffleHand(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(800)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		c:RegisterEffect(e2)
	elseif dc:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(c249000890.spellfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.SelectYesNo(tp,526) then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,dc)
		Duel.ShuffleHand(tp)
		local g=Duel.SelectMatchingCard(tp,c249000890.spellfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetOperation(c249000890.thop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY)
			tc:RegisterEffect(e1)
		end
	elseif dc:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	and Duel.SelectYesNo(tp,526) then
		Duel.BreakEffect()
		Duel.ConfirmCards(1-tp,dc)
		Duel.ShuffleHand(tp)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
		local tc=g:GetFirst()
		while tc do
			if Duel.Destroy(tc,REASON_EFFECT)==0 and c:IsFaceup() then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			tc=g:GetNext()
		end
	end
end
function c249000890.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end