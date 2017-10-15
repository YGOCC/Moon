--A New Adventure Begins
function c82896058.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82896058+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c82896058.condition)
	e1:SetCost(c82896058.cost)
	e1:SetTarget(c82896058.target)
	e1:SetOperation(c82896058.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(82896058,ACTIVITY_SPSUMMON,c82896058.counterfilter)
end
function c82896058.counterfilter(c)
	return c:IsSetCard(0x41)
end
function c82896058.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c82896058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(82896058,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetTarget(c82896058.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c82896058.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x41)
end
function c82896058.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x41) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82896058.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82896058.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function c82896058.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82896058.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
