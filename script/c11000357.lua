--Arclight in Darkness
function c11000357.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,11000357)
	e1:SetCondition(c11000357.condition)
	e1:SetTarget(c11000357.target)
	e1:SetOperation(c11000357.activate)
	c:RegisterEffect(e1)
end
function c11000357.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x202)
end
function c11000357.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c11000357.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c11000357.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x202) and c:IsType(TYPE_MONSTER) and not c:IsCode(11000360)
end
function c11000357.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c11000357.drfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)
end
function c11000357.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c11000357.cfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT) then
		local tc=Duel.GetOperatedGroup()
		local ct=tc:FilterCount(c11000357.drfilter,nil)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
