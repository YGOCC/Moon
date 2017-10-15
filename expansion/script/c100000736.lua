 --Created and coded by Rising Phoenix
function c100000736.initial_effect(c)
	c:EnableCounterPermit(0x54)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e11)
			--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c100000736.ctcon)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c100000736.ctop)
	c:RegisterEffect(e1)
		--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000736,1))
	e4:SetCategory(CATEGORY_DAMAGE)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c100000736.descost)
	e4:SetTarget(c100000736.destarg)
	e4:SetOperation(c100000736.damop)
	c:RegisterEffect(e4)
			--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x110))
	e3:SetValue(c100000736.atkval)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
end
function c100000736.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x54)*100
end
function c100000736.destarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(7000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,7000)
end
function c100000736.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c100000736.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x110)
end
function c100000736.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000736.cfilter,1,nil)
end
function c100000736.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x54,1)
end
function c100000736.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x110) and c:IsAbleToRemoveAsCost()
end
function c100000736.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x54,7,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x54,7,REASON_COST)
		local g=Duel.GetMatchingGroup(c100000736.spfilter,tp,LOCATION_GRAVE,0,nil)
	local rg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
