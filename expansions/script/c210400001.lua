--created & coded by Lyris, art from Yu-Gi-Oh! Duel Monsters Episode 86
--早すぎた決断
function c210400001.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210400001+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c210400001.cost)
	e1:SetTarget(c210400001.target)
	e1:SetOperation(c210400001.activate)
	c:RegisterEffect(e1)
end
function c210400001.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c210400001.filter2(c,g,tp)
	return g:IsExists(c210400001.filter1,1,c,tp,c)
end
function c210400001.filter1(c,tp,tc)
	local code=tc:GetCode()
	return c:IsCode(code) and Duel.IsExistingMatchingCard(c210400001.filter3,tp,LOCATION_DECK,0,1,Group.FromCards(c,tc),code)
end
function c210400001.filter3(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c210400001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c210400001.filter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return g:IsExists(c210400001.filter2,1,nil,g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:FilterSelect(tp,c210400001.filter2,1,1,nil,g,tp)
	local tc=tg:GetFirst()
	tg:AddCard(g:Filter(Card.IsCode,tc,tc:GetCode()):GetFirst())
	Duel.SendtoGrave(tg,REASON_COST)
	Duel.SetTargetCard(tg)
end
function c210400001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c210400001.cfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE)
end
function c210400001.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c210400001.cfilter,nil,e)
	local code=g:GetFirst():GetCode()
	if g:FilterCount(Card.IsCode,nil,code)~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c210400001.filter3,tp,LOCATION_DECK,0,1,1,nil,code)
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c210400001.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c210400001.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
