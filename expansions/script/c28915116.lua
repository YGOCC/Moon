--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28915116]
local id=28915116
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,28915116)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.filterE0P0(c)
	return true
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.filterE0P0,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,nil) end
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_SZONE) and chkc:IsControler(1-tp) end
	local g0 = Duel.SelectTarget(tp,ref.filterE0P0,tp,0,LOCATION_MZONE+LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		Duel.Destroy(g0,REASON_EFFECT,LOCATION_REMOVED)
	else
		Duel.Destroy(g0,REASON_EFFECT)
	end
end
