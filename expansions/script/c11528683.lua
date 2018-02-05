--Revenge Scarecrow
function c11528683.initial_effect(c)
--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(c11528683.spcon)
	c:RegisterEffect(e1)
--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11528683,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(c11528683.thtg)
	e2:SetOperation(c11528683.thop)
	c:RegisterEffect(e2)
end
function c11528683.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x850)
end
function c11528683.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11528683.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c11528683.thfilter(c)
	return c:IsSetCard(0x850) and not c:IsCode(11528683) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c11528683.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11528683.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11528683.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end