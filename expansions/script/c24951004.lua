-- Magenic Vessel of Hanu
function c24951004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24951004,0))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,24951004)
	e2:SetCondition(c24951004.proxcon)
	e2:SetOperation(c24951004.proxop)
	c:RegisterEffect(e2)
end
function c24951004.proxcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsActiveType(TYPE_SPELL) 
			and te:GetHandler():IsSetCard(0x5F453A) 
			and Duel.IsPlayerCanDraw(tp,1)then
			return true
		end
	end
end
function c24951004.proxop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c24951004.etarget)
	e3:SetValue(500)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e4,tp)
end
function c24951004.etarget(e,c)
	return c:IsType(TYPE_TOKEN)
end