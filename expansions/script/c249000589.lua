--Card-Mistress Dark Valkyria
function c249000589.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22923081,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c249000589.addtg)
	e1:SetOperation(c249000589.addop)
	e1:SetLabel(3)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22923081,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c249000589.addcon)
	e2:SetTarget(c249000589.addtg)
	e2:SetOperation(c249000589.addop)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c249000589.descon)
	e3:SetTarget(c249000589.destg)
	e3:SetOperation(c249000589.desop)
	c:RegisterEffect(e3)
	--xyz while face-up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(TYPE_XYZ)
	c:RegisterEffect(e4)
	--remove overlay replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(32999573,0))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c249000589.rcon)
	e5:SetOperation(c249000589.rop)
	c:RegisterEffect(e5)
	--copy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(30312361,0))
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,249000589)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCost(c249000589.cost)
	e6:SetTarget(c249000589.target)
	e6:SetOperation(c249000589.operation)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_LEVEL_RANK)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e7)
end
function c249000589.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,e:GetLabel(),0,0x1)
end
function c249000589.addop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,e:GetLabel())
	end
end
function c249000589.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c249000589.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000589.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000589.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
function c249000589.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler()
		and e:GetHandler():IsCanRemoveCounter(tp,0x1,ev,REASON_COST)
end
function c249000589.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x1,ev,REASON_COST)
end
function c249000589.costfilter(c)
	return c:IsSetCard(0x1D4) and c:IsAbleToRemoveAsCost()
end
function c249000589.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000589.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000589.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000589.tfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function c249000589.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000589.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
end
function c249000589.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.SelectMatchingCard(tp,c249000589.tfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,c249000589.tfilter)
		if g and Duel.Remove(g,POS_FACEUP,REASON_EFFECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
			local lvrk
			if g:GetFirst():GetRank()>0 then lvrk=g:GetFirst():GetRank() else lvrk=g:GetFirst():GetLevel() end
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(lvrk*100)
			c:RegisterEffect(e1)
			c:CopyEffect(g:GetFirst():GetOriginalCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			--add code
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			e2:SetCode(EFFECT_ADD_CODE)
			e2:SetValue(tc:GetOriginalCode())
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CHANGE_DAMAGE)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(0,1)
			e3:SetValue(c249000589.damval)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function c249000589.damval(e,re,val,r,rp,rc)
	return val/2
end