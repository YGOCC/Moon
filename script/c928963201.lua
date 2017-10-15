--Transfigurer, Frost
function c928963201.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23571046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,928963201+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c928963201.spcon)
	e1:SetTarget(c928963201.sptg)
	e1:SetOperation(c928963201.spop)
	c:RegisterEffect(e1)
	--summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(952312343,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c928963201.thcon)
	e5:SetTarget(c928963201.thtg)
	e5:SetOperation(c928963201.thop)
	c:RegisterEffect(e5)
end
function c928963201.cfilter(c)
	return c:IsFaceup() and c:IsType(0x10000000)
end
function c928963201.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c928963201.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c928963201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c928963201.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c928963201.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c928963201.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonCard():IsSetCard(0xfe9) and c:IsReason(0x100000000)
end
function c928963201.thfilter(c)
	return c:IsSetCard(0xfe9) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c928963201.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c928963201.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c928963201.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
