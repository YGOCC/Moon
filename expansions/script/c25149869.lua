--Stellallineamento Divino del Sistema Perfetto
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,-1,nil,nil,cid.penalty)
	--Ability: Great Conjunction
	local ab=Effect.CreateEffect(c)
	ab:SetType(EFFECT_TYPE_FIELD)
	ab:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ab:SetCode(EFFECT_DISABLE_FIELD)
	ab:SetRange(LOCATION_SZONE)
	ab:SetLabel(1000)
	ab:SetCondition(cid.abcon)
	ab:SetOperation(cid.abop)
	c:RegisterEffect(ab)
	local ab2=ab:Clone()
	ab2:SetLabel(2000)
	c:RegisterEffect(ab2)
	local ab3=ab:Clone()
	ab3:SetLabel(3000)
	c:RegisterEffect(ab3)
	local ab4=ab:Clone()
	ab4:SetLabel(4000)
	c:RegisterEffect(ab4)
	local ab5=ab:Clone()
	ab5:SetLabel(5000)
	c:RegisterEffect(ab5)
	--Master Summon Custom Proc
	local ms=Effect.CreateEffect(c)
	ms:SetDescription(aux.Stringid(id,1))
	ms:SetType(EFFECT_TYPE_FIELD)
	ms:SetCode(EFFECT_SPSUMMON_PROC_G)
	ms:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ms:SetRange(LOCATION_SZONE)
	ms:SetCondition(cid.mscon)
	ms:SetOperation(cid.mscustom)
	ms:SetValue(SUMMON_TYPE_MASTER+SUMMON_TYPE_XYZ)
	c:RegisterEffect(ms)
	--Monster Effects--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cid.valcon)
	e1:SetOperation(cid.valop)
	c:RegisterEffect(e1)
end
--filters
function cid.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(0) and not c:IsLevel(e:GetLabel())
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER)
		and not (c:IsStatus(STATUS_BATTLE_DESTROYED) or c:IsStatus(STATUS_LEAVE_CONFIRMED) or c:IsStatus(STATUS_SUMMON_DISABLED) or c:IsStatus(STATUS_SUMMONING))
end
function cid.column(c,seq)
	if not seq then return false end
	if seq==1 then
		return c:GetSequence()==seq or c:GetSequence()==5
	elseif seq==3 then
		return c:GetSequence()==seq or c:GetSequence()==6
	else
		return seq>=0 and seq<=4 and c:GetSequence()==seq
	end
end
function cid.rmcolumn(c)
	if not c:IsAbleToRemove() then return false end
	return c:GetColumnGroup():IsExists(cid.starlign,1,nil)
end
function cid.starlign(c)
	return c:IsFaceup() and c:IsSetCard(0x2595) and c:IsType(TYPE_MONSTER)
end
--Deck Master Functions
function cid.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local ct={}
	for i=1,12 do
		table.insert(ct,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINGMSG_LVRANK)
	local lv=Duel.AnnounceNumber(tp,table.unpack(ct))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetLabel(lv)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cid.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
end
function cid.penalty(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(cid.damcon)
	e1:SetOperation(cid.damop)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,5)
	else
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,4)
	end
	Duel.RegisterEffect(e1,tp)
end
function cid.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_DRAW and Duel.GetTurnPlayer()==tp
		and eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and bit.band(r,REASON_RULE)>0
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_MONSTER)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if #og<=0 then return end
		local dam=0
		for tc in aux.Next(og) do
			if tc:IsLevelAbove(0) then
				dam=dam+tc:GetLevel()*400
			end
		end
		if dam>0 then
			Duel.Damage(tp,dam,REASON_EFFECT)
		end
	end
end
--Master Summon Custom Proc
---proc filters---
function cid.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2595) and c:IsLevel(4)
end
function cid.fspfilter(c,cc)
	return cid.matfilter(c) and c:IsCanBeXyzMaterial(cc)
end
function cid.spfilter1(c,tp,g)
	return g:IsExists(cid.spfilter2,1,c,tp,g,Group.FromCards(c),c:GetAttribute(),0)
end
function cid.spfilter2(c,tp,g,mg,attr,link)
	if not mg:IsContains(c) then mg:AddCard(c) end
	if Duel.IsExistingMatchingCard(cid.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,mg,tp) then
		link=1
	end
	if c:IsAttribute(attr) then mg:RemoveCard(c) return false end
	if (Duel.GetLocationCountFromEx(tp,tp,mg)>0 and link>0) or g:IsExists(cid.spfilter2,1,mg,tp,g,mg,c:GetAttribute()+attr,0) then
		mg:RemoveCard(c)
		return true
	else
		mg:RemoveCard(c)
		return false
	end
end
function cid.lkfilter(c,tp)
	local zone=c:GetLinkedZone(tp) 
	return c:IsType(TYPE_LINK) and zone>0
end
--------
function cid.mscon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cid.fspfilter,tp,LOCATION_MZONE,0,nil,c)
	return g:IsExists(cid.spfilter1,1,nil,tp,g)
end
function cid.mscustom(e,tp,eg,ep,ev,re,r,rp,c)
	local g0=Duel.GetMatchingGroup(cid.fspfilter,tp,LOCATION_MZONE,0,nil)
	if #g0<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g0:FilterSelect(tp,cid.spfilter1,1,1,nil,tp,g0)
	local ok,tc1=0,g1:GetFirst()
	local sg,attr=Group.FromCards(tc1),tc1:GetAttribute()
	sg:KeepAlive()
	if tc1 then
		while ok<=0 do
			local mg=sg:Clone()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local g2=g0:FilterSelect(tp,cid.spfilter2,1,1,mg,tp,g0,mg,attr,0)
			attr=bit.bor(g2:GetFirst():GetAttribute(),attr)
			sg:Merge(g2)
			mg=sg:Clone()
			if g0:IsExists(cid.spfilter2,1,sg,tp,g0,mg,attr,0) then
				if Duel.GetLocationCountFromEx(tp,tp,sg)>0 then
					if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
						ok=ok
					else
						ok=1
					end
				else
					ok=ok
				end
			else
				ok=1
			end
		end
		c:SetMaterial(sg)
		Duel.Overlay(c,sg)
		sg:DeleteGroup()
	end
	--choose zone
	local g=Duel.GetMatchingGroup(cid.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	g:KeepAlive()
	local zone=0
	local flag=0
	for i in aux.Next(g) do
		zone=bit.bor(zone,i:GetLinkedZone(tp)&0xff)
		local _,flag_tmp=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
		flag=(~flag_tmp)&0x7f
	end
	local fzone=0
	if c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_MASTER+SUMMON_TYPE_XYZ,tp,true,false,POS_FACEUP,tp,zone) then
		fzone=fzone|(flag<<(tp==tp and 0 or 16))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local sel_zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0x00ff00ff&(~fzone))
	Duel.SpecialSummon(c,SUMMON_TYPE_MASTER+SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP,sel_zone)
	c:RegisterFlagEffect(3340,RESET_EVENT+EVENT_CUSTOM+3340,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	return
end
--Ability: Great Conjunction
function cid.abcon(e)
	local lab=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER)
	local sg=Duel.GetMatchingGroup(cid.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	if not aux.CheckDMActivatedState(e) or #g>3 or #sg<=0 then return false end
	if lab==1000 then
		return sg:IsExists(cid.column,1,nil,0)
	elseif lab==2000 then
		return sg:IsExists(cid.column,1,nil,1)
	elseif lab==3000 then
		return sg:IsExists(cid.column,1,nil,2)
	elseif lab==4000 then
		return sg:IsExists(cid.column,1,nil,3)
	elseif lab==5000 then
		return sg:IsExists(cid.column,1,nil,4)
	else
		return false
	end
end
function cid.abop(e,tp,eg,ep,ev,re,r,rp)
	local lab=e:GetLabel()
	local zone=0
	if lab==1000 then
		zone=bit.lshift(0x1,20)
	elseif lab==2000 then
		zone=bit.lshift(0x1,19)
	elseif lab==3000 then
		zone=bit.lshift(0x1,18)
	elseif lab==4000 then
		zone=bit.lshift(0x1,17)
	elseif lab==5000 then
		zone=bit.lshift(0x1,16)
	else
		zone=zone
	end
	return zone
end
--Monster Effects--
function cid.effcon(e)
	return e:GetHandler():GetMaterialCount()>=e:GetLabel()
end
function cid.valcon(e)
	return e:GetHandler():GetSummonType()&SUMMON_TYPE_XYZ~=0
end
function cid.valop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local matc=c:GetMaterialCount()
	if matc>=2 then
		--atk boost
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetCondition(cid.atkcon)
		e1:SetValue(cid.atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if matc>=3 then
			--banish
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(id,2))
			e2:SetCategory(CATEGORY_REMOVE)
			e2:SetType(EFFECT_TYPE_IGNITION)
			e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCountLimit(1)
			e2:SetTarget(cid.rmtg)
			e2:SetOperation(cid.rmop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			if matc>=4 then
				--immune
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
				e3:SetRange(LOCATION_MZONE)
				e3:SetCode(EFFECT_IMMUNE_EFFECT)
				e3:SetValue(cid.efilter)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e3)
				--if matc>=5 then
					--boot divine starlignments
					--COMING SOON
			end
		end
	end
end
--atk boost
function cid.atkcon(e)
	return e:GetHandler():IsType(TYPE_XYZ) and e:GetHandler():GetOverlayCount()>0
end
function cid.atkval(e)
	return e:GetHandler():GetOverlayCount()*500
end
--banish
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cid.rmcolumn(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.rmcolumn,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cid.rmcolumn,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
--immune
function cid.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner() and not te:GetOwner():IsAttribute(ATTRIBUTE_DEVINE)
end
--boot divine starlignments
--COMING SOON