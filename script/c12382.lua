--Mecha Girl Overhaul
function c12382.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--LP up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12382,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c12382.condition)
	e2:SetTarget(c12382.target)
	e2:SetOperation(c12382.operation)
	c:RegisterEffect(e2)
	--AtkChange
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12382,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetCondition(c12382.condition2)
	e3:SetTarget(c12382.target2)
	e3:SetOperation(c12382.operation2)
	c:RegisterEffect(e3)
end
function c12382.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFaceup() and c:IsSetCard(0x3052)
end
function c12382.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12382.filter,1,nil)
end
function c12382.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local ct=eg:FilterCount(c12382.filter,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,500)
end
function c12382.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function c12382.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x3052) and c:IsType(TYPE_MONSTER)
end
function c12382.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12382.cfilter,1,nil,tp)
end
function c12382.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c12382.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	local g=eg:IsExists(c12382.cfilter,1,nil,tp)
	local c=e:GetHandler()
	local atk=0
	local sg=eg:GetFirst()
	while sg do
		if sg:GetTextAttack()>0 then
			atk=atk+sg:GetTextAttack()
		end
		sg=eg:GetNext()
	end
	if atk>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	end
end