local m=110600011
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsSetCard(0x303) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) 
	and c:IsLocation(LOCATION_PZONE) or c:IsLocation(LOCATION_HAND)
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(cm.mfilter,tp,0,LOCATION_MZONE,nil)
		local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,0,LOCATION_MZONE,nil)
		return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,0xff,0,1,nil,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0xff)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(cm.mfilter,tp,0,LOCATION_MZONE,nil)
	local mg2=Duel.GetMatchingGroup(cm.mfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.RitualUltimateFilter,tp,0xff,0,1,1,nil,cm.filter,e,tp,mg2,mg1,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,gc)
	if (bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp)) 
	or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) and not c:IsLocation(LOCATION_PZONE) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	if gc then
		if not mg:IsContains(gc) then return false end
		Duel.SetSelectedCard(gc)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end