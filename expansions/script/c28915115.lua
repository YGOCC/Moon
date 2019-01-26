--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28915115]
local id=28915115
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,28915115)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.filterE0P0(c)
	return true
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(ref.filterE0P0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc~=c end
	local g0 = Duel.SelectTarget(tp,ref.filterE0P0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.GetFirstTarget()
	if Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.SendtoDeck(g0,nil,2,REASON_EFFECT)
	else
		Duel.SendtoHand(g0,nil,REASON_EFFECT)
	end
end
