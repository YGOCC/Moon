--Here You Have
function c221812212.initial_effect(c)
	--Discard 1 Level 1 Cyberse monster; draw 2 cards.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c221812212.cost)
	e1:SetTarget(c221812212.target)
	e1:SetOperation(c221812212.activate)
	c:RegisterEffect(e1)
end
function c221812212.cfilter(c)
	return c:IsRace(RACE_CYBERS) and c:GetLevel()==1 and c:IsDiscardable()
end
function c221812212.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c221812212.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c221812212.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c221812212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c221812212.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
