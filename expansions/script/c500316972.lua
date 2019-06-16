--Twin-Venuses Fiber VINE Dragon
function c500316972.initial_effect(c)
  --pendulum summon
	aux.EnablePendulumAttribute(c)
		c:EnableReviveLimit()
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
   --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500316972,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	 e1:SetCountLimit(1,500316972+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c500316972.condition)
	e1:SetOperation(c500316972.operation)
	c:RegisterEffect(e1)  
  --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500316972,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,500316973)
	e2:SetTarget(c500316972.destg)
	e2:SetOperation(c500316972.desop)
	c:RegisterEffect(e2)
--to deck
	   local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500316972,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_EXTRA)
	 e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x11e0)
	  e4:SetCountLimit(1,500316974)
	e4:SetCost(c500316972.cost2)
	e4:SetTarget(c500316972.target)
	e4:SetOperation(c500316972.activate)
	c:RegisterEffect(e4)
end
function c500316972.cfilter(c,tp)
	return c:GetSummonPlayer()==tp  
end
function c500316972.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500316972.cfilter,1,nil,1-tp) and eg:IsExists(c500316972.filter2,1,nil,1-tp)
end

function c500316972.operation(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c500316972.drcon1)
	e1:SetOperation(c500316972.drop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c500316972.regcon)
	e2:SetOperation(c500316972.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c500316972.drcon2)
	e3:SetOperation(c500316972.drop2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c500316972.filter(c,sp)
	return c:GetSummonPlayer()==sp and not c:IsType(TYPE_RITUAL) or  not c:IsType(TYPE_EVOLUTE)
end
function c500316972.filter2(c,sp)
	return  not c:IsType(TYPE_RITUAL) and not c:IsType(TYPE_EVOLUTE)
end
function c500316972.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500316972.filter,1,nil,1-tp) and eg:IsExists(c500316972.filter2,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function c500316972.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c500316972.regcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c500316972.filter,1,nil,1-tp) and eg:IsExists(c500316972.filter2,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function c500316972.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,500316972,RESET_CHAIN,0,1)
end
function c500316972.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,500316972)>0
end
function c500316972.sipfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x185a) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c500316972.drop2(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,500316972)
	Duel.ResetFlagEffect(tp,500316972)
	Duel.Draw(tp,n,REASON_EFFECT)
end
function c500316972.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c500316972.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsDestructable() and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c500316972.sipfilter,tp,LOCATION_REMOVED,0,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c500316972.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		 local g=Duel.SelectMatchingCard(tp,c500316972.sipfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local tc=g:GetFirst()
			 Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		 
		end
	end
end
function c500316972.xxfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x185a) 
end
function c500316972.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c500316972.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and c500316972.xxfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500316972.xxfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c500316972.xxfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c500316972.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:RegisterFlagEffect(500316972,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(500316972,1))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(c500316972.discon)
		e1:SetOperation(c500316972.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end
end
function c500316972.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(500316972)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) 
	return g and g:IsContains(tc) and re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c500316972.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
