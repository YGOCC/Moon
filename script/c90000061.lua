--Operation - Ambush
function c90000061.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90000061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c90000061.cost)
	e1:SetTarget(c90000061.target)
	e1:SetOperation(c90000061.operation)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90000061,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c90000061.cost)
	e2:SetTarget(c90000061.target2)
	e2:SetOperation(c90000061.operation2)
	c:RegisterEffect(e2)
end
function c90000061.filter(c)
	return c:IsSetCard(0x1c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c90000061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c90000061.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c90000061.filter0(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c90000061.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank())
end
function c90000061.filter1(c,e,tp,rk)
	return c:GetRank()<rk and c:IsSetCard(0x1c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c90000061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90000061.filter0,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c90000061.filter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90000061.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c90000061.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank())
		local sc=g:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP_DEFENSE)
			sc:CompleteProcedure()
			if c:IsRelateToEffect(e) then
				c:CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(c))
			end
		end
	end
end
function c90000061.filter2(c,e,tp)
	return c:IsLevelAbove(1) and c:IsFaceup() and c:IsSetCard(0x1c)
		and Duel.IsExistingMatchingCard(c90000061.filter3,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel(),e,tp)
end
function c90000061.filter3(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000061.filter4(c)
	return c:IsSetCard(0x1c) and c:IsXyzSummonable(nil)
end
function c90000061.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90000061.filter2,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c90000061.filter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90000061.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c90000061.filter3,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetLevel(),e,tp)
		local sc=g:GetFirst()
		if sc then
			if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)==1
				and Duel.IsExistingMatchingCard(c90000061.filter4,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(90000061,2)) then
				Duel.BreakEffect()
				local g=Duel.GetMatchingGroup(c90000061.filter4,tp,LOCATION_EXTRA,0,nil)
				if g:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tg=g:Select(tp,1,1,nil)
					Duel.XyzSummon(tp,tg:GetFirst(),nil)
				end
			end
		end
	end
end