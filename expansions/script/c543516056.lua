--Fallenblade - Recruit
function c543516056.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(543516056,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,543516056)
	e1:SetTarget(c543516056.sumtg)
	e1:SetOperation(c543516056.sumop)
	c:RegisterEffect(e1)
	--add a fallenblade
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,543516040)
	e2:SetCondition(c543516056.condition)
	e2:SetTarget(c543516056.target)
	e2:SetOperation(c543516056.operation)
	c:RegisterEffect(e2)
	--draw cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(543516056,2))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,543516039)
	e3:SetTarget(c543516056.destg)
	e3:SetOperation(c543516056.desop)
	c:RegisterEffect(e3)
end
function c543516056.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x21f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c543516056.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c543516056.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c543516056.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c543516056.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c543516056.sumop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	end
end
function c543516056.condition(e,tp,eg,ep,ev,re,r,rp)
	return e and (e:GetHandler():IsSetCard(0x21f)) or (e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM)
end
function c543516056.tfilter(c)
	return c:IsSetCard(0x21f) and c:IsAbleToHand()
end
function c543516056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c543516056.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c543516056.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c543516056.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c543516056.thfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x21f)
		and c:IsAbleToRemove() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c543516056.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and 
		Duel.IsExistingMatchingCard(c543516056.thfilter,tp,LOCATION_FZONE+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c543516056.thfilter,tp,LOCATION_FZONE+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c543516056.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c543516056.thfilter,tp,LOCATION_FZONE+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,nil)
	local sg=g:Select(tp,1,2,nil)
	local ct=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
