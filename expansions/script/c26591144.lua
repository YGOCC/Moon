--Rocce Sacre della Xenofiamma
--Script by XGlitchy30
function c26591144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591144+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c26591144.cost)
	e1:SetTarget(c26591144.target)
	e1:SetOperation(c26591144.activate)
	c:RegisterEffect(e1)
	--recover removed
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c26591144.rmtg)
	e2:SetOperation(c26591144.rmop)
	c:RegisterEffect(e2)
end
--filters
function c26591144.costfilter(c)
	return c:IsSetCard(0x23b9) and c:IsDiscardable()
		and (Duel.IsExistingMatchingCard(c26591144.scfilter,tp,LOCATION_DECK,0,1,nil)
			or Duel.IsExistingMatchingCard(c26591144.drawfilter,tp,LOCATION_REMOVED,0,1,nil))
end
function c26591144.scfilter(c)
	return c:IsSetCard(0x23b9) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c26591144.drawfilter(c)
	return c:IsSetCard(0x23b9) and c:IsAbleToDeck()
end
function c26591144.rmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and not c:IsCode(26591144)
end
--Activate
function c26591144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c26591144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26591144.costfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c26591144.scfilter,tp,LOCATION_DECK,0,1,nil)
			or (Duel.IsExistingMatchingCard(c26591144.drawfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1))
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c26591144.costfilter,tp,LOCATION_HAND,0,1,1,nil)
		if Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c26591144.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		local opt=0
		if Duel.IsExistingMatchingCard(c26591144.scfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c26591144.drawfilter,tp,LOCATION_REMOVED,0,1,nil) then
			opt=Duel.SelectOption(tp,aux.Stringid(26591144,0),aux.Stringid(26591144,1))
		elseif Duel.IsExistingMatchingCard(c26591144.scfilter,tp,LOCATION_DECK,0,1,nil) then
			opt=Duel.SelectOption(tp,aux.Stringid(26591144,0))
		elseif Duel.IsExistingMatchingCard(c26591144.drawfilter,tp,LOCATION_REMOVED,0,1,nil) then
			opt=Duel.SelectOption(tp,aux.Stringid(26591144,1))+1
		end
		e:SetLabel(opt)
		if opt==0 then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		else
			e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
			Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		end
	end
end
function c26591144.splimit(e,c)
	return not c:IsSetCard(0x23b9)
end
function c26591144.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local k=0
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c26591144.scfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c26591144.drawfilter,tp,LOCATION_REMOVED,0,1,3,nil)
		if g:GetCount()>0 then
			k=g:GetCount()
			Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			local opg=Duel.GetOperatedGroup()
			if opg:GetCount()<=0 then return end
			Duel.ShuffleDeck(tp)
			local ct=opg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
			if ct==k then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
--recover removed
function c26591144.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c26591144.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26591144.rmfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c26591144.rmfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c26591144.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end