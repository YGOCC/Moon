--created & coded by Lyris, art at https://images-na.ssl-images-amazon.com/images/I/615xevWUOuL._UY741_.jpg
--ニュートリックス・ナイトヴェール
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetRange(LOCATION_HAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetCondition(function(e) return EFFECT_MUST_USE_SZONE end)
	e0:SetTarget(function(e,te,tp) return te:GetHandler()==e:GetHandler() end)
	e0:SetCost(cid.costchk)
	e0:SetOperation(cid.costop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabelObject(e0)
	e1:SetCost(cid.cost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e2)
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd10)
end
function cid.zones(e,tp)
	local c,g,zone,seq=e:GetHandler(),Duel.GetFieldGroup(tp,LOCATION_MZONE,0),0
	for tc in aux.Next(g) do
		seq=tc:GetSequence()
		if seq>0 and seq<=4 and (Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) or Duel.GetFieldCard(tp,LOCATION_SZONE,seq-1)==c) then zone=bit.replace(zone,0x1,seq-1) end
		if seq<4 and (Duel.CheckLocation(tp,LOCATION_SZONE,seq+1) or Duel.GetFieldCard(tp,LOCATION_SZONE,seq+1)==c) then zone=bit.replace(zone,0x1,seq+1) end
	end
	return zone<<8
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone,seq=cid.zones(e,tp)>>8,c:GetSequence()
	if chk==0 then return not c:IsLocation(LOCATION_SZONE) and zone>0 or bit.extract(zone,seq)>0 end
	local ef=e:GetLabelObject():GetLabelObject()
	if ef then ef:Reset() end
	if not EFFECT_MUST_USE_SZONE and c:IsStatus(STATUS_ACT_FROM_HAND)
		and bit.extract(zone,seq)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,(zone&~2^seq~0xff)<<8)
		Duel.MoveSequence(c,math.log(s>>8,2))
	end
end
function cid.costchk(e,te_or_c,tp)
	local zone=cid.zones(e,tp)
	return zone>0
end
function cid.costop(e,tp,eg,ep,ev,re,r,rp)
	local flag=cid.zones(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_SZONE)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(flag)
	e1:SetCountLimit(1)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
end
