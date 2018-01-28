--Paintress Angelona
function c160009988.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c160009988.atktg)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--extra summon
	   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c160009988.target)
	e4:SetTargetRange(1,0)
	e4:SetValue(2)
	c:RegisterEffect(e4)
end
function c160009988.atktg(e,c)
	return c:IsType(TYPE_EFFECT)
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
function c160009988.target(e,c)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL)
end

