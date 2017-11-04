--Contract with the Arcflame
--Design and Code by Kindrindra--
local ref=_G['c'..28915316]
function ref.initial_effect(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28915316+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(ref.thtg)
	e1:SetOperation(ref.thop)
	c:RegisterEffect(e1)
	--Grave Swap
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(ref.grcost)
	e2:SetTarget(ref.grtg)
	e2:SetOperation(ref.grop)
	c:RegisterEffect(e2)
end

function ref.thfilter1(c)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(ref.thfilter2,c:GetControler(),LOCATION_DECK,0,1,nil,c:GetCode())
end
function ref.thfilter2(c,code)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(code)
end

function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(ref.thfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function ref.grfilter(c)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToGrave()
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		e1:SetCountLimit(1)
		e1:SetLabel(ref.counter)
		e1:SetCondition(ref.retcon)
		e1:SetOperation(ref.retop)
		e1:SetLabelObject(g)
		Duel.RegisterEffect(e1,tp)
		g:KeepAlive()
		local tc=g:GetFirst()
		while tc do
			tc:RegisterFlagEffect(28915316,RESET_EVENT+0x1fe0000,0,1)
			tc=g:GetNext()
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOOHAND)
		local g1=Duel.SelectMatchingCard(tp,ref.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g1:GetCount()<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g2=Duel.SelectMatchingCard(tp,ref.thfilter2,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetCode())
		g1:Merge(g2)
		if g1:GetCount()==2 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g1)
			Duel.BreakEffect()
			if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(28915316,0)) then
				local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
function ref.retfilter(c)
	return c:GetFlagEffect(28915316)~=0
end
function ref.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(ref.retfilter,nil)
	g:DeleteGroup()
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end

function ref.grcfilter(c)
	return c:IsSetCard(0x72C)
		and (c:IsAbleToDeckAsCost() or c:IsAbleToExtraAsCost())
end
function ref.grcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.grcfilter,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,ref.grcfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function ref.grfilter(c)
	return c:IsSetCard(0x72C) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToGrave()
end
function ref.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
