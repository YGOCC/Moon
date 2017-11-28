--Royal Raid Aircraft
function c90000042.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90000042)
	e1:SetTarget(c90000042.target1)
	e1:SetOperation(c90000042.operation1)
	c:RegisterEffect(e1)
	--Attach
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c90000042.condition2)
	e2:SetTarget(c90000042.target2)
	e2:SetOperation(c90000042.operation2)
	c:RegisterEffect(e2)
end
function c90000042.filter1(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000042.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000042.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c90000042.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000042.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c90000042.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c90000042.filter2_1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c90000042.filter2_2(c)
	return c:IsRace(RACE_MACHINE) and not c:IsCode(90000042)
end
function c90000042.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000042.filter2_1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c90000042.filter2_2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c90000042.filter2_1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90000042.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c90000042.filter2_2,tp,LOCATION_GRAVE,0,1,1,nil)
		local sc=g:GetFirst()
		if sc then
			Duel.Overlay(tc,Group.FromCards(sc))
		end
	end
end