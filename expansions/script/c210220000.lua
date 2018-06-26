--Arachne Black Damager
local card = c210220000
function card.initial_effect(c)
c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(card.spcon)
	e1:SetOperation(card.spop)
	c:RegisterEffect(e1)
		--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
function card.filter(c)
	return c:IsLevelBelow(5) and c:IsAbleToGraveAsCost()
end
function card.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(card.filter,tp,LOCATION_DECK,0,5,c)
end
function card.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,card.filter,tp,LOCATION_DECK,0,5,5,c)
	Duel.SendtoGrave(g,REASON_COST)
end
