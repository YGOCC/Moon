--Varia-Force Link Call
function c249000767.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000767.target)
	e1:SetOperation(c249000767.activate)
	c:RegisterEffect(e1)
end
function c249000767.tfilter(c,att,e,tp,lv)
	return c:IsType(TYPE_LINK) and c:IsAttribute(att) and c:GetLink()<=math.ceil(lv/2) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c249000767.filter(c,e,tp)
	return c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c249000767.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp,c:GetOriginalLevel())
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000767.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c249000767.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c249000767.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000767.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetOriginalAttribute()
	local lv=tc:GetOriginalLevel()
	if 	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c249000767.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp,lv)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
