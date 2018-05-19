--Pandemoniumgraph of Supermacy
function c902763443.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--During your Main Phase: You can add 1 face-up "Pandemoniumgraph" Pandemonium Monster from your Extra Deck to your hand. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,902763443)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetTarget(c902763443.thtg)
	e1:SetOperation(c902763443.thop)
	c:RegisterEffect(e1)
	--If a "Pandemoniumgraph" card in your Pandemonium Zone is destroyed: You can Special Summon 1 Level 4 or lower "Pandemoniumgraph" Pandemonium Monster from your Deck. (HOPT1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,902763443)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c902763443.spcon)
	e2:SetTarget(c902763443.sptg)
	e2:SetOperation(c902763443.spop)
	c:RegisterEffect(e2)
end
function c902763443.thfilter(c)
	return aux.PaCheckFilter(c) and c:IsSetCard(0xcf80) and c:IsAbleToHand()
end
function c902763443.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c902763443.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c902763443.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c902763443.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c902763443.cfilter(c,tp)
	return c:IsSetCard(0xcf80) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsPreviousLocation(LOCATION_SZONE)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c902763443.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c902763443.cfilter,1,nil,tp)
end
function c902763443.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xcf80) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c902763443.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c902763443.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c902763443.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c902763443.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
