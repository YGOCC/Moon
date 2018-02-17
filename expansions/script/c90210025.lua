--セフェルの魔導書
function c90210025.initial_effect(c)
	--copy spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,90210025+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c90210025.condition)
	e1:SetCost(c90210025.cost)
	e1:SetTarget(c90210025.target)
	e1:SetOperation(c90210025.operation)
	c:RegisterEffect(e1)
end
function c90210025.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x12D) and c:IsType(TYPE_MONSTER)
end
function c90210025.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c90210025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c90210025.cffilter(c)
	return (c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130)) and not c:IsPublic()
end
function c90210025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210025.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c90210025.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c90210025.filter(c)
	return c:GetCode()~=90210025 and c:GetCode()~=90210026 and c:GetType()==TYPE_SPELL and c:CheckActivateEffect(true,true,false)~=nil
end
function c90210025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(te,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c90210025.filter,tp,LOCATION_GRAVE,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c90210025.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=cg:GetFirst()
	while tc do
		tc:CreateEffectRelation(te)
		tc=cg:GetNext()
	end
end
function c90210025.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te:GetHandler():IsRelateToEffect(e) then
		local op=te:GetOperation()
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local cg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=cg:GetFirst()
		while tc do
			tc:ReleaseEffectRelation(te)
			tc=cg:GetNext()
		end
	end
end
