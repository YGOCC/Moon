--Autobot Brother - X-Brawn
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c115000009.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(115000009,0))
	Senya.AddAttackSE(c,aux.Stringid(115000009,1))
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c115000009.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c115000009.efilter)
	c:RegisterEffect(e2)
end
function c115000009.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201) and c:GetCode()~=115000009
end
function c115000009.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c115000009.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c115000009.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end