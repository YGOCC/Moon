--SC2 Custom - Elven Duelist
function c115000273.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c115000273.target)
	e2:SetOperation(c115000273.operation)
	c:RegisterEffect(e2)
end
function c115000273.tfilter(c,race,e,tp,lv,tc)
	return (c:IsSetCard(0x11AB) or c:IsSetCard(0x21AB)) and c:IsRace(race) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
	and (c:GetLevel()==lv+1 or c:GetLevel()==lv+2) and (Duel.GetLocationCountFromEx(tp,tp,tc)>0 or not tc:IsLocation(LOCATION_EXTRA))
end
function c115000273.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel() >= 0 and not c:IsSetCard(0x41AB)
		and Duel.IsExistingMatchingCard(c115000273.tfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,c:GetRace(),e,tp,c:GetLevel(),tc)
end
function c115000273.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c115000273.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c115000273.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c115000273.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function c115000273.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local race=tc:GetRace()
	local lv=tc:GetLevel()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c115000273.tfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,1,nil,race,e,tp,lv)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
	end
end