--Deepwood Awakening Ritual
local voc=c1909
function c1909.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCost(voc.spcost)
	e1:SetTarget(voc.sptg)
	e1:SetOperation(voc.spop)
	c:RegisterEffect(e1)
end
function voc.spcfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function voc.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(voc.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,1900)
		and Duel.IsExistingMatchingCard(voc.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,1906)
		and Duel.IsExistingMatchingCard(voc.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,1907)
		and Duel.IsExistingMatchingCard(voc.spcfilter,tp,LOCATION_ONFIELD,0,1,nil,1905) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,voc.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,1905)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,voc.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,1907)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,voc.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,1906)
	g1:Merge(g3)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g4=Duel.SelectMatchingCard(tp,voc.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,1900)
	g1:Merge(g4)
	g1:AddCard(e:GetHandler())
	Duel.SendtoGrave(g1,REASON_COST)
end
function voc.spfilter(c,e,tp)
	return c:IsCode(1910) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function voc.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(voc.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0x13)
end
function voc.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,voc.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
