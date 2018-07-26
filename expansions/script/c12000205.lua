--Dimension Dragon Time Binder
function c12000205.initial_effect(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12000205,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000205)
	e1:SetCondition(c12000205.sumcon1)
	e1:SetCost(c12000205.sumcost)
	e1:SetTarget(c12000205.sumtg)
	e1:SetOperation(c12000205.sumop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000205,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12000305)
	e2:SetCondition(c12000205.thcon)
	e2:SetTarget(c12000205.thtg)
	e2:SetOperation(c12000205.thop)
	c:RegisterEffect(e2)
	--special tokens
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000205,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,12000405)
	e3:SetCondition(c12000205.spcon)
	e3:SetTarget(c12000205.sptg)
	e3:SetOperation(c12000205.spop)
	c:RegisterEffect(e3)
	--summon (quick)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12000205,0))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,12000205)
	e4:SetCondition(c12000205.sumcon2)
	e4:SetCost(c12000205.sumcost)
	e4:SetTarget(c12000205.sumtg)
	e4:SetOperation(c12000205.sumop)
	c:RegisterEffect(e4)
end
function c12000205.cfilter1(c)
	return c:IsFaceup() and c:IsCode(12000205)
end
function c12000205.cfilter2(c)
	return c:IsFaceup() and c:IsCode(12000210)
end
function c12000205.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000205.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and not Duel.IsExistingMatchingCard(c12000205.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000205.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c12000205.cfilter1,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c12000205.cfilter2,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000205.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c12000205.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000206,0,0x4011,500,500,1,RACE_DRAGON,ATTRIBUTE_EARTH) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsSummonable(true,nil,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c12000205.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local token=Duel.CreateToken(tp,12000206)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.Summon(tp,c,true,nil,1)
end
function c12000205.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c12000205.thfilter(c,tp)
	return c:IsSetCard(0x855) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and (c:IsAbleToHand() or c:IsSSetable())
end
function c12000205.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000205.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12000205.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12000205,1))
	local g=Duel.SelectMatchingCard(tp,c12000205.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsSSetable()
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(12000205,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c12000205.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12000205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000206,0,0x4011,500,500,1,RACE_DRAGON,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c12000205.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12000206,0,0x4011,500,500,1,RACE_DRAGON,ATTRIBUTE_EARTH) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,12000206)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
end
