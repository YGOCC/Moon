--Paintress Angelona
function c160009988.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160009988.splimit)
	e2:SetCondition(c160009988.splimcon)
	c:RegisterEffect(e2)
	--extra summon
	   local e3=Effect.CreateEffect(e3)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(2)
	Duel.RegisterEffect(e3)
end
function c160009988.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0xc50) then
			c160009988[tc:GetControler()]=true
		end
		tc=eg:GetNext()
	end
end
function c160009988.clear(e,tp,eg,ep,ev,re,r,rp)
	c160009988[0]=false
	c160009988[1]=false
end
function c160009988.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160009988.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160009988.con(e)
	return c160009988[e:GetHandlerPlayer()]
end
function c160009988.filter(e,c)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL)
end
