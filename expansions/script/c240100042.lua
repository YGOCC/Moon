--created by NovaTsukimori, coded by Lyris, art from Sailor Moon R Episode 9
--襲雷サンサーラ･ボルト
function c240100042.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c240100042.sptg)
	e2:SetOperation(c240100042.spop)
	c:RegisterEffect(e2)
end
function c240100042.rmfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x7c4)
		and Duel.IsExistingTarget(c240100042.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function c240100042.spfilter(c,e,tp,code)
	return c:IsSetCard(0x7c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function c240100042.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c240100042.rmfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c240100042.rmfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c240100042.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c240100042.spop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex,g2=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local tc1=g1:GetFirst()
	if not tc1:IsRelateToEffect(e) or Duel.Destroy(tc1,POS_FACEUP,REASON_EFFECT)==0 then return end
	local tc2=g2:GetFirst()
	if tc2:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
