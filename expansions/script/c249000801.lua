--Extra-Transcend Summon Spiral
function c249000801.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000801)
	e1:SetCost(c249000801.spcost)
	e1:SetTarget(c249000801.sptg)
	e1:SetOperation(c249000801.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(249000801,ACTIVITY_SPSUMMON,c249000801.counterfilter)
end
function c249000801.counterfilter(c)
	return c:GetSummonType()~=SUMMON_TYPE_LINK
end
function c249000801.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
end
function c249000801.costfilter(c)
	return c:IsSetCard(0x1F1) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000801.costfilter2(c)
	return c:IsSetCard(0x1F1) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c249000801.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return Duel.GetCustomActivityCount(249000801,tp,ACTIVITY_SPSUMMON)==0 and (Duel.IsExistingMatchingCard(c249000801.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000801.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000801.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000801.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000801.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000801.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000801.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000801.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000801.splimitcost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000801.splimitcost(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c249000801.filter(c,e,tp,c2)
	local lv=c:GetLevel()
	return lv > 0 and (not c:IsImmuneToEffect(e)) and (not c:IsType(TYPE_TOKEN))
		and Duel.IsExistingMatchingCard(c249000801.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,e,tp,lv,c2)
end
function c249000801.filter2(c,e,tp,lv2,c2)
	local lv=c:GetLevel()
	return lv > 0 and lv + lv2 <= 9 and (not c:IsImmuneToEffect(e)) and (not c:IsType(TYPE_TOKEN)) and c~=c2
end
function c249000801.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c249000801.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000801.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000801.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,e,tp,c)
	if g then
		local att=g:GetFirst():GetOriginalAttribute()
		local race=g:GetFirst():GetOriginalRace()
		local g2=Duel.SelectMatchingCard(tp,c249000801.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,g:GetFirst(),e,tp,g:GetFirst():GetOriginalLevel(),g:GetFirst())
		if g2 then
			att=bit.bor(att,g2:GetFirst():GetOriginalAttribute())
			race=bit.bor(race,g2:GetFirst():GetOriginalRace())
			g:Merge(g2)
			if Duel.SendtoGrave(g,REASON_EFFECT)~=2 then return end
			local ac=Duel.AnnounceCardFilter(tp,race,OPCODE_ISRACE,att,OPCODE_ISATTRIBUTE,OPCODE_AND,TYPE_XYZ+TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_AND,c:GetOriginalCode(),OPCODE_ISCODE,OPCODE_OR)
			local sc=Duel.CreateToken(tp,ac)
			if ac and ac~=c:GetOriginalCode() and (sc:GetLevel()==g:GetSum(Card.GetOriginalLevel) or sc:GetRank()==g:GetSum(Card.GetOriginalLevel)) then
				local summontype=SUMMON_TYPE_XYZ
				if sc:IsType(TYPE_SYNCHRO) then summmontype=SUMMON_TYPE_SYNCHRO end
				if Duel.SpecialSummonStep(sc,summontype,tp,tp,false,false,POS_FACEUP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CHANGE_DAMAGE)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(0,1)
					e1:SetValue(c249000801.damval)
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					e2:SetCountLimit(1)
					e2:SetCondition(c249000801.gycon)
					e2:SetOperation(c249000801.gyop)
					sc:RegisterEffect(e2)
				end
				Duel.SpecialSummonComplete()
				if sc:IsType(TYPE_XYZ) then
					if c:IsRelateToEffect(e) then Duel.Overlay(sc,c) end
					local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
					if tc2 then
						Duel.Overlay(sc,tc2)
					end
				end
			end
		end
	end
end
function c249000801.gycon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c249000801.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
function c249000801.damval(e,re,val,r,rp,rc)
	return val/2
end