--coded by Lyris
--Steelus Silvarium
function c192051202.initial_effect(c)
	--You can discard this card; add 1 "Steelus" Field Spell from your Deck to your hand. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,192051202)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCost(c192051202.cost)
	e1:SetTarget(c192051202.target)
	e1:SetOperation(c192051202.operation)
	c:RegisterEffect(e1)
	--If this card is Special Summoned from the GY: You can Set 1 "Steelus" Spell/Trap from your Deck. This card must remain face-up on the field to activate and to resolve this effect. (HOPT2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,192051203)
	e2:SetCondition(c192051202.tgcon)
	e2:SetTarget(c192051202.tgtg)
	e2:SetOperation(c192051202.tgop)
	c:RegisterEffect(e2)
end
function c192051202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c192051202.thfilter(c)
	return c:IsSetCard(0x617) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c192051202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c192051202.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c192051202.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c192051202.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c192051202.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c192051202.filter(c)
	return c:IsSetCard(0x617) and c:IsSSetable()
end
function c192051202.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c192051202.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c192051202.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c192051202.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
