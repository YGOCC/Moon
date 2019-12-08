--Moon's Dream: KeyBlade's Chosen
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
	e1:SetCondition(cid.spcon2)
	e1:SetOperation(cid.spop3)
	c:RegisterEffect(e1)
--unicore
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cid.distg)
	c:RegisterEffect(e3)
end
--Unicore
function cid.distg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
--summon condition
function cid.spcfilter2(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.spcon2(e,c)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,5,nil)
end
function cid.spop3(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
		local tc=Duel.GetFirstMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,nil,e,tp)
	if tc then
		Duel.Exile(tc,REASON_RULE)
end
end
end
end
end
end