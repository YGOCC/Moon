--Headhunter Rengar
function c11000333.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c11000333.spcon)
	e1:SetTarget(c11000333.sptg)
	e1:SetOperation(c11000333.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000333,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,11000333)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11000333.condition)
	e2:SetTarget(c11000333.target)
	e2:SetOperation(c11000333.operation)
	c:RegisterEffect(e2)
end
function c11000333.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c11000333.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11000333.cfilter,1,nil,1-tp)
end
function c11000333.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11000333.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11000333.cofilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1FF) and c:IsType(TYPE_MONSTER)
end
function c11000333.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11000333.cofilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c11000333.filter(c)
	return c:IsCode(11000338) and c:IsAbleToHand()
end
function c11000333.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000333.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11000333.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstMatchingCard(c11000333.filter,tp,LOCATION_DECK,0,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end