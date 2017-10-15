--Dark Burial Rider
function c249000165.initial_effect(c)
	--to grave, discarding a monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(70)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,249000165)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c249000165.sgcost)
	e1:SetTarget(c249000165.sgtg)
	e1:SetOperation(c249000165.sgop)
	c:RegisterEffect(e1)
	--to grave, dicarding a non monster
	local e2=e1:Clone()
	e2:SetDescription(71)
	e2:SetCost(c249000165.sgcost2)
	e2:SetTarget(c249000165.sgtg2)
	e2:SetOperation(c249000165.sgop2)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c249000165.drcon)
	e3:SetCost(c249000165.drcost)
	e3:SetTarget(c249000165.drtarget)
	e3:SetOperation(c249000165.drop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c249000165.spcon)
	c:RegisterEffect(e4)
end
function c249000165.costfilter(c)
	return c:IsDiscardable() and c:IsType(TYPE_MONSTER)
end
function c249000165.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000165.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000165.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c249000165.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c249000165.sgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000165.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c249000165.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000165.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c249000165.costfilter2(c)
	return c:IsDiscardable() and not c:IsType(TYPE_MONSTER)
end
function c249000165.sgcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000165.costfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c249000165.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c249000165.sgtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000165.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c249000165.sgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c249000165.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then 
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c249000165.drcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function c249000165.dfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost() and not c:IsCode(249000165)
end
function c249000165.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	return Duel.IsExistingMatchingCard(c249000165.dfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000165.dfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000165.drtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000165.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.Draw(p,d,REASON_EFFECT)
end
function c249000165.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end