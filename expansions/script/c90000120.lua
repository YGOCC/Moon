--Unreal Underwater Mermaid
function c90000120.initial_effect(c)
	--Gemini Summon
	aux.EnableDualAttribute(c)
	--Pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(aux.IsDualState)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	c:RegisterEffect(e1)
	--Pierce X2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c90000120.condition)
	e2:SetOperation(c90000120.operation)
	c:RegisterEffect(e2)
end
function c90000120.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return not c:IsDisabled() and c:IsDualState() and ep~=tp
		and tc:IsType(TYPE_DUAL) and tc:GetBattleTarget()~=nil and tc:GetBattleTarget():IsDefensePos()
end
function c90000120.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end