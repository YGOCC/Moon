--Pot of Altruism
local ref=_G['c'..28915101]
local id=28915101
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
end

--Activate
function ref.monfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,c)
		or Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,c)
		or Duel.IsExistingMatchingCard(ref.monfilter,tp,LOCATION_GRAVE,0,1,c)
		or Duel.IsExistingMatchingCard(ref.monfilter,tp,LOCATION_REMOVED,0,1,c)
	end
	Duel.SetTargetPlayer(tp)
end
function ref.shufflefilter(c,p)
	return c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:IsControler(p)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Group.CreateGroup()
	--From Hand
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,c) and Duel.SelectYesNo(p,aux.Stringid(id,0)) then
		local sc=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,1,c):GetFirst()
		g:AddCard(sc)
	end
	--From Field
	if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,c) and Duel.SelectYesNo(p,aux.Stringid(id,1)) then
		local sc=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_ONFIELD,0,1,1,c):GetFirst()
		g:AddCard(sc)
	end
	--From Grave
	if Duel.IsExistingMatchingCard(ref.monfilter,tp,LOCATION_GRAVE,0,1,c) and Duel.SelectYesNo(p,aux.Stringid(id,2)) then
		local sc=Duel.SelectMatchingCard(p,ref.monfilter,p,LOCATION_GRAVE,0,1,1,c):GetFirst()
		g:AddCard(sc)
	end
	--From Banished
	if Duel.IsExistingMatchingCard(ref.monfilter,tp,LOCATION_REMOVED,0,1,c) and Duel.SelectYesNo(p,aux.Stringid(id,3)) then
		local sc=Duel.SelectMatchingCard(p,ref.monfilter,p,LOCATION_REMOVED,0,1,1,c):GetFirst()
		g:AddCard(sc)
	end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(ref.shufflefilter,1,nil,p) then Duel.ShuffleDeck(p) end
	if g:IsExists(ref.shufflefilter,1,nil,1-p) then Duel.ShuffleDeck(1-p) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>1 then
		Duel.Draw(p,1,REASON_EFFECT)
	end
	if ct>2 then
		Duel.BreakEffect()
		Duel.Draw(p,1,REASON_EFFECT)
		Duel.Recover(p,ct*500,REASON_EFFECT)
	end
end
