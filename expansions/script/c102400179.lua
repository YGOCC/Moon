--created & coded by Lyris, art at https://images-na.ssl-images-amazon.com/images/I/615xevWUOuL._UY741_.jpg
--ニュートリックス・ナイトヴェール
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetCondition(function(e,tp) return cid.zones(e,tp)>0 end)
	e1:SetValue(cid.zones)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(function(e,tc) return c:GetLinkedGroup():IsContains(tc) and tc:IsSetCard(0xd10) end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetValue(function(e,te) return e:GetOwnerPlayer()~=te:GetOwnerPlayer() end)
	c:RegisterEffect(e4)
	e3:SetLabelObject(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(function(e) local g=e:GetHandler():GetLinkedGroup() g:KeepAlive() e:SetLabelObject(g) end)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(cid.disop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
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
	return zone
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	local g,e1,e0,e3=e:GetLabelObject():GetLabelObject():Filter(Card.IsLocation,nil,LOCATION_MZONE),Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-0x10e0000)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	for tc in aux.Next(g) do
		e0,e3=e1:Clone(),e2:Clone()
		tc:RegisterEffect(e0)
		tc:RegisterEffect(e3)
	end
	g:DeleteGroup()
end
