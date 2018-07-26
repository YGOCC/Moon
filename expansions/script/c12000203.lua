--Dimension Dragon Mekanical Cannoneer
function c12000203.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000203,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000203)
	e1:SetCondition(c12000203.sumcon1)
	e1:SetCost(c12000203.sumcost)
	e1:SetTarget(c12000203.sumtg)
	e1:SetOperation(c12000203.sumop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000203,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12000303)
	e2:SetCondition(c12000203.thcon1)
	e2:SetTarget(c12000203.thtg1)
	e2:SetOperation(c12000203.thop1)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000203,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,12000403)
	e3:SetCondition(c12000203.thcon2)
	e3:SetTarget(c12000203.thtg2)
	e3:SetOperation(c12000203.thop2)
	c:RegisterEffect(e3)
	--summon (quick)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12000203,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,12000203)
	e4:SetCondition(c12000203.sumcon2)
	e4:SetCost(c12000203.sumcost)
	e4:SetTarget(c12000203.sumtg)
	e4:SetOperation(c12000203.sumop)
	c:RegisterEffect(e4)
end
function c12000203.cfilter1(c)
	return c:IsFaceup() and c:IsCode(12000203)
end
function c12000203.cfilter2(c)
	return c:IsFaceup() and c:IsCode(12000210)
end
function c12000203.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000203.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c12000203.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000203.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000203.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c12000203.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000203.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c12000203.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000204,0,0x4011,1000,1000,1,RACE_DRAGON,ATTRIBUTE_LIGHT) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsSummonable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c12000203.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token=Duel.CreateToken(tp,12000204)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.Summon(tp,c,true,nil,1)
end
function c12000203.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c12000203.thfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x855) and not c:IsCode(12000203)
		and c:IsAbleToHand()
end
function c12000203.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000203.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12000203.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000203.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12000203.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12000203.thfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x855) and c:IsAbleToHand()
end
function c12000203.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000203.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000203.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000203.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end