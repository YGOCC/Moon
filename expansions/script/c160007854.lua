--Paintress Goghi
function c160007854.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)

		--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc50))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)

   --extra summon
	   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTarget(c160007854.target)
	e4:SetTargetRange(1,0)
	e4:SetValue(2)
	c:RegisterEffect(e4)
  
	
end
function c160007854.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function c160007854.costfilter(c)
	return  c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c160007854.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160007854.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c160007854.costfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Release(g,REASON_COST)
end

	
function c160007854.target(e,c)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL)
end
