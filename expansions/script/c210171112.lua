--Nekroz of Dewloren
function c210171112.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,210171112)
	e2:SetCost(c210171112.thcost)
	e2:SetTarget(c210171112.thtg)
	e2:SetOperation(c210171112.thop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,210171152)
	e3:SetTarget(c210171112.atktg)
	e3:SetOperation(c210171112.atkop)
	c:RegisterEffect(e3)
end
function c210171112.mat_filter(c)
	return not c:IsCode(210171112)
end
function c210171112.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c210171112.thfilter(c)
	return c:IsSetCard(0xb4) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c210171112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210171112.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210171112.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c210171112.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c210171112.atkfilter(c)
	return c:GetSequence()>4
end
function c210171112.atkfilter2(c)
	return c:IsLocation(LOCATION_ONFIELD) or (c:IsSetCard(0xb4) and c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function c210171112.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c210171112.atkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c210171112.atkfilter2(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c210171112.atkfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c210171112.atkfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,ct,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c210171112.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end