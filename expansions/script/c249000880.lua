--Data Creator
xpcall(function() require("expansions/script/bannedlist") end,function() require("script/bannedlist") end)
function c249000880.initial_effect(c)
	c:EnableReviveLimit()
	--special summon other
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000880.condition)
	e1:SetCost(c249000880.cost)
	e1:SetTarget(c249000880.target)
	e1:SetOperation(c249000880.operation)
	c:RegisterEffect(e1)
	--special summon self
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000880.spcon)
	e2:SetOperation(c249000880.spop)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000880.condition2)
	e3:SetCost(c249000880.cost2)
	e3:SetTarget(c249000880.target2)
	e3:SetOperation(c249000880.operation2)
	c:RegisterEffect(e3)
end
function c249000880.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local ct=g:GetClassCount(Card.GetRace)
	return ct > 2
end
function c249000880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000880.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c249000880.spfilter,tp,LOCATION_GRAVELOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000880.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c249000880.releasefilter(c)
	return (c:IsLevelAbove(1) or c:GetRank() > 0) and c:IsReleasable()
end
function c249000880.getlevelorrank(c)
	if c:GetLevel() > c:GetRank() then return c:GetLevel() else return c:GetRank() end
end
function c249000880.racefilter(c,race)
	return c:IsRace(race) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000880.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local race=0
	local i=1
	while i < 0x1000000 do
		if Duel.IsExistingMatchingCard(c249000880.racefilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,i)
			then race=race+i
		end
	i=i*2
	end
	local ac
	local sc
	local g
	local sumtype
	local lvrk
	repeat
		ac=Duel.AnnounceCardFilter(tp,race,OPCODE_ISRACE,TYPE_SYNCHRO+TYPE_XYZ+TYPE_RITUAL,OPCODE_ISTYPE,OPCODE_AND)
		sc=Duel.CreateToken(tp,ac)
		g=Duel.GetMatchingGroup(c249000880.releasefilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
		if sc:IsType(TYPE_RITUAL) then sumtype=SUMMON_TYPE_RITUAL elseif sc:IsType(TYPE_SYNCHRO) then sumtype=SUMMON_TYPE_SYNCHRO else sumtype=SUMMON_TYPE_XYZ end
		if sc:IsType(TYPE_XYZ) then lvrk=sc:GetRank() else lvrk=sc:GetLevel() end
	until g:CheckWithSumGreater(c249000880.getlevelorrank,lvrk,1,99,e:GetHandler()) and lvrk >=4 and lvrk <=9
		and sc:IsCanBeSpecialSummoned(e,sumtype,tp,true,false) and not banned_list_table[ac]
	local sg=g:SelectWithSumGreater(tp,c249000880.getlevelorrank,lvrk,1,99,nil)
	Duel.Release(sg,REASON_EFFECT)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	Duel.SpecialSummon(sc,sumtype,tp,tp,true,false,POS_FACEUP)
	sc:CompleteProcedure()
	local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if tc2 and sc:IsType(TYPE_XYZ) then
		Duel.Overlay(sc,tc2)
	end
	tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if tc2 and sc:IsType(TYPE_XYZ) then
		Duel.Overlay(sc,tc2)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c249000880.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000880.damval(e,re,val,r,rp,rc)
	return val/2
end
function c249000880.spfilter(c)
	return c:IsSetCard(0x1FA) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000880.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000880.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,2,nil)
end
function c249000880.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000880.spfilter,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000880.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and not Duel.CheckPhaseActivity()
		and Duel.IsExistingMatchingCard(c249000880.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000880.costfilter(c)
	return c:IsSetCard(0x1FA) and c:IsDiscardable()
end
function c249000880.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000880.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000880.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c249000880.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000880.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
