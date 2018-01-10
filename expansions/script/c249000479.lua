--Time-Space Shaper Rainbow Maiden
function c249000479.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41613948,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000479.cost)
	e1:SetTarget(c249000479.target)
	e1:SetOperation(c249000479.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(249000479,ACTIVITY_SPSUMMON,c249000479.counterfilter)
end
function c249000479.counterfilter(c)
	return c:GetSummonType()~=SUMMON_TYPE_LINK
end
function c249000479.costfilter(c)
	return c:IsSetCard(0x1C2) and c:IsAbleToRemoveAsCost()
end
function c249000479.costfilter2(c,e)
	return c:IsSetCard(0x1C2) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000479.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(249000479,tp,ACTIVITY_SPSUMMON)==0 and (Duel.IsExistingMatchingCard(c249000479.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000479.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000479.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000479.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000479.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000479.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000479.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000479.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000479.splimitcost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000479.splimitcost(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c249000479.filter(c,e,tp)
	return ((c:IsLevelAbove(5) or c:GetRank()>=5) and c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)))
	or (c:GetOriginalLevel()<=10 and c:GetOriginalLevel()>=5 and c:IsLocation(LOCATION_HAND+LOCATION_DECK) and not c:IsSummonableCard())
end
function c249000479.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000479.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
end
function c249000479.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000479.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	local sumct
	if tg:GetLevel() < tg:GetRank() then sumct=tg:GetRank()-3 else sumct=tg:GetLevel()-3 end
	if sumct < 5 then sumct=5 end
	if tg==nil then return end
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT) then
		tg:SetTurnCounter(0)
		-- count standby phases
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(c249000479.tohand)
		e1:SetLabel(sumct)
		tg:RegisterEffect(e1)
		-- increase count on specific normal summon
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetRange(LOCATION_REMOVED)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetCondition(c249000479.addcon1)
		e2:SetOperation(c249000479.addturn)
		e2:SetLabel(sumct)
		tg:RegisterEffect(e2)
		--special summon
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetCondition(c249000479.spcon)
		e3:SetTarget(c249000479.sptg)
		e3:SetOperation(c249000479.spop)
		tg:RegisterEffect(e3)
		-- increase count on specific activation
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_REMOVED)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetCondition(c249000479.addcon2)
		e4:SetOperation(c249000479.addturn)
		e4:SetLabel(sumct)
		tg:RegisterEffect(e4)
		--increase count on specific special summon
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_REMOVED)
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e5:SetCondition(c249000479.addcon3)
		e5:SetOperation(c249000479.addturn)
		e5:SetLabel(sumct)
		tg:RegisterEffect(e5)
	end
end
function c249000479.tohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		e:GetHandler():RegisterFlagEffect(249000479,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c249000479.addcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:GetFirst():IsSetCard(0x1C2)
end
function c249000479.addturn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		e:GetHandler():RegisterFlagEffect(249000479,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c249000479.spcon(e,c)
	return  e:GetHandler():GetFlagEffect(249000479)>0
end
function c249000479.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000479.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP) and c:IsType(TYPE_XYZ) then
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(c,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(c,tc2)
			end
		end
	end
end
function c249000479.addcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and rc:IsSetCard(0x1C2)
end
function c249000479.addfilter3(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:IsSetCard(0x1C2)
end
function c249000479.addcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000479.addfilter3,1,nil,tp)
end