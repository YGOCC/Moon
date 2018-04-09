--Dream-Summoner Angelic Maiden
function c249000808.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000808.condition)
	e1:SetCost(c249000808.cost)
	e1:SetOperation(c249000808.operation)
	c:RegisterEffect(e1)
end
function c249000808.confilter(c)
	return c:IsSetCard(0x1F2) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000808.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000808.confilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function c249000808.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c249000808.rmfilter(c)
	return (c:IsLevelAbove(1) or c:GetRank() > 0) and c:IsAbleToRemove()
end
function c249000808.getlevelorrank(c)
	if c:GetLevel() > c:GetRank() then return c:GetLevel() else return c:GetRank() end
end
function c249000808.ctfilter(c)
	return c:IsSetCard(0x1F2) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000808.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCardFilter(tp,TYPE_XYZ,OPCODE_ISTYPE,TYPE_SYNCHRO,OPCODE_ISTYPE,OPCODE_OR)
	local sc=Duel.CreateToken(tp,ac)
	Duel.SendtoDeck(sc,nil,2,REASON_RULE)
	local g=Duel.GetMatchingGroup(c249000808.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local sumtype
	if sc:IsType(TYPE_FUSION) then sumtype=SUMMON_TYPE_FUSION elseif sc:IsType(TYPE_SYNCHRO) then sumtype=SUMMON_TYPE_SYNCHRO else sumtype=SUMMON_TYPE_XYZ end
	local lvrk
	if sc:IsType(TYPE_XYZ) then lvrk=sc:GetRank() else lvrk=sc:GetLevel() end
	if g:CheckWithSumGreater(c249000808.getlevelorrank,lvrk*2,1,99,e:GetHandler()) and lvrk >=4 and lvrk <=9
		and sc:IsCanBeSpecialSummoned(e,sumtype,tp,false,false) and Duel.GetLocationCountFromEx(tp)>0 and Duel.SelectYesNo(tp,2) then
		local sg=g:SelectWithSumGreater(tp,c249000808.getlevelorrank,math.ceil(lvrk*1.5),1,99,e:GetHandler())
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(sc,sumtype,tp,tp,false,false,POS_FACEUP)
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 and sc:IsType(TYPE_XYZ) then
			Duel.Overlay(sc,tc2)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetValue(c249000808.damval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local g2=Duel.GetMatchingGroup(c249000808.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local ct=g2:GetClassCount(Card.GetCode)
		if ct<3 then Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_EFFECT+REASON_DISCARD) end
	end
end
function c249000808.damval(e,re,val,r,rp,rc)
	return val/2
end