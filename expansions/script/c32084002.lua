--Orichalcos Tritos
function c32084002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c32084002.atcon)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4810828,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c32084002.negcon)
	e2:SetTarget(c32084002.negtg)
	e2:SetOperation(c32084002.negop)
	c:RegisterEffect(e2)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c32084002.sdcon2)
	e4:SetOperation(c32084002.sdop)
	c:RegisterEffect(e4)
end
function c32084002.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(32084002)==0
end
function c32084002.sdop(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():CopyEffect(32084000,RESET_EVENT+0x1fe0000)
	e:GetHandler():CopyEffect(32084001,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(32084002,RESET_EVENT+0x1fe0000,0,1)
end
function c32084002.atcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)	
	return tc~=nil and tc:IsFaceup() and tc:GetCode()==32084001
end
function c32084002.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c32084002.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not (rp==1-tp and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c32084002.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c32084002.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c32084002.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
end