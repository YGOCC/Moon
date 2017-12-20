--Festering Hate
function c221812215.initial_effect(c)
	--When this card is activated: You can activate 1 "BRAIN Boot Sector" from your Deck. You can only activate 1 "Festering Hate" per Chain.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c221812215.cost)
	e1:SetOperation(c221812215.activate)
	c:RegisterEffect(e1)
	--Once per turn, when an opponent's card is destroyed (either by battle or card effect): You can draw 1 card.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCondition(c221812215.drcon)
	e2:SetTarget(c221812215.drtg)
	e2:SetOperation(c221812215.drop)
	c:RegisterEffect(e2)
end
function c221812215.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,221812215)==0 end
	Duel.RegisterFlagEffect(tp,221812215,RESET_CHAIN,0,1)
end
function c221812215.filter(c,tp)
	return c:IsCode(221812211) and c:GetActivateEffect():IsActivatable(tp)
end
function c221812215.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c221812215.filter,tp,LOCATION_DECK,0,nil,tp)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(221812215,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48934760,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c221812215.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()~=tp
end
function c221812215.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c221812215.cfilter,1,nil,tp)
end
function c221812215.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c221812215.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
