--Iceborn Archer, Ashe
function c11000376.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11000376,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c11000376.sumtg)
	e1:SetOperation(c11000376.sumop)
	c:RegisterEffect(e1)
end
function c11000376.filter(c,e,tp)
	return c:GetLevel()<=4 and c:IsSetCard(0x203) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11000376.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11000376.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetChainLimit(c11000376.chainlimit)
end
function c11000376.chainlimit(e,lp,tp)
	return not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():IsType(TYPE_TRAP))
end
function c11000376.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11000376.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
