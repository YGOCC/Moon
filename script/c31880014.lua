--Reapers' Sanctuary
function c31880014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--extra summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7C88))
	c:RegisterEffect(e5)
		--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetCountLimit(1)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTarget(c31880014.desreptg)
	c:RegisterEffect(e6)
end
function c31880014.rfilter(c)
return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7C88) and c:IsAbleToGrave()
end
function c31880014.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return not c:IsReason(REASON_REPLACE)
and Duel.IsExistingMatchingCard(c31880014.rfilter,tp,LOCATION_DECK,0,1,nil,nil)
end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
local g=Duel.SelectMatchingCard(tp,c31880014.rfilter,tp,LOCATION_DECK,0,1,1,nil,nil)
Duel.SendtoGrave(g,REASON_EFFECT)
return true
end