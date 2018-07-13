--Shrine Star Kami of Convalescence
function c40933455.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c40933455.sfilter1,2,2,c40933455.lcheck)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40933455,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,40933455)
	e1:SetCondition(c40933455.spcon)
	e1:SetTarget(c40933455.sptg)
	e1:SetOperation(c40933455.spop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40933455,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,40933456)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c40933455.thcon)
	e2:SetTarget(c40933455.thtg)
	e2:SetOperation(c40933455.thop)
	c:RegisterEffect(e2)
end
function c40933455.lcheck(g,lc)
	return g:IsExists(c40933455.sfilter2,1,nil)
end
function c40933455.sfilter1(c)
	return c:IsLinkSetCard(0x1004) and not c:IsCode(40933455)
end
function c40933455.sfilter2(c)
	return (c:IsLinkType(TYPE_RITUAL) or c:GetSummonLocation()==LOCATION_EXTRA) and not c:IsCode(40933455)
end

function c40933455.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40933455.spfilter(c,e,tp,link)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x10000008)==0x10000008 and c:GetReasonCard()==link
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40933455.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c40933455.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c40933455.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40933455.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

function c40933455.thcfilter(c,tp,lg)
	return c:IsControler(tp) and c:IsSetCard(0x1004) and lg:IsContains(c)
end
function c40933455.thcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c40933455.thcfilter,1,nil,tp,lg)
end
function c40933455.thfilter(c,tp)
	return c:IsSetCard(0x1004) and c:IsAbleToHand()
end
function c40933455.thfilter2(c,tp)
	return c:IsSetCard(0x1004) and c:IsAbleToGrave()
end
function c40933455.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40933455.thfilter,tp,LOCATION_DECK,0,1,nil,tp) 
	and Duel.IsExistingMatchingCard(c40933455.thfilter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c40933455.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c40933455.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c40933455.thfilter2,tp,LOCATION_DECK,0,1,1,g1,tp)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end

