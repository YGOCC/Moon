--Draw Magician
function c249000172.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,2490001721)
	e2:SetTarget(c249000172.destg)
	e2:SetOperation(c249000172.desop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,2490001722)
	e3:SetCondition(c249000172.drcon)
	e3:SetTarget(c249000172.drtg)
	e3:SetOperation(c249000172.drop)
	c:RegisterEffect(e3)
end
function c249000172.cfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c249000172.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
	and Duel.IsExistingMatchingCard(c249000172.cfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c249000172.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c249000172.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsReason(REASON_EFFECT)
end
function c249000172.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c249000172.cfilter,1,nil,tp)
end
function c249000172.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)
	if ct > 2 then ct=2 end
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c249000172.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c249000172.filter,tp,LOCATION_MZONE,0,nil)
	if ct > 2 then ct=2 end
	Duel.Draw(tp,ct,REASON_EFFECT)
end
