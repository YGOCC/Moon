--Warring Kingdom Failed Diplomacy
function c11000608.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c11000608.condition)
	e1:SetCost(c11000608.cost)
	e1:SetTarget(c11000608.target)
	e1:SetOperation(c11000608.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
end
function c11000608.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c11000608.cfilter(c,tp)
	return c:IsSetCard(0x200) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c11000608.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000608.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c11000608.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c11000608.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c11000608.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
