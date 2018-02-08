--Art from Yu-Gi-Oh! Duel Monsters Episode 86
--早すぎた決断
function c240100193.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,240100245+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c240100193.cost)
	e1:SetTarget(c240100193.target)
	e1:SetOperation(c240100193.activate)
	c:RegisterEffect(e1)
end
function c240100193.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c240100193.filter2(c,g)
	local code=c:GetCode()
	return Duel.IsExistingMatchingCard(c240100193.filter3,tp,LOCATION_DECK,0,1,nil,code)
		and g:IsExists(Card.IsCode,1,c,code)
end
function c240100193.filter3(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c240100193.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c240100193.filter,tp,LOCATION_DECK,0,nil,e,tp):Filter(c240100193.filter2,nil,g)
	if chk==0 then return g:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	tg:AddCard(g:Filter(Card.IsCode,tc,tc:GetCode()):GetFirst())
	Duel.SendtoGrave(tg,REASON_COST)
	Duel.SetTargetCard(tg)
end
function c240100193.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100193.cfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE)
end
function c240100193.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c240100193.cfilter,nil,e)
	local code=g:GetFirst():GetCode()
	if g:FilterCount(Card.IsCode,nil,code)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c240100193.filter3,tp,LOCATION_DECK,0,1,1,nil,code)
	if tg:GetCount()>0 then
		--until your 2nd Standby Phase after this card's activation, you cannot activate cards with the same name as that monster
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c240100193.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c240100193.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
