--Untergang
function c400017.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x246))
	e2:SetValue(c400017.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88264978,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,400017+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c400017.sptg)
	e4:SetOperation(c400017.spop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(400001,0))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,1400017+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(c400017.condition)
	e5:SetTarget(c400017.target)
	e5:SetOperation(c400017.operation)
	c:RegisterEffect(e5)
end
function c400017.atk(c)
	return c:IsSetCard(0x246) and c:IsType(TYPE_QUICKPLAY)
end
function c400017.val(e,c)
	return Duel.GetMatchingGroupCount(c400017.atk,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*100
end
function c400017.filter(c,e,tp)
	return c:IsSetCard(0x246) and (c:GetLevel()<=4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c400017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(function(c)return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x246) end,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c400017.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c400017.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c400017.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c400017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and re:GetHandler():IsType(TYPE_QUICKPLAY) and re:GetHandler():IsSetCard(0x146) and rp==tp
end
function c400017.filter1(c)
	return c:IsSetCard(0x246) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c400017.filter2,c:GetControler(),LOCATION_DECK,0,1,c,c:GetCode())
end
function c400017.filter2(c,code)
	return c:IsSetCard(0x246) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
		and not c:IsCode(code)
end
function c400017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c400017.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c400017.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c400017.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g0=Duel.SelectMatchingCard(tp,c400017.filter2,tp,LOCATION_DECK,0,1,1,g:GetFirst(),g:GetFirst():GetCode())
			Duel.SendtoHand(g0,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g0)
		end
	end
end
