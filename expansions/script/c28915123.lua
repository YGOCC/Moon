--Possession Art - Greed
local ref=_G['c'..28915123]
local id=28915123
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
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function ref.exfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetTurnCount()==c:GetTurnID()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if (not Duel.IsExistingMatchingCard(ref.exfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)) and Duel.IsChainDisablable(0) and Duel.IsExistingMatchingCard(Card.IsDiscardable,1-tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) then
		Duel.DiscardHand(1-tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
		Duel.NegateEffect(0)
	else
		Duel.Draw(p,d,REASON_EFFECT)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,c)
	end
end
