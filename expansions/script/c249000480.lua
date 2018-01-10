--Time-Space Shaper Emerald Gaze
function c249000480.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41613948,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000480.cost)
	e1:SetTarget(c249000480.target)
	e1:SetOperation(c249000480.operation)
	c:RegisterEffect(e1)
	--summon & set with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75498415,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c249000480.ntcon)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(249000480,ACTIVITY_SPSUMMON,c249000480.counterfilter)
end
function c249000480.counterfilter(c)
	return c:GetSummonType()~=SUMMON_TYPE_LINK
end
function c249000480.costfilter(c)
	return c:IsSetCard(0x1C2) and c:IsAbleToRemoveAsCost()
end
function c249000480.costfilter2(c,e)
	return c:IsSetCard(0x1C2) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000480.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(249000479,tp,ACTIVITY_SPSUMMON)==0 and (Duel.IsExistingMatchingCard(c249000480.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000480.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000480.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000480.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000480.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000480.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000480.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000480.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000480.splimitcost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000480.splimitcost(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c249000480.filter(c,e,tp)
	return ((c:IsLevelAbove(5) or c:GetRank()>=5) and c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)))
	or (c:GetOriginalLevel()<=10 and c:GetOriginalLevel()>=5 and c:IsLocation(LOCATION_HAND+LOCATION_DECK) and not c:IsSummonableCard())
end
function c249000480.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000480.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK)
end
function c249000480.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000480.filter,tp,LOCATION_EXTRA+LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
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
		e1:SetOperation(c249000480.tohand)
		e1:SetLabel(sumct)
		tg:RegisterEffect(e1)
		--special summon
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_IGNITION)
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetCountLimit(1)
		e3:SetRange(LOCATION_REMOVED)
		e3:SetCondition(c249000480.spcon)
		e3:SetTarget(c249000480.sptg)
		e3:SetOperation(c249000480.spop)
		tg:RegisterEffect(e3)
		-- increase count on specific activation
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_REMOVED)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetCountLimit(2)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		e4:SetCondition(c249000480.addcon2)
		e4:SetOperation(c249000480.addturn)
		e4:SetLabel(sumct)
		tg:RegisterEffect(e4)
	end
end
function c249000480.tohand(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		e:GetHandler():RegisterFlagEffect(249000480,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c249000480.addturn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		e:GetHandler():RegisterFlagEffect(249000480,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c249000480.spcon(e,c)
	return  e:GetHandler():GetFlagEffect(249000480)>0
end
function c249000480.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000480.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetCountLimit(1)	
			e1:SetValue(c249000480.valcon)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
			if c:IsType(TYPE_XYZ) then
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
end
function c249000480.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end
function c249000480.addcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return (re:GetActiveType()==TYPE_SPELL or re:GetActiveType()==TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function c249000480.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
end