--Teutonic Knight - Grand Aquaslasher
function c12000132.initial_effect(c)
--Link Summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x857),2,2)
	c:EnableReviveLimit()
--Search
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000132,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,12000132)
	e1:SetCondition(c12000132.thcon)
	e1:SetTarget(c12000132.thtg)
	e1:SetOperation(c12000132.thop)
	c:RegisterEffect(e1)
--Set S/T From GY
local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(12000132,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12000232)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c12000132.setcon)
	e2:SetTarget(c12000132.settg)
	e2:SetOperation(c12000132.setop)
	c:RegisterEffect(e2)
	end
--Search
	function c12000132.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12000132.thfilter(c)
	return c:IsSetCard(0x857) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12000132.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000132.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000132.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000132.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--Set S/T From GY
function c12000132.setcfilter(c,tp,lg)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x857) and lg:IsContains(c)
end
function c12000132.setcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c12000132.setcfilter,1,nil,tp,lg)
end
function c12000132.setfilter(c)
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x858)) and c:IsSSetable()
end
function c12000132.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12000132.setfilter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c12000132.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c12000132.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end