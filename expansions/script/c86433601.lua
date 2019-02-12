--Target Eligibility
--Script by XGlitchy30
function c86433601.initial_effect(c)
	--lock chain
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(86433601,0))
	e0:SetCategory(CATEGORY_DRAW)
	e0:SetType(EFFECT_TYPE_QUICK_F)
	e0:SetCode(EVENT_CHAINING)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCountLimit(1,80433601)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c86433601.chcon)
	e0:SetCost(c86433601.chcost)
	e0:SetTarget(c86433601.chtg)
	e0:SetOperation(c86433601.chainop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86433601,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,86433601+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c86433601.discon)
	e1:SetCost(c86433601.discost)
	e1:SetTarget(c86433601.distg)
	e1:SetOperation(c86433601.disop)
	c:RegisterEffect(e1)
end
--filters
function c86433601.tfilter(c)
	return c:IsOnField() or c:IsLocation(LOCATION_GRAVE)
end
function c86433601.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c86433601.rvfilter(c)
	return c:IsType(TYPE_TRAP) and not c:IsPublic()
end
--lock chain
function c86433601.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and e:GetHandler():GetFlagEffect(87433601)<=0
end
function c86433601.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingMatchingCard(c86433601.rvfilter,tp,LOCATION_HAND,0,1,c) end
	if Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c86433601.rvfilter,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function c86433601.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetChainLimit(aux.FALSE)
end
function c86433601.chainop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--Activate
function c86433601.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c86433601.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(87433601)<=0
end
function c86433601.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86433601.costfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c86433601.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c86433601.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,0)
	end
end
function c86433601.disop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		if not tg:IsExists(Card.IsAbleToRemove,1,nil) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(86433601,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=tg:Select(tp,1,1,nil)
			Duel.HintSelection(tc)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end