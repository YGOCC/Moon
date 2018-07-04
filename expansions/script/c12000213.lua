--Vertina, the Dimension Dragonlord
function c12000213.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c12000213.matfilter,1,1)
	c:EnableReviveLimit()
	--to hand from Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000213,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12000213)
	e1:SetCondition(c12000213.thcon1)
	e1:SetTarget(c12000213.thtg1)
	e1:SetOperation(c12000213.thop1)
	c:RegisterEffect(e1)
	--to hand from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000213,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12000313)
	e2:SetCondition(c12000213.thcon2)
	e2:SetTarget(c12000213.thtg2)
	e2:SetOperation(c12000213.thop2)
	c:RegisterEffect(e2)
end
function c12000213.matfilter(c)
	return c:IsLinkRace(RACE_DRAGON) and not c:IsLinkCode(12000213)
end
function c12000213.cfilter(c,tp)
	return c:IsRace(RACE_DRAGON)
end
function c12000213.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:GetFirst():IsSummonType(SUMMON_TYPE_ADVANCE)
		and eg:IsExists(c12000213.cfilter,1,nil,tp)
end
function c12000213.thfilter1(c)
	return c:IsSetCard(0x855) and c:IsAbleToHand()
end
function c12000213.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000213.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000213.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000213.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12000213.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12000213.thfilter2(c)
	return c:IsSetCard(0xfb0) and c:IsAbleToHand()
end
function c12000213.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000213.thfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12000213.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000213.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end