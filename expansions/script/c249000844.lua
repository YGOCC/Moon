--Unlocking Key of Light
function c249000844.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51858306,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c249000844.drcon)
	e1:SetTarget(c249000844.drtg)
	e1:SetOperation(c249000844.drop)
	c:RegisterEffect(e1)
	--reduce damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(35112613,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000844.condition)
	e2:SetCost(c249000844.cost)
	e2:SetOperation(c249000844.operation)
	c:RegisterEffect(e2)
end
function c249000844.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c249000844.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c249000844.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c249000844.val)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000844.val(e,re,dam,r,rp,rc)
	return dam/2
end
function c249000844.drfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1F6)
end
function c249000844.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup() and Duel.IsExistingMatchingCard(c249000844.drfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c249000844.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000844.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end