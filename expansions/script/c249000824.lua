--Cyber-Realm Mage
xpcall(function() require("expansions/script/bannedlist") end,function() require("script/bannedlist") end)
function c249000824.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c249000824.sptg)
	e1:SetOperation(c249000824.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c249000824.cost)
	e2:SetOperation(c249000824.operation)
	c:RegisterEffect(e2)
end
function c249000824.filter(c,e,tp)
	return c:IsSetCard(0x1F4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000824.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000824.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c249000824.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c249000824.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000824.costfilter(c)
	return c:IsSetCard(0x1F4) and c:IsAbleToRemoveAsCost()
end
function c249000824.costfilter2(c)
	return c:IsSetCard(0x1F4) and not c:IsPublic()
end
function c249000824.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000824.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000824.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	if Duel.GetLP(tp) < 2000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1000)
	end
	local option
	if Duel.IsExistingMatchingCard(c249000824.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000824.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000824.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000824.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000824.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000824.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000824.codefilter(c)
	return c:IsType(TYPE_LINK) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000824.rmfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000824.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code_table={}
	local g=Duel.GetMatchingGroup(c249000824.codefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
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
		while banned_list_table[ac] do
			ac=Duel.AnnounceCardFilter(tp,table.unpack(announce_filter))
		end
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
	if Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c249000824.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,sc:GetLink())
		and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.SelectYesNo(tp,2) then
		local g2=Duel.SelectMatchingCard(tp,c249000824.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,sc:GetLink())
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:SetMaterial(g2)
	end
end