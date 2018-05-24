--Mysterious Servant Dragon
function c53313904.initial_effect(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53313904,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,53313904)
	e1:SetTarget(c53313904.natg)
	e1:SetOperation(c53313904.naop)
	c:RegisterEffect(e1)
	
end
function c53313904.spfilter(c,e,tp)
	return c:IsCode(53313901) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c53313904.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c53313904.naop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c53313904.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
