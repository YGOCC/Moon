--Autobot Leader - Optimus Prime
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c115000001.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(115000001,0))
	Senya.AddAttackSE(c,aux.Stringid(115000001,1))
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c115000001.spcon)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c115000001.tg)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(c115000001.valcon)
	c:RegisterEffect(e3)
end
function c115000001.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c115000001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c115000001.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c115000001.tg(e,c)
	return c:IsSetCard(0x201) and c~=e:GetHandler()
end
function c115000001.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end