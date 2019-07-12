--Oscurità Irregolare - Angelo Oscuro
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),5,2,cid.ovfilter,aux.Stringid(id,0),2,cid.xyzop)
	c:EnableReviveLimit()
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(cid.athtg)
	e1:SetOperation(cid.athop)
	c:RegisterEffect(e1)
	--attach from GYs
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,0xff)
	e3:SetTarget(cid.disable)
	c:RegisterEffect(e3)
	local e3x=e3:Clone()
	e3x:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e3x)
	local e3y=Effect.CreateEffect(c)
	e3y:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3y:SetCode(EVENT_CHAIN_SOLVING)
	e3y:SetRange(LOCATION_MZONE)
	e3y:SetCondition(cid.discon)
	e3y:SetOperation(cid.disop)
	c:RegisterEffect(e3y)
	local e3z=Effect.CreateEffect(c)
	e3z:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3z:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3z:SetCode(EVENT_XYZATTACH)
	e3z:SetRange(LOCATION_MZONE)
	e3z:SetOperation(cid.flagop)
	c:RegisterEffect(e3z)
end
--filters
function cid.ovfilter(c)
	return c:IsFaceup() and c:IsRank(3) and c:IsType(TYPE_XYZ) and c:IsSetCard(0x4999)
end
function cid.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cid.fixfilter(c,e)
	return e:GetHandler():GetOverlayGroup():IsContains(c)
end
function cid.fixdisable(c,re)
	return c:IsCode(re:GetHandler():GetCode())
end
function cid.nfilter(c,cc)
	return c:IsCode(cc:GetCode())
end
--attach
function cid.athtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function cid.athop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then return end
	local td=Duel.GetDecktopGroup(tp,2)
	Duel.Overlay(e:GetHandler(),td)
end
--attach from GYs
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)>1 end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.TRUE),tp,LOCATION_GRAVE,LOCATION_GRAVE,2,2,nil)
	if sg:GetCount()>0 then
		Duel.Overlay(e:GetHandler(),sg)
	end
end
--negate
function cid.disable(e,c)
	local check=0
	local g=e:GetHandler():GetOverlayGroup()
	if g:GetCount()<=0 then return false end
	for tc in aux.Next(g) do
		if c:IsCode(tc:GetCode()) then
			check=check+1
		else
			check=check
		end
	end
	return (c:IsType(TYPE_SPELL+TYPE_TRAP) or (c:IsType(TYPE_MONSTER) and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)>0))) and check>0
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(cid.fixdisable,1,nil,re) and re:GetHandler():GetFlagEffect(id)<=0
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	local rx=re:GetHandler()
	if not e:GetHandler():GetOverlayGroup():IsExists(cid.fixdisable,1,nil,re) or rx:GetFlagEffect(id)>0 then return end
	Duel.NegateEffect(ev)
end
function cid.flagop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cid.fixfilter,1,nil,e) then return end
	local sg=eg:Filter(cid.fixfilter,nil,e)
	for tc in aux.Next(sg) do
		if tc:GetPreviousControler()~=tp then
			tc:RegisterFlagEffect(id,RESET_CHAIN,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
		end
	end
end