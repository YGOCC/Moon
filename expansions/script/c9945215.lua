--Sin & Virtue, Together As One
--Scripted by IanxWaifu
function c9945215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9945215+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c9945215.target)
	e1:SetOperation(c9945215.activate)
	c:RegisterEffect(e1)
end
function c9945215.filter(c)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9945215.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945215.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9945215.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945215.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSetCard(0x204F) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(9945215,1))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_DRAW)
		e1:SetCondition(c9945215.tgcon)
		e1:SetTarget(c9945215.tgtg)
		e1:SetOperation(c9945215.tgop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
	elseif tc and tc:IsSetCard(0x2050) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(9945215,1))
		e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_DRAW)
		e2:SetCondition(c9945215.tgcon)
		e2:SetTarget(c9945215.tgtg2)
		e2:SetOperation(c9945215.tgop2)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
		c:CreateEffectRelation(e2)
	end
end
function c9945215.tgfilter(c)
	return c:IsSetCard(0x2050) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9945215.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9945215.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9945215.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9945215.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945215.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9945215.tgfilter2(c)
	return c:IsSetCard(0x204F) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c9945215.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9945215.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9945215.tgfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9945215.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9945215.tgfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end