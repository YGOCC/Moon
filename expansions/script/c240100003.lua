--created & coded by Lyris, art from "Hero Signal" and "Destiny Signal"
--シグナル・インターセプト
function c240100003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c240100003.condition)
	e1:SetTarget(c240100003.target)
	e1:SetOperation(c240100003.activate)
	c:RegisterEffect(e1)
end
function c240100003.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()<=1 or rp==tp then return false enf
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and Duel.IsChainNegatable(i) then
			return true
		end
	end
end
function c240100003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
end
function c240100003.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if te:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
	Duel.SendtoDeck(dg,nil,1,REASON_EFFECT)
end
