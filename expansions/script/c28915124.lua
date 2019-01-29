--Possession Art - Hijiri
local ref=_G['c'..28915124]
local id=28915124
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,1,1,ref.matfilter)
	--Effect 0
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCountLimit(1,id)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(ref.acttg)
	e0:SetOperation(ref.actop)
	c:RegisterEffect(e0)
end
function ref.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.ssfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,tp,false,false)
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	if chkc then return ref.ssfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_REMOVED) end
	local g0 = Duel.SelectTarget(tp,ref.sfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g0,g0:GetFirst():GetControler(),g0:GetCount(),g0:GetFirst():GetLocation())
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	local g0 = Duel.GetFirstTarget()
	if (not Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)) and Duel.IsChainDisablable(0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
		Duel.NegateEffect(0)
	else
		Duel.SpecialSummon(g0,0,tp,tp,false,false,POS_FACEUP)
	end
end
