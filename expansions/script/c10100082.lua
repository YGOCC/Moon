--Belnur, Adept der magischen Waffen
function c10100082.initial_effect(c)
--gain effect: extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10100082,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,10100082)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10100082.eqcon2)
	e3:SetTarget(c10100082.htarget)
	e3:SetOperation(c10100082.hoperation)
	c:RegisterEffect(e3)
	--gain effect: special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100082,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,10100182)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10100082.eqcon)
	e4:SetTarget(c10100082.target)
	e4:SetOperation(c10100082.operation)
	c:RegisterEffect(e4)
	--gain effect: bounce
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10100082,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10100282)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCondition(c10100082.eqcon3)
	e5:SetTarget(c10100082.btarget)
	e5:SetOperation(c10100082.activate)
	c:RegisterEffect(e5)
	--gain effect: search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(10100082,3))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,10100382)
	e6:SetCondition(c10100082.eqcon4)
	e6:SetTarget(c10100082.starget)
	e6:SetOperation(c10100082.soperation)
	c:RegisterEffect(e6)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(10100082,4))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,10100482)
	e7:SetCondition(c10100082.eqcon5)
	e7:SetTarget(c10100082.xtarget)
	e7:SetOperation(c10100082.xactivate)
	c:RegisterEffect(e7)
end
function c10100082.hfilter(c,e,tp)
	return c:IsSetCard(0x326) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100082.htarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100082.hfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10100082.hoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100082.hfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100082.eqcon2(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,10100084)
end
function c10100082.sfilter(c,e,tp)
	return c:IsSetCard(0x326) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10100082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10100082.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c10100082.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10100082.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10100082.eqcon(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,10100085)
end
function c10100082.bfilter(c,e,tp)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c10100082.btarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(c10100082.bfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10100082.bfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10100082.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c10100082.eqcon3(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,10100086)
end
function c10100082.ssfilter(c)
	return c:IsSetCard(0x326) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c10100082.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100082.ssfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10100082.soperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10100082.ssfilter),tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end
function c10100082.eqcon4(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,10100087)
end
function c10100082.xfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x326) and c:IsType(TYPE_EQUIP) and c:IsAbleToGrave()
end
function c10100082.xtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100082.xfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10100082.xactivate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10100082.xfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10100082.eqcon5(e)
	local eg=e:GetHandler():GetEquipGroup()
	return eg and eg:IsExists(Card.IsCode,1,nil,10100119)
end