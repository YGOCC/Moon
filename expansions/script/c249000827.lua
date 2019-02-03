--Cyber-Realm Gatekeeper
function c249000827.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,249000827)
	e1:SetTarget(c249000827.target)
	e1:SetOperation(c249000827.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3))
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c249000827.cost)
	e4:SetOperation(c249000827.operation2)
	c:RegisterEffect(e4)
end
function c249000827.filter(c)
	return c:IsSetCard(0x1F4) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and not c:IsCode(249000827)
end
function c249000827.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000827.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000827.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000827.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
endfunction c249000827.costfilter(c)
	return c:IsSetCard(0x1F4) and c:IsAbleToRemoveAsCost()
end
function c249000827.costfilter2(c)
	return c:IsSetCard(0x1F4) and not c:IsPublic()
end
function c249000827.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000827.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000827.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	if Duel.GetLP(tp) < 2000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1000)
	end
	local option
	if Duel.IsExistingMatchingCard(c249000827.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000827.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000827.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000827.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000827.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000827.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000827.codefilter(c)
	return c:IsType(TYPE_LINK) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000827.rmfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000827.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code_table={}
	local g=Duel.GetMatchingGroup(c249000827.codefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local i=1
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
	local link_table={}
	for i2=1,4 do
		local announce_filter={TYPE_LINK,OPCODE_ISTYPE,OPCODE_AND,table.unpack(code_table)}
		local ac=Duel.AnnounceCardFilter(tp,table.unpack(announce_filter))
		link_table[i2]=ac
		code_table[i]=ac
		i=i+1
		code_table[i]=OPCODE_ISCODE
		i=i+1
		code_table[i]=OPCODE_NOT
		i=i+1
		code_table[i]=OPCODE_AND
		i=i+1	
	end
	local sc=Duel.CreateToken(tp,link_table[math.random(1, 4)])
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.Hint(HINT_CARD,0,sc:GetOriginalCodeRule())
	Duel.ConfirmCards(1-tp,g)
	if Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c249000827.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,sc:GetLink())
		and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.SelectYesNo(tp,2) then
		local g2=Duel.SelectMatchingCard(tp,c249000827.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,sc:GetLink())
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:SetMaterial(g2)
	end
end