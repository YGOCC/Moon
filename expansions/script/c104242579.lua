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
		--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetTarget(cid.rmtg)
	c:RegisterEffect(e2)
		--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cid.tgcon)
	e4:SetValue(aux.imval1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
	
end
function cid.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_RITUAL)
end
function cid.tgcon(e)
	return Duel.IsExistingMatchingCard(cid.tgfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end



function cid.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
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




function cid.spcfilter2(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.spcon2(e,c)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.spcfilter2,tp,LOCATION_REMOVED,0,1,nil) 
	and Duel.GetLocationCountFromEx(tp,LOCATION_MZONE)>0 end
end
function cid.spop2(e,tp,eg,ep,ev,re,r,rp,c)
local g=Duel.SelectMatchingCard(tp,spcfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		Duel.Exile(g,REASON_RULE)
end
end