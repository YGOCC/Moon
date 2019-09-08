--Gorock Champion - Daruk
local s,id=GetID()
function s.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13409151,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_F)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.posop)
	c:RegisterEffect(e1)
	--summon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(s.sumcon)
	c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(s.condition)
	c:RegisterEffect(e3)
end

function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.estg)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e2)
end
function s.estg(e,c)
	return c:IsSetCard(0x711)
end

function s.sumcon(e,c,minc)
	if not c then return true end
	return false
end

function s.condition(e,c)
	return c:IsRace(RACE_ROCK)
end