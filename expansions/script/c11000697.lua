--PP Life Ring
function c11000697.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,11000697)
	e1:SetCondition(c11000697.condition2)
	e1:SetTarget(c11000697.target)
	e1:SetOperation(c11000697.operation)
	c:RegisterEffect(e1)
end
function c11000697.cfilter(c,e,tp)
	return c:IsOnField() and c:IsSetCard(0x20B) and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c11000697.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil then return false end
	local g=tg:Filter(c11000697.cfilter,nil,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return ex and tc+g:GetCount()-tg:GetCount()>0
end
function c11000697.filter(c)
	return c:IsFaceup() and c:GetFlagEffect(11000697)==0
end
function c11000697.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c11000697.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11000697.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c11000697.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c11000697.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and (tc:IsType(TYPE_MONSTER) or tc:IsType(TYPE_SPELL) or tc:IsType(TYPE_TRAP)) and tc:GetFlagEffect(11000697)==0 then
		tc:RegisterFlagEffect(11000697,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e3)
	end
end
