function c353719701.initial_effect(c)
    --pendulum summon
	aux.EnablePendulumAttribute(c)
    --draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17626381,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c353719701.drop)
	e2:SetCondition(c353719701.condition2)
	e2:SetTarget(c353719701.target2)
	c:RegisterEffect(e2)
    --draw (pzone)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,353719701)
	e1:SetTarget(c353719701.destg)
	e1:SetOperation(c353719701.desop)
	c:RegisterEffect(e1)
	end
	function c353719701.condition2(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c353719701.cfilter,1,nil,tp)
end
function c353719701.cfilter(c,tp)
	return c:IsSetCard(0x9f) and c:IsFaceup()
end
function c353719701.target2(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c353719701.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c353719701.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c353719701.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c353719701.filter,tp,LOCATION_PZONE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
	function c353719701.desop(e,tp,eg,ep,ev,re,r,rp)
		local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	g=Duel.GetMatchingGroup(c353719701.filter,tp,LOCATION_PZONE,0,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c353719701.filter(c)
	return c:IsSetCard(0x9f)
	end