--Chaos Mage's Creation Ritual
function c249000788.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000788.cost)
	e1:SetTarget(c249000788.target)
	e1:SetOperation(c249000788.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c249000788.setcon)
	e2:SetTarget(c249000788.settg)
	e2:SetOperation(c249000788.setop)
	c:RegisterEffect(e2)
end
function c249000788.costfilter(c)
	return c:IsSetCard(0x30CF) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000788.costfilter2(c)
	return c:IsSetCard(0x30CF) and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c249000788.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000788.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(c249000788.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
		if Duel.GetLP(tp)< 3000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1500)
	end
	local option
	if Duel.IsExistingMatchingCard(c249000788.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())  then option=0 end
	if Duel.IsExistingMatchingCard(c249000788.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) then option=1 end
	if Duel.IsExistingMatchingCard(c249000788.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	and Duel.IsExistingMatchingCard(c249000788.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000788.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000788.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000788.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000788.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(c249000788.racefilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,RACE_ALL)
		and Duel.IsExistingMatchingCard(c249000788.attfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0xFF) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c249000788.racefilter(c,race)
	return c:IsRace(race) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000788.attfilter(c,att)
	return c:IsAttribute(att) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000788.rmfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c249000788.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race=0
	local i=1
	while i < 0x1000000 do
		if Duel.IsExistingMatchingCard(c249000788.racefilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,i)
			then race=race+i
		end
	i=i*2
	end
	local att=0
	i=1
	while i < 0x40 do
		if Duel.IsExistingMatchingCard(c249000788.attfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,i)
			then att=att+i
		end
		i=i*2
	end
	local code_table={}
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0xFF,0,nil,TYPE_MONSTER)
	i=1
	local tc=g:GetFirst()
	while tc do
		code_table[i]=tc:GetOriginalCode()
		i=i+1
		code_table[i]=OPCODE_ISCODE
		i=i+1
		code_table[i]=OPCODE_NOT
		i=i+1
		code_table[i]=OPCODE_AND
		i=i+1		
		tc=g:GetNext()
	end
	local sc
	local g
	repeat
		local announce_filter={race,OPCODE_ISRACE,TYPE_MONSTER,OPCODE_ISTYPE,OPCODE_AND,att,OPCODE_ISATTRIBUTE,OPCODE_AND,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND,table.unpack(code_table)}
		local ac=Duel.AnnounceCardFilter(tp,table.unpack(announce_filter))
		sc=Duel.CreateToken(tp,ac)
		g=Duel.GetMatchingGroup(c249000788.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil)
	until (g:CheckWithSumEqual(Card.GetLevel,sc:GetLevel(),1,99,nil) and sc:IsCanBeSpecialSummoned(e,0,tp,false,false))
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,sc:GetLevel(),1,99,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(e)
		e1:SetTarget(c249000788.sumlimit)
		Duel.RegisterEffect(e1,tp)
	end
end
function c249000788.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x30CF)
end
function c249000788.cfilter(c,tp)
	return c:IsSetCard(0x30CF) and c:GetControler()==tp
end
function c249000788.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000788.cfilter,1,nil,tp)
end
function c249000788.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c249000788.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_DECKSHF)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
