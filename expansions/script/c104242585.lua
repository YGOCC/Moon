--Fragment of a Memory
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Activate
--	local e1=Effect.CreateEffect(c)
--	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
--	e1:SetCode(EVENT_ADJUST)
--	e1:SetRange(LOCATION_REMOVED)
--	e1:SetOperation(cid.raisevent)
--	c:RegisterEffect(e1)
		--draw
--	local e2=Effect.CreateEffect(c)
--	e2:SetDescription(aux.Stringid(67048711,0))
--	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
--	e2:SetCountLimit(1,id)
--	e2:SetCode(EVENT_CUSTOM+id)
--	e2:SetRange(LOCATION_REMOVED)
--	e2:SetOperation(cid.boss)
--	c:RegisterEffect(e2)
		--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cid.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cid.bossfilter(c)
	return c:IsFaceup() and c:IsCode(id)
end
function cid.boss(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(cid.bossfilter,tp,LOCATION_REMOVED,0,nil)==7 then
	end
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(cid.bossfilter,tp,LOCATION_REMOVED,0,nil)
	--g:SetCardData(CARDDATA_TYPE, g:GetType()+TYPE_TOKEN)
	Duel.Exile(g,REASON_RULE)
	
	local sc=Duel.CreateToken(tp,57774843)
	Duel.MoveToField(sc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)

end
function cid.raisevent(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(cid.bossfilter,tp,LOCATION_REMOVED,0,nil)==7 then
		Duel.RaiseSingleEvent(e:GetHandler(),EVENT_CUSTOM+id,e,0,0,0,0)
	end
end
function cid.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
