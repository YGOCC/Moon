--Sweetiehard Gagged!
function c500310100.initial_effect(c)
  --Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c500310100.condition1)
	e1:SetCost(c500310100.cost)
	e1:SetTarget(c500310100.target1)
	e1:SetOperation(c500310100.activate1)
	c:RegisterEffect(e1)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c500310100.condition2)
	e2:SetCost(c500310100.cost)
	e2:SetTarget(c500310100.target2)
	e2:SetOperation(c500310100.activate2)
	c:RegisterEffect(e2)
end
function c500310100.cfilter(c)
	return c:IsRace(RACE_BEASTWARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c500310100.cfilter(c)
	return c:IsFaceup()  and c:IsRace(RACE_BEASTWARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c500310100.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c500310100.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c500310100.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c500310100.condition1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return Duel.GetCurrentChain()==0 and g:GetCount()>0 and g:FilterCount(c500310100.cfilter,nil)==g:GetCount()
end
function c500310100.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c500310100.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c500310100.condition2(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and g:GetCount()>0 and g:FilterCount(c500310100.cfilter,nil)==g:GetCount()
end
function c500310100.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c500310100.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
local c=e:GetHandler()
	   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c500310100.distg)
		e1:SetLabel(re:GetHandler():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c500310100.discon)
		e2:SetOperation(c500310100.disop)
		e2:SetLabel(re:GetHandler():GetCode())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
end
function c500310100.aclimit(e,re,tp)
	return re:IsHasType(TYPE_MONSTER) and re:GetHandler():IsCode(e:GetLabel())
end

   function c500310100.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c500310100.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code)
end
function c500310100.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
	