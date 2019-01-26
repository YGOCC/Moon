--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28915114]
local id=28915114
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCountLimit(1,28915114)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.filterE0P0(c)
	if not c:IsAbleToGrave() then return false end
	return (Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) or c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filterE0P0,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.SelectMatchingCard(tp,ref.filterE0P0,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g0,REASON_EFFECT)
end
