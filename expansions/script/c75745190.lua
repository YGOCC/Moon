--S.A.01 Head Hunter
function c75745190.initial_effect(c)
	c:EnableCounterPermit(0x85)
	c:SetCounterLimit(0x85,1)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--to defence
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c75745190.poscon)
	e2:SetOperation(c75745190.posop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75745190,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c75745190.addct)
	e3:SetOperation(c75745190.addc)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e6:SetDescription(aux.Stringid(71564252,1))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_SUMMON)
	e6:SetCondition(c75745190.condition)
	e6:SetCost(c75745190.cost)
	e6:SetTarget(c75745190.target)
	e6:SetOperation(c75745190.operation)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetDescription(aux.Stringid(75745190,2))
	e7:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e7)
end
function c75745190.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c75745190.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c75745190.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x85)
end
function c75745190.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x85,1)
	end
end
function c75745190.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0
end
function c75745190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x85,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x85,1,REASON_COST)
end
function c75745190.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c75745190.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end