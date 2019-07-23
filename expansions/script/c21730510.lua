--Shiki of Dusk
--By Auramram
local s,id=GetID()
function s.initial_effect(c)
	--link procedure
	aux.AddLinkProcedure(c,nil,2,4,s.lcheck)
	c:EnableReviveLimit()
	--unaffected
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.econ)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--additional pendulum summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.penop)
	c:RegisterEffect(e3)
end
--link procedure
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x444)
end
--unaffected
function s.econ(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--additional pendulum summon
function s.pendvalue(e,c)
	return c:IsType(TYPE_NORMAL)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.pendvalue)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end