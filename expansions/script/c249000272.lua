--Spell-Disciple's Calling Tome
function c249000272.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000272+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c249000272.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c249000272.disop)
	c:RegisterEffect(e2)
end
function c249000272.filter(c)
	return c:IsSetCard(0x1D9) and c:GetCode()~=249000272 and c:IsAbleToHand()
end
function c249000272.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c249000272.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(249000272,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c249000272.filter2(c,tp)
	return c:IsSetCard(0x1D9) and c:IsLocation(LOCATION_MZONE) and c:GetControler()==tp
end
function c249000272.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsExists(c249000272.filter2,1,nil,tp) or not Duel.IsChainDisablable(ev) then return false end
	local rc=re:GetHandler()
	if Duel.GetFlagEffect(tp,249000272)==0 and Duel.SelectYesNo(tp,1131) then
		e:GetHandler():RegisterFlagEffect(249000272,RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,249000272)
		Duel.NegateEffect(ev)
	end
end