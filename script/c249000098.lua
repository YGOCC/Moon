--Magical Forces Arts - Treasure Draw
function c249000098.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000098)
	e1:SetCondition(c249000098.condition)
	e1:SetCost(c249000098.cost)
	e1:SetTarget(c249000098.target)
	e1:SetOperation(c249000098.activate)
	c:RegisterEffect(e1)
end
function c249000098.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0,nil)<Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_ONFIELD,nil)
end
function c249000098.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x15A) and c:IsAbleToRemoveAsCost()
end
function c249000098.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000098.costfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000098.costfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000098.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0xe,1,nil) end
	Duel.SetTargetPlayer(tp)
	local draw=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)
	if draw > 4 then draw=4 end
	Duel.SetTargetParam(draw)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,draw)
end
function c249000098.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
