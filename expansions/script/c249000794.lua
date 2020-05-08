--Chaos-Mage Lunar Watcher
function c249000794.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000794.spcon)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000794.poscon)
	e2:SetOperation(c249000794.posop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12510878,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c249000794.condition)
	e3:SetCost(c249000794.cost)
	e3:SetTarget(c249000794.target)
	e3:SetOperation(c249000794.operation)
	c:RegisterEffect(e3)
end
function c249000794.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c249000794.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c249000794.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
	c:RegisterEffect(e1)
end
function c249000794.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c249000794.costfilter(c)
	return c:IsSetCard(0x30CF) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000794.costfilter2(c)
	return c:IsSetCard(0x30CF) and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c249000794.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000794.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	or Duel.IsExistingMatchingCard(c249000794.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())) end
	local option
	if Duel.IsExistingMatchingCard(c249000794.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler())  then option=0 end
	if Duel.IsExistingMatchingCard(c249000794.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) then option=1 end
	if Duel.IsExistingMatchingCard(c249000794.costfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	and Duel.IsExistingMatchingCard(c249000794.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000794.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000794.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c249000794.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c249000794.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end