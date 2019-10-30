--Moon Burst Extra Deck 1
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cid.spcon)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)	
end
function cid.spcfilter(c,tp)
	return c:IsCode(104242569) and c:IsCanRemoveCounter(tp,0x666,3,REASON_COST)
end
function cid.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cid.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+tc:GetCounter(0x666)
	end
	return ct>=3 and Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cid.spcfilter,tp,LOCATION_ONFIELD,0,nil,tp)
	if #g==1 then
		g:GetFirst():RemoveCounter(tp,0x666,3,REASON_COST)
	else
		for i=1,6 do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(40732515,2))
		local tg=Duel.SelectMatchingCard(tp,cid.spcfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
		tg:GetFirst():RemoveCounter(tp,0x666,3,REASON_COST)
		end
	end
end