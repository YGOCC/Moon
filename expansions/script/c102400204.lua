local cid,id=GetID()
--Roman Keys - VI
function cid.initial_effect(c)
	--This card's Level is doubled during the turn it is Summoned.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cid.lvup)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--While Summoning this card, you can return up to 3 "Roman Keys" monsters from your GY into the Deck, and if you do, apply these effects (simultaneously), based on the number of cards returned to the Deck this way. (below)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_COST)
	e5:SetCost(aux.TRUE)
	e5:SetOperation(cid.costop)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e4)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(e6)
end
function cid.lvup(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(e:GetHandler():GetLevel()*2)
	e:GetHandler():RegisterEffect(e1)
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70b)
end
function cid.costop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.AND(cid.filter,Card.IsAbleToDeck),tp,LOCATION_GRAVE,0,nil)
	if #g==0 or not Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then return end
	Duel.Hint(HINT_CARD,0,id)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SendtoDeck(g:Select(tp,1,3,nil),nil,2,REASON_EFFECT)
	local tg=Duel.GetOperatedGroup()
	if tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then Duel.ShuffleDeck(tp) end
	--2+: Draw 1 card.
	if #tg>=2 and Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
	--3: Add 1 "Roman Keys" monster from your Deck to your hand.
	local sg=Duel.GetMatchingGroup(aux.AND(cid.filter,Card.IsAbleToHand),tp,LOCATION_DECK,0,nil)
	if #tg>=3 and #sg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local hg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
	end
end
