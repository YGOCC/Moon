--Cryptolocker
function c221812216.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c221812216.cost1)
	e1:SetTarget(c221812216.target1)
	e1:SetOperation(c221812216.operation1)
	c:RegisterEffect(e1)
	--When a monster effect on the field is activated: Banish 1 Cyberse monster you control; negate the effect, and if you do, banish that monster.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DISABLE)
	e3:SetCondition(c221812216.condition)
	e3:SetCost(c221812216.cost2)
	e3:SetTarget(c221812216.target2)
	e3:SetOperation(c221812216.activate2)
	c:RegisterEffect(e3)
	--If this face-up card leaves the field: Special Summon the monster banished by this card's effect to its owner's field, then you can shuffle 1 of your banished Cyberse monsters into the Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c221812216.retcon)
	e2:SetOperation(c221812216.retop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	e3:SetLabelObject(e2)
end
function c221812216.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOnField() and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c221812216.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERS) and c:IsAbleToRemoveAsCost()
end
function c221812216.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local ct=Duel.GetCurrentChain()
	if ct==1 then return end
	local pe=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	if not pe:GetHandler():IsType(TYPE_MONSTER) or pe:GetActivateLocation()~=LOCATION_MZONE then return false end
	if not Duel.IsChainNegatable(ct-1) then return false end
	if not Duel.IsExistingMatchingCard(c221812216.cfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c221812216.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(1)
end
function c221812216.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()~=1 then return end
	local ct=Duel.GetCurrentChain()
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,tc,1,0,0)
	if tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
	end
end
function c221812216.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()~=1 then return end
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	local te=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	if Duel.NegateEffect(ct-1) and tc and tc:IsRelateToEffect(te) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		tc:RegisterFlagEffect(221812216,RESET_EVENT+0x1fe0000,0,1)
		c:RegisterFlagEffect(221812216,RESET_EVENT+0x17a0000,0,1)
		e:GetLabelObject():SetLabelObject(tc)
	end
end
function c221812216.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c221812216.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c221812216.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c221812216.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c221812216.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local rc=eg:GetFirst()
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)~=0 then
		rc:RegisterFlagEffect(221812216,RESET_EVENT+0x1fe0000,0,1)
		c:RegisterFlagEffect(221812216,RESET_EVENT+0x17a0000,0,1)
		e:GetLabelObject():SetLabelObject(rc)
	end
end
function c221812216.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():GetFlagEffect(221812216)~=0
end
function c221812216.rfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERS) and c:IsAbleToDeck()
end
function c221812216.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(221812216)>0 and Duel.SpecialSummon(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(c221812216.rfilter,tp,LOCATION_REMOVED,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(221812216,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local dg=g:Select(tp,1,1,nil)
			Duel.HintSelection(dg)
			Duel.BreakEffect()
			Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
		end
	end
	e:SetLabelObject(nil)
end
