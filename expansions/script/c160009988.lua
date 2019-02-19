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
   --tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160009988)
	e3:SetTarget(c160009988.thtg)
	e3:SetOperation(c160009988.thop)
	c:RegisterEffect(e3)
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


function c160009988.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xc50)
end
function c160009988.filter(c)
	return  not c:IsType(TYPE_EFFECT)and c:IsLevelAbove(2)and c:IsAbleToHand()
end

function c160009988.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c160009988.psfilter(c)
	return  c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() 
end
function c160009988.thop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
  
	local g=Duel.GetMatchingGroup(c160009988.psfilter,tp,LOCATION_DECK,0,nil)
		if g:GetClassCount(Card.GetCode)<2 then return end
	local ct=0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then ct=ct+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then ct=ct+1 end
	if ct>0 and g:GetCount()>0   then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			sc=sg:GetNext()
		end

	end
end



