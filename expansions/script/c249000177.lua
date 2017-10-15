--高等紋章術
function c249000177.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000177.condition)
	e1:SetTarget(c249000177.target)
	e1:SetOperation(c249000177.activate)
	c:RegisterEffect(e1)
end
function c249000177.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x163)
end
function c249000177.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000177.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000177.filter(c,e)
	return c:IsCanBeEffectTarget(e) and (c:GetLevel()==4 or c:GetLevel()==6)
end
function c249000177.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,2,2)
end
function c249000177.mfilter1(c,mg,exg)
	return mg:IsExists(c249000177.mfilter2,1,c,c,exg)
end
function c249000177.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c249000177.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c249000177.filter,tp,LOCATION_GRAVE,0,nil,e)
	local exg=Duel.GetMatchingGroup(c249000177.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCountFromEx(tp)>0
		and mg:IsExists(c249000177.mfilter1,1,nil,mg,exg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c249000177.mfilter1,1,1,nil,mg,exg)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c249000177.mfilter2,1,1,tc1,tc1,exg)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
end
function c249000177.filter2(c,e)
	return c:IsRelateToEffect(e)
end
function c249000177.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c249000177.filter2,nil,e)
	if g:GetCount()<2 then return end
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
	local xyzg=Duel.GetMatchingGroup(c249000177.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
