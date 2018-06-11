--[]
--[]
function c44804570.initial_effect(c)
	--Spirit Return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44804570,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
--	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)--(moved to Quick Effect)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,44804570)
	e2:SetCondition(c44804570.thcon1)
	e2:SetCost(c44804570.thcost)
	e2:SetTarget(c44804570.thtg)
	e2:SetOperation(c44804570.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c44804570.thcon2)
	c:RegisterEffect(e3)
	--Reduce Damage (should be e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetOperation(c44804570.rdop)
	c:RegisterEffect(e4)
end
function c44804570.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x125)
end
function c44804570.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c44804570.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c44804570.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44804570.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c44804570.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c44804570.thfilter(c)
	return c:IsSetCard(0x125) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsAbleToHand() or c:IsSSetable())
end
function c44804570.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44804570.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44804570.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44804570,2))
	local g=Duel.SelectMatchingCard(tp,c44804570.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsSSetable()
		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(44804570,1))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
function c44804570.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
