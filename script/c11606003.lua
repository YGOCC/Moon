--Call of the Aesir Lords
function c11606003.initial_effect(c)
	--Special Summon - Thor
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(11606003,0))
	e1:SetCondition(c11606003.condition)
	e1:SetTarget(c11606003.target)
	e1:SetOperation(c11606003.operation)
	c:RegisterEffect(e1)
	--Special Summon - Loki
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(11606003,1))
	e2:SetCondition(c11606003.condition)
	e2:SetTarget(c11606003.select)
	e2:SetOperation(c11606003.activate)
	c:RegisterEffect(e2)
end
function c11606003.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c11606003.sfilter(c,e,tp)
	return c:GetCode()==30604579 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11606003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11606003.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11606003.sfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11606003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetFirstMatchingCard(c11606003.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if c:IsRelateToEffect(e)  
	and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
	end
end
function c11606003.lfilter(c,e,tp)
	return c:GetCode()==67098114 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11606003.select(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c11606003.filter2(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c11606003.lfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c11606003.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.GetFirstMatchingCard(c11606003.lfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if c:IsRelateToEffect(e)  
	and Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
	end
end