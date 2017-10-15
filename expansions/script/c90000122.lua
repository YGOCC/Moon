--Unreal Lighting Manager
function c90000122.initial_effect(c)
	--Gemini Summon
	aux.EnableDualAttribute(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Normal Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(2)
	e1:SetCost(c90000122.cost)
	e1:SetTarget(c90000122.target)
	e1:SetOperation(c90000122.operation)
	c:RegisterEffect(e1)
	--Untargetable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsDualState,true))
	e2:SetCondition(aux.IsDualState)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Battle Indestructable
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e3)
end
function c90000122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c90000122.filter(c)
	return c:IsType(TYPE_DUAL) and c:IsSummonable(true,nil)
end
function c90000122.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000122.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c90000122.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000122.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSummonable(true,nil) then
		Duel.Summon(tp,tc,true,nil)
	end
end