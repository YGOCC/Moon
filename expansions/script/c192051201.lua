--coded by Lyris
--Steelus Illarium
function c192051201.initial_effect(c)
	--If this card (and no other cards) is sent from your Deck to the GY by a Spell/Trap: You can Special Summon 1 other Level 3 "Steelus" monster from your GY. You can only use this effect of "Steelus Illarium" once per turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,192051201)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c192051201.spcon)
	e1:SetTarget(c192051201.sptg)
	e1:SetOperation(c192051201.spop)
	c:RegisterEffect(e1)
	--If this card is Special Summoned from the GY: You can send 1 "Steelus" card from your Deck to the GY. This card must remain face-up on the field to activate and to resolve this effect.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCondition(c192051201.tgcon)
	e2:SetTarget(c192051201.tgtg)
	e2:SetOperation(c192051201.tgop)
	c:RegisterEffect(e2)
end
function c192051201.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and re and re:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) and tc==e:GetHandler() and tc:IsPreviousLocation(LOCATION_DECK)
end
function c192051201.spfilter(c,e,tp)
	return c:GetLevel()==3 and c:IsSetCard(0x617) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c192051201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c192051201.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c192051201.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c192051201.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c192051201.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c192051201.filter(c)
	return c:IsSetCard(0x617) and c:IsAbleToGrave()
end
function c192051201.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051201.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c192051201.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c192051201.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
