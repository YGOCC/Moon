--Hollow Ego
local ref=_G['c'..28915126]
local id=28915126
function ref.initial_effect(c)
	aux.EnableCoronaNeo(c,2,2,ref.matfilter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(ref.actcon)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
end
function ref.matfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function ref.rmfilter(c,p)
	return Duel.IsPlayerCanRemove(p,c) and not c:IsType(TYPE_TOKEN)
end
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp) > Duel.GetLP(tp)
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local s=Duel.GetLP(1-tp) - Duel.GetLP(tp)
	if s<0 then s=Duel.GetLP(tp) - Duel.GetLP(1-tp) end
	local ct=math.floor(s/2000)
	if chk==0 then return ct>0 and g:IsExists(ref.rmfilter,1,nil,1-tp) and not Duel.IsPlayerAffectedByEffect(1-tp,30459350) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,0,0)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local p1=Duel.GetLP(tp)
	local p2=Duel.GetLP(1-tp)
	local s=p2-p1
	if s<0 then s=p1-p2 end
	local d=math.floor(s/2000)
	local g=Duel.GetMatchingGroup(ref.rmfilter,1-tp,LOCATION_ONFIELD,0,nil,1-tp)
	if g:GetCount() < d then d = g:GetCount() end
	if d > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,d,d,nil)
		if sg:GetCount()>0 then
			Duel.Remove(sg,POS_FACEUP,REASON_RULE)
		end
	end
end
