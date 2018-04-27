function c24951016.initial_effect(c)
	c:SetUniqueOnField(1,0,24951016)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN),2,2)
	-- is also Continuous Spell / Token
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(TYPE_TOKEN)
	c:RegisterEffect(e2)
	-- shuffle from GY / banished
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(24951016,2))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c24951016.retcondition)
	e3:SetOperation(c24951016.retoperation)
	c:RegisterEffect(e3)
	-- other magenic cards are unaffected
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,nil)
	e5:SetTarget(c24951016.etarget)
	e5:SetValue(c24951016.efilter)
	c:RegisterEffect(e5)
	-- activate from deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(24951016,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetHintTiming(0,TIMING_END_PHASE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c24951016.cost)
	e6:SetOperation(c24951016.operation)
	c:RegisterEffect(e6)
end
function c24951016.retcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24951016.retfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) 
end
function c24951016.retoperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c24951016.retfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SendtoDeck(g,nil,REASON_COST,1)
end
function c24951016.retfilter(c,tp)
	return c:IsSetCard(0x5F453A) and c:IsAbleToDeck()
end
function c24951016.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(c24951016.lkfilter,1,nil)
end
function c24951016.lkfilter(c,tp)
	return c:IsType(TYPE_TOKEN) or c:IsType(TYPE_SPELL+TYPE_CONTINUOUS)
end
function c24951016.etarget(e,c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5F453A) and not c==e:GetHandler()
end
function c24951016.efilter(e,te,re)
	return not re==e
end
function c24951016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24951016.sendfilter,tp,LOCATION_HAND,0,1,nil) 
	and Duel.IsExistingMatchingCard(c24951016.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24951016.sendfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
	Duel.ShuffleDeck(tp)
end
function c24951016.sendfilter(c)
	return c:IsSetCard(0x5F453A) and c:IsAbleToDeckAsCost()
end
function c24951016.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c24951016.thfilter,tp,LOCATION_DECK,0,1,1,nil,false)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=
		(
			tc:GetActivateEffect():IsActivatable(tp) 
			and (
				(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsType(TYPE_FIELD)) or tc:IsType(TYPE_FIELD)
			)
		)

		if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(24951016,0))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			tc:SetStatus(STATUS_ACTIVATED,true)
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.ConfirmCards(tp,tc)

			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()				
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if not (tc:IsType(TYPE_FIELD) or tc:IsType(TYPE_CONTINUOUS)) then
				tc:CancelToGrave(false)
			end
			if true -- te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local tg=g:GetFirst()
					while tg do
						tg:CreateEffectRelation(te)
						tg=g:GetNext()
					end
				end
				tc:SetStatus(STATUS_ACTIVATED,true)
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if g then
					tg=g:GetFirst()
					while tg do
						tg:ReleaseEffectRelation(te)
						tg=g:GetNext()
					end
				end
			end
		end
	end
end
function c24951016.thfilter(c,tp)
	return c:IsSetCard(0x5F453A) and c:IsType(TYPE_SPELL)
		and (
			c:IsAbleToHand() 
			or (
				c:GetActivateEffect():IsActivatable(tp)
				and (
					(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsType(TYPE_FIELD))
					or tc:IsType(TYPE_FIELD)
					)
				)
			)
end