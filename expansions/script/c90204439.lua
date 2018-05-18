--Pandemoniumgraph of Destruction
function c90204439.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Your opponent cannot target Pandemonium Monsters you control with Spell effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM end)
	e2:SetValue(c90204439.evalue)
	c:RegisterEffect(e2)
	--If a face-up Pandemonium Monster in your Main Monster Zone or Spell & Trap Zone is destroyed: You can add 1 "Pandemoniumgraph" card from your Deck to your hand, except "Pandemoniumgraph of Destruction". You can only use this effect of "Pandemoniumgraph of Destruction" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,90204439)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetCondition(c90204439.condition)
	e3:SetTarget(c90204439.target)
	e3:SetOperation(c90204439.operation)
	c:RegisterEffect(e3)
end
function c90204439.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and rp~=e:GetHandlerPlayer()
end
function c90204439.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetSequence()<5
end
function c90204439.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c90204439.cfilter,1,nil,tp)
end
function c90204439.filter(c)
	return c:IsSetCard(0xcf80) and c:IsAbleToHand() and not c:IsCode(90204439)
end
function c90204439.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90204439.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90204439.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90204439.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
