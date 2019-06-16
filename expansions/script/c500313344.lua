function c500313344.initial_effect(c)
--pendulum summon
		c:EnableReviveLimit()

	 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x85a))
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
   
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(500313344,0))
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	 e0:SetCost(c500313344.cost)
	e0:SetCountLimit(1,500313344)
	e0:SetTarget(c500313344.thtg)
	e0:SetOperation(c500313344.thop)
	c:RegisterEffect(e0)

		local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500313344,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
   e1:SetRange(LOCATION_MZONE)
	 e1:SetProperty(EFFECT_FLAG_DELAY)
   -- e1:SetHintTiming(0,0x1c0)
	e1:SetCountLimit(1)
	e1:SetCost(c500313344.cost)
	e1:SetTarget(c500313344.target)
	e1:SetOperation(c500313344.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetTarget(c500313344.target2)
	c:RegisterEffect(e3)
   
	
end
function c500313344.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0x185a) or  c:IsRace(RACE_PLANT)  then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c500313344.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c500313344.thfilter(c)
	return c:IsSetCard(0x85a) and c:IsFaceup() and c:IsAbleToHand()
end
function c500313344.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c500313344.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c500313344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c500313344.thop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c500313344.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
 Duel.ConfirmCards(1-tp,g)
end
end
function c500313344.filter(c,tp,ep,val)
	return c:IsFaceup() and c:GetSummonPlayer()~=tp and not c:IsDisabled()
end

function c500313344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISCARD_COST_CHANGE) then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c500313344.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c500313344.filter,1,nil,tp) end
	local g=eg:Filter(c500313344.filter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetChainLimit(c500313344.limit(Duel.GetCurrentChain()))
end
function c500313344.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return rp==1-tp and tc:IsFaceup() and not tc:IsDisabled() end
	Duel.SetTargetCard(tc)
	Duel.SetChainLimit(c500313344.limit(Duel.GetCurrentChain()))
end
function c500313344.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
	 Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	  local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
		tc=g:GetNext()
		end
end
function c500313344.limit(ch)
	return function(e,lp,tp)
		return not Duel.GetChainInfo(ch,CHAININFO_TARGET_CARDS):IsContains(e:GetHandler())
	end
end