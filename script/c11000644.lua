--Ancient Key
function c11000644.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11000644,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c11000644.condition)
	e1:SetCost(c11000644.spcost)
	e1:SetTarget(c11000644.sptg)
	e1:SetOperation(c11000644.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000644,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c11000644.thcost)
	e2:SetTarget(c11000644.thtg)
	e2:SetOperation(c11000644.thop)
	c:RegisterEffect(e2)
end
function c11000644.cfilter1(c)
	return c:IsFaceup() and c:IsCode(11000642)
end
function c11000644.cfilter2(c)
	return c:IsFaceup() and c:IsCode(11000640)
end
function c11000644.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11000644.cfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and (Duel.IsExistingMatchingCard(c11000644.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
		or Duel.IsEnvironment(11000640))
end
function c11000644.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,2,nil,0x209) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,2,2,nil,0x209)
	Duel.Release(g,REASON_COST)
end
function c11000644.spfilter(c,e,tp)
	return c:IsCode(11000641) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11000644.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11000644.spfilter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c11000644.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11000644.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		Duel.ShuffleDeck(tp)
	end
end
function c11000644.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c11000644.thfilter(c)
	return c:IsSetCard(0x209) and c:IsAbleToHand()
end
function c11000644.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000644.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c11000644.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11000644.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end