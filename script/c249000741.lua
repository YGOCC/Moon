--Oracle Tuning
function c249000741.initial_effect(c)
	--Synchro monster, 1 tuner + n or more monsters
	function aux.AddSynchroProcedure(c,f1,f2,ct)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f1 then
			mt.tuner_filter=function(mc) return mc and f1(mc) end
		else
			mt.tuner_filter=function(mc) return true end
		end
		if f2 then
			mt.nontuner_filter=function(mc) return mc and f2(mc) end
		else
			mt.nontuner_filter=function(mc) return true end
		end
		mt.minntct=ct
		mt.maxntct=99
		mt.sync=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
		e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
		e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000741.condition)
	e1:SetTarget(c249000741.target)
	e1:SetOperation(c249000741.activate)
	c:RegisterEffect(e1)
end
function c249000741.confilter(c)
	return c:IsSetCard(0x1ED) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c249000741.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000740.confilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000741.filter1(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c249000741.filter2(c,e,tp)
	return c:IsNotTuner() and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function c249000741.synfilter(c,mg)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	return mt.minntct==1 and c:IsSynchroSummonable(nil,mg)
end
function c249000741.mfilter1(c,mg2)
	return mg2:IsExists(c249000741.mfilter2,1,nil,c)
end
function c249000741.mfilter2(c,t)
	local g=Group.FromCards(c)
	g:AddCard(t)
	return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,g)
end
function c249000741.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg1=Duel.GetMatchingGroup(c249000741.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	local mg2=Duel.GetMatchingGroup(c249000741.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
	local mg3=Duel.GetMatchingGroup(c249000741.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
	mg3:Merge(mg2)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c249000741.synfilter,tp,LOCATION_EXTRA,0,1,nil,mg3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg1:FilterSelect(tp,c249000741.mfilter1,1,1,nil,mg2)
	local tc1=sg1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg2:FilterSelect(tp,c249000741.mfilter2,1,1,tc1,tc1)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,2,0,0)
end
function c249000741.filter3(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000741.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c249000741.filter3,nil,e,tp)
	if g:GetCount()<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	if Duel.GetLocationCountFromEx(tp,tp,g)<=0 then return end
	Duel.BreakEffect()
	local syng=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,g)
	if syng:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sync=syng:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sync:GetFirst(),nil,g)
	end
end
