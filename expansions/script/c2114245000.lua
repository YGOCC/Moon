--Into the Void
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34646691,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function cid.filter(c,e,tp)
	return  (c:IsFaceup(e) or not c:IsFaceup(e)) and not c:IsSetCard(0x666)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cid.filter,nil,e)
	Duel.Exile(g,REASON_RULE)
end
