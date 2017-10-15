--Hadraniel, of Virtue
function c9945355.initial_effect(c)
	--ToDeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9945355,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9945355)
	e1:SetTarget(c9945355.sptg)
	e1:SetOperation(c9945355.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ToGrave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9945355,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,9945355)
	e4:SetTarget(c9945355.thtg)
	e4:SetOperation(c9945355.thop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c9945355.spfilter(c,e,tp)
	return c:IsSetCard(0x204F) and not c:IsCode(9945355) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945355.cfilter(c)
	return c:IsFaceup() and c:IsCode(9945225)
end
function c9945355.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c9945355.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9945355.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9945355.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9945355.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and fc and c9945355.cfilter(fc)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9945355,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9945355.thfilter(c)
	return c:IsSetCard(0x204F) and not c:IsCode(9945225) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9945355.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945355.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9945355.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945355.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and fc and c9945355.cfilter(fc)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9945355,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end