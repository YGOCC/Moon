--Cyber-Realm Data Path
function c249000830.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000830.target)
	e1:SetOperation(c249000830.activate)
	c:RegisterEffect(e1)
	--special summon 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c249000830.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c249000830.activate)
	c:RegisterEffect(e2)
end
function c249000830.filter(c)
	return c:IsSetCard(0x1F4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c249000830.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000830.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000830.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000830.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000830.spconfilter(c)
	return c:IsSetCard(0x1F4) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000830.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000830.spconfilter,tp,LOCATION_GRAVE_LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and ct>2
end
function c249000830.codefilter(c)
	return c:IsType(TYPE_LINK) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000830.rmfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000830.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code_table={}
	local g=Duel.GetMatchingGroup(c249000788.codefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
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
	if Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c249000824.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,sc:GetLink()+2)
		and Duel.SelectYesNo(tp,2) then
		local g2=Duel.SelectMatchingCard(tp,c249000824.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,sc:GetLink()+2)
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		sc:SetMaterial(g2)
	end
end