--Paintress Niemöllina
function c160005555.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(c160005555.reptg)
	e2:SetValue(c160005555.repval)
	e2:SetOperation(c160005555.repop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,160007855)
	--e3:SetCondition(c160005555.thcon)
	e3:SetCost(c160005555.thcost)
	e3:SetTarget(c160005555.thtg)
	e3:SetOperation(c160005555.thop)
	c:RegisterEffect(e3)
end
function c160005555.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160005555.splimcon(e)
	return not e:GetHandler():IsForbidden()
end
function c160005555.target(e,c)
	return c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL)
end
function c160005555.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xc50)
end
function c160005555.cfilter(c)
	return  c:IsType(TYPE_NORMAL) and c:IsFaceup () and c:IsAbleToRemoveAsCost()
end
function c160005555.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160005555.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160005555.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160005555.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	 Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c160005555.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c160005555.repfilter(c,tp)
	return c:IsFaceup() and  c:IsSetCard(0xc50) and c:IsLocation(LOCATION_PZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c160005555.repfilterxxl(c,e)
	return not c:IsType(TYPE_EFFECT)
		and c:IsAbleToRemove()
end
function c160005555.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c160005555.repfilter,1,e:GetHandler(),tp)  and Duel.IsExistingMatchingCard(c160005555.repfilterxxl,tp,LOCATION_EXTRA,0,1,c,e) end
   if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c160005555.repfilterxxl,tp,LOCATION_EXTRA,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c160005555.repval(e,c)
	return c160005555.repfilter(c,e:GetHandlerPlayer())
end
function c160005555.repop(e,tp,eg,ep,ev,re,r,rp)
	  local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	  Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
