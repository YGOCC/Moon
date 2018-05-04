--Hard Form of the Lost Waters
local card = c210310342
function card.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(card.target)
	e1:SetOperation(card.operation)
	c:RegisterEffect(e1)
--	banish to draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(74335036,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(card.tdcost)
	e2:SetTarget(card.tdtg)
	e2:SetOperation(card.tdop)
	c:RegisterEffect(e2)
end
--activate
--steel shell filter
function card.filter1(c,tp)
	return c:IsCode(82999629) and c:GetActivateEffect():IsActivatable(tp)
end
function card.filter2(c)
	return c:IsType(TYPE_EQUIP) and c:IsCode(2370081) and Duel.IsExistingMatchingCard(card.eqcheck,tp,LOCATION_MZONE,0,1,nil,c)
end
function card.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function card.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(card.filter1,tp,LOCATION_DECK,0,1,nil,tp)
	or (Duel.IsExistingMatchingCard(card.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) end
end
function card.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local option
	if Duel.IsExistingMatchingCard(card.filter1,tp,LOCATION_DECK,0,1,nil,tp) then option=0 end
	if Duel.IsExistingMatchingCard(card.filter2,tp,LOCATION_DECK,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(card.filter1,tp,LOCATION_DECK,0,1,nil,tp)
	and Duel.IsExistingMatchingCard(card.filter2,tp,LOCATION_DECK,0,1,nil) then
		option=Duel.SelectOption(tp,1108,1068)
	end
	if option==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15248873,0))
		local tc=Duel.SelectMatchingCard(tp,card.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local fc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if fc2 and Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
				Duel.Destroy(fc2,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_IGNITION)
				e1:SetCategory(CATEGORY_ATKCHANGE)
				e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
				e1:SetRange(LOCATION_SZONE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetCountLimit(1)
				e1:SetTarget(card.atktg)
				e1:SetOperation(card.atkop)
				tc:RegisterEffect(e1)
			end
		end
	end
	if option==1 then
		local tc=Duel.SelectMatchingCard(tp,card.filter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		local tc2=Duel.SelectMatchingCard(tp,card.eqcheck,tp,LOCATION_MZONE,0,1,1,nil,tc):GetFirst()
		Duel.Equip(tp,tc,tc2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCountLimit(1)
		e1:SetTarget(card.atktg)
		e1:SetOperation(card.atkop)
		tc:RegisterEffect(e1)
	end
end
function card.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER)
end
function card.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and card.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(card.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,card.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)

end
function card.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e3)

end
end
function card.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--banish to draw
function card.tdfilter(c)
	return c:IsCode(82999629,2370081) and c:IsAbleToRemoveAsCost()
end
function card.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(card.tdfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,card.tdfilter,tp,LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function card.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function card.tdop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
