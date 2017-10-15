--Leifa, Valerion's Skydian
function c11111014.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c11111014.mfilter,2,2)
	--If this card is Link Summoned or banished (Quick Effect): You can banish 1 LIGHT, DARK or EARTH Warrior monster from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11111014)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetTarget(c11111014.target)
	e1:SetOperation(c11111014.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111014.thcon)
	c:RegisterEffect(e2)
	--You can banish 1 "Skydian" monster from your Extra Deck; this turn, if a monster this card points to attacks a Defense Position monster, it will inflict piercing battle damage.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11111014)
	e3:SetCost(c11111014.rmcost)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) if chk==0 then return e:GetHandler():GetLinkedGroupCount()>0 end end)
	e3:SetOperation(c11111014.rmop)
	c:RegisterEffect(e3)
end
function c11111014.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR)
end
function c11111014.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK+ATTRIBUTE_EARTH) and c:IsRace(RACE_WARRIOR) and c:IsAbleToRemove()
end
function c11111014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111014.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function c11111014.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111014.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c11111014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK
end
function c11111014.rmfil(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11111014.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111014.rmfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111014.rmfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11111014.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c) return e:GetHandler():GetLinkedGroup():IsContains(c) end)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
