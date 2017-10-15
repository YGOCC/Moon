--Midnight Ahri
function c11000553.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000553,0))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c11000553.negcon)
	e2:SetCost(c11000553.cost)
	e2:SetTarget(c11000553.negtg)
	e2:SetOperation(c11000553.negop)
	c:RegisterEffect(e2)
end
function c11000553.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c11000553.cfilter(c,tp)
	return c:IsSetCard(0x1FE) and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c11000553.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000553.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c11000553.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c11000553.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11000553.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end