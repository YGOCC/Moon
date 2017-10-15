--Super Synchronization
function c90000034.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c90000034.condition)
	e1:SetCost(c90000034.cost)
	e1:SetOperation(c90000034.operation)
	c:RegisterEffect(e1)
end
function c90000034.filter1(c,e,tp)
	return c:IsSetCard(0x14) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c90000034.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,c:GetLevel())
end
function c90000034.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c90000034.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave() and rlv>0
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end
function c90000034.filter3(c)
	return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c90000034.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90000034.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c90000034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c90000034.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c90000034.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c90000034.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c90000034.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c90000034.filter3,tp,LOCATION_MZONE,LOCATION_MZONE,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		g2:Merge(g3)
		Duel.SendtoGrave(g2,REASON_EFFECT)
		Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g1:GetFirst():CompleteProcedure()
	end
end