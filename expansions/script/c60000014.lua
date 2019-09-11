-- Coordination Between Driver & Blade

function c60000014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,60000014)
	e1:SetCondition(c60000014.condition)
	e1:SetTarget(c60000014.target)
	e1:SetOperation(c60000014.activate)
	c:RegisterEffect(e1)
end

function c60000014.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() 
		and ((tc:IsAttribute(ATTRIBUTE_WATER) and tc:IsRace(RACE_WARRIOR) and tc:IsType(TYPE_LINK)) or (tc:IsRace(RACE_FAIRY) and tc:IsLevelAbove(8)))
end
function c60000014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c60000014.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local atk=Duel.GetAttacker():GetBaseAttack()
	Duel.Damage(1-tp,atk/2,REASON_EFFECT)
end