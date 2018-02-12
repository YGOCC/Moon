--carrier
function c42007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c42007.activate)
	c:RegisterEffect(e1)
		--reduce tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
		e2:SetDescription(aux.Stringid(42007,0))
	e2:SetCondition(c42007.ntcon)
	e2:SetTarget(c42007.nttg)
	c:RegisterEffect(e2)
end
function c42007.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end

function c42007.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4 and IsSetCard(0x264) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c42007.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c42007.nttg(e,c)
	return c:IsLevelAbove(5) and c:IsSetCard(0x264)
end