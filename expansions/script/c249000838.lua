--Mecha-Core Emerald
function c249000838.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79979666,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c249000838.condition)
	e1:SetTarget(c249000838.target)
	e1:SetOperation(c249000838.operation)
	c:RegisterEffect(e1)
end
function c249000838.filter(c)
	return not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
function c249000838.filter2(c)
	return c:IsSetCard(0x1F5) and c:GetCode()~=249000838
end
function c249000838.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000838.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>1
	and not Duel.IsExistingMatchingCard(c249000838.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c249000838.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c249000838.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c249000838.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DRAW)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end