--This file was automatically coded by Kinny's Numeron Code~!
local ref=_G['c'..28915113]
local id=28915113
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,289151130)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.target0)
	e0:SetOperation(ref.operation0)
	c:RegisterEffect(e0)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.filterE0P0(c,e,tp)
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then return false end
	return (Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) or c:IsLevelBelow(4))
end
function ref.target0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.filterE0P0,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	if chkc then return chkc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) end
	local g0 = Duel.SelectTarget(tp,ref.filterE0P0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.operation0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g0 = Duel.GetFirstTarget()
	Duel.SpecialSummon(g0,0,tp,tp,false,false,POS_FACEUP)
end
