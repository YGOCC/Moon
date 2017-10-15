-- Modular Task Killer Type S
function c444413.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444413,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetRange(LOCATION_ONFIELD+LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c444413.condition)
	e1:SetTarget(c444413.target)
	e1:SetOperation(c444413.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end
-- "global handlerspecific activation limiter" (archetype effect)
function c444413.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.GetFlagEffect(tp,e:GetHandler():GetCode())<2 
end
function c444413.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c444413.secondfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(4444)
end
function c444413.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c444413.secondfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c444413.filter,tp,0,LOCATION_ONFIELD,1,nil)end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE+CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)   
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetCode(),RESET_EVENT+0x007e0000+RESET_PHASE+PHASE_END,0,1)
end
function c444413.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c444413.filter,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(c444413.secondfilter,tp,LOCATION_ONFIELD,0,nil)
    if g1:GetCount()>0 and g2:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.HintSelection(sg1)		
		local tc=sg1:GetFirst() 
		while tc do
			local i=tc:GetFlagEffectLabel(444413)
			Duel.NegateActivation(i)
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
	       	e1:SetCode(EFFECT_DISABLE)
		    e1:SetReset(RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
	      	e2:SetCode(EFFECT_DISABLE_EFFECT)
	       	e2:SetReset(RESET_EVENT+0x00400000+RESET_PHASE+PHASE_END) -- RESET_EVENT+0x007e0000+
			tc:RegisterEffect(e2)			
			Duel.BreakEffect()
		    tc=sg1:GetNext()
		end
	Duel.Destroy(sg1,REASON_EFFECT)
	end
end