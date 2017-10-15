--永遠の魂
function c4120.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c4120.target1)
	e1:SetOperation(c4120.operation)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(c4120.cost2)
	e2:SetTarget(c4120.target2)
	e2:SetOperation(c4120.operation)
	c:RegisterEffect(e2)
	--Shuffle+Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4120,3))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c4120.tdtg)
	e3:SetOperation(c4120.tdop)
	c:RegisterEffect(e3)
end
function c4120.filter1(c)
	return c:IsSetCard(0x1004101d) and c:IsAbleToGrave()
end
function c4120.filter2(c)
	return c:IsSetCard(0x10041036) and not c:IsCode(4120) and c:IsAbleToHand()
end
function c4120.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.IsExistingMatchingCard(c4120.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c4120.filter2,tp,LOCATION_DECK,0,1,nil)
	local op=2
	e:SetCategory(0)
	if Duel.GetFlagEffect(tp,4120)==0 and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(4120,0)) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(4120,1),aux.Stringid(4120,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(4120,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(4120,2))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_TOGRAVE)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		else
			e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
			e:SetCategory(CATEGORY_DESTROY)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
		end
		Duel.RegisterFlagEffect(tp,4120,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end
function c4120.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c4120.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
		end
	else
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c4120.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then
		local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,0,nil)
		if g2:GetCount()==0 then return end
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.BreakEffect()
		Duel.Destroy(g2,REASON_EFFECT)
		end
	end
end
end
function c4120.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,4120)==0 end
	Duel.RegisterFlagEffect(tp,4120,RESET_PHASE+PHASE_END,0,1)
end
function c4120.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c4120.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c4120.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(4120,1),aux.Stringid(4120,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(4120,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(4120,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
	end
end
function c4120.tdfil(c)
	return c:IsSetCard(0x1004) and c:IsAbleToDeck()
end
function c4120.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c4120.tdfil(chkc) end
	local g=Duel.GetMatchingGroup(c4120.tdfil,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:GetClassCount(Card.GetCode)>=1 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c4120.tdfil,tp,LOCATION_GRAVE,0,1,5,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c4120.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	sg=sg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) then
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
