--created by manu, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DRAW)
	e2:SetCountLimit(1,id+100)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCondition(function(e,tp) return e:GetHandler():GetOwner()~=tp end)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.tg)
	e2:SetOperation(cid.op)
	c:RegisterEffect(e2)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)~=0 end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if not tc then return end
	if tc:IsSetCard(0x70b) and tc:GetOwner()==tp then
		local c=e:GetHandler()
		local seq=c:IsHasEffect(id+3) and 0 or 2
		Duel.SendtoDeck(c,1-tp,seq,REASON_EFFECT)
		if not c:IsLocation(LOCATION_DECK) then return end
		if seq>0 then Duel.ShuffleDeck(1-tp) end
		c:ReverseInDeck()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	elseif tc:IsAbleToRemove() then
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:IsHasEffect(id+3) and 0 or 2
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,tp,seq,REASON_EFFECT) and c:IsLocation(LOCATION_DECK) then
		c:ReverseInDeck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(1-tp,cid.filter,tp,0,LOCATION_DECK,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg)
			end
		end
	end
end
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70b) and c:IsAbleToHand()
end
