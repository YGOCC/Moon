--Cyber-Realm Angel
function c249000825.initial_effect(c)
	--summon & set with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(249000825,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c249000825.ntcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c249000825.cost)
	e3:SetOperation(c249000825.operation)
	c:RegisterEffect(e3)
	math.randomseed( os.time() )
end
function c249000825.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0) < Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)
end
function c249000825.costfilter(c)
	return c:IsSetCard(0x1F4) and c:IsAbleToRemoveAsCost()
end
function c249000825.costfilter2(c)
	return c:IsSetCard(0x1F4) and not c:IsPublic()
end
function c249000825.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000825.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000825.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	if Duel.GetLP(tp) < 4000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,2000)
	end
	local option
	if Duel.IsExistingMatchingCard(c249000825.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000825.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000825.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000825.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000825.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000825.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000825.codefilter(c)
	return c:IsType(TYPE_LINK) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000825.rmfilter(c,lv)
	return c:IsLevelAbove(lv) and c:IsAbleToRemove() and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000825.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code_table={}
	local g=Duel.GetMatchingGroup(c249000825.codefilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
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
	if Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(c249000825.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,nil,sc:GetLink())
		and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.SelectYesNo(tp,2) then
		local g2=Duel.SelectMatchingCard(tp,c249000825.rmfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,sc:GetLink())
		Duel.Remove(g2,POS_FACEUP,REASON_COST)
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
		sc:SetMaterial(g2)
	end
end