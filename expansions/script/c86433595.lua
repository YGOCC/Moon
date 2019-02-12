--Inf-fector:\Undefined
--Script by XGlitchy30
function c86433595.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--random swap
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c86433595.swapcon)
	e1:SetOperation(c86433595.swapop)
	c:RegisterEffect(e1)
	--apply effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86433595,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,86433595+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c86433595.actcon)
	e2:SetOperation(c86433595.actop)
	c:RegisterEffect(e2)
	--register effect
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	ge:SetCode(EVENT_CHAINING)
	ge:SetRange(LOCATION_ONFIELD+LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_OVERLAY)
	ge:SetLabelObject(e2)
	ge:SetCondition(c86433595.regcon)
	ge:SetOperation(c86433595.regop)
	c:RegisterEffect(ge)
	if not c86433595.global_check then
		c86433595.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetLabelObject(e2)
		ge0:SetCondition(c86433595.regcon2)
		ge0:SetOperation(c86433595.regop)
		Duel.RegisterEffect(ge0,0)
	end
end
local normaltg=nil
local normalop=nil
c86433595.local_list={nil,normaltg,normalop,nil,nil}
--register effect
function c86433595.regcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_MZONE or loc==LOCATION_SZONE or loc==LOCATION_FZONE or loc==LOCATION_PZONE) and not rc:IsCode(86433595)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)
end
function c86433595.regcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc==LOCATION_MZONE or loc==LOCATION_SZONE or loc==LOCATION_FZONE or loc==LOCATION_PZONE) and not rc:IsCode(86433595)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)
		and e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c86433595.regop(e,tp,eg,ep,ev,re,r,rp)
	--copy exception
	local lclist=c86433595.local_list
	--------
	local ee=e:GetLabelObject()
	local cg=re:GetCategory()
	local prop=re:GetProperty()
	local lab=re:GetLabel()
	local lobj=re:GetLabelObject()
	local tg=re:GetTarget()
	local op=re:GetOperation()
	if cg then
		ee:SetCategory(cg)
	else
		ee:SetCategory(0)
	end
	if prop then
		ee:SetProperty(prop)
	else
		ee:SetProperty(0)
	end
	if lab then
		ee:SetLabel(lab)
	else
		ee:SetLabel(0)
	end
	if lobj then
		ee:SetLabelObject(lobj)
	else
		ee:SetLabelObject(nil)
	end
	if tg then
		if lclist and e:GetHandler():GetOriginalCode()~=86433595 then
			lclist[2]=tg
			ee:SetTarget(lclist[2])
		else
			normaltg=tg
			ee:SetTarget(normaltg)
		end
	else
		if lclist and e:GetHandler():GetOriginalCode()~=86433595 then
			lclist[2]=nil
		else
			normaltg=nil
		end
		ee:SetTarget(c86433595.acttg)
	end
	if op then
		if lclist and e:GetHandler():GetOriginalCode()~=86433595 then
			lclist[3]=op
			ee:SetTarget(lclist[3])
		else
			normalop=op
			ee:SetOperation(normalop)
		end
	else
		if lclist and e:GetHandler():GetOriginalCode()~=86433595 then
			lclist[3]=nil
		else
			normalop=nil
		end
		ee:SetOperation(c86433595.actop)
	end
end
---
function c86433595.choosecod(param,tc)
	local tab={EFFECT_CHANGE_ATTRIBUTE,EFFECT_CHANGE_LEVEL_FINAL,EFFECT_CHANGE_RACE,EFFECT_SET_ATTACK_FINAL,EFFECT_SET_DEFENSE_FINAL}
	if tc:IsType(TYPE_XYZ) then tab[2]=EFFECT_CHANGE_RANK_FINAL end
	return tab[param]
end
function c86433595.chooseval(param,tc)
	if param==1 then
		return tc:GetAttribute()
	elseif param==2 then
		return c86433595.lvfunction(tc)
	elseif param==3 then
		return tc:GetRace()
	elseif param==4 then
		return tc:GetAttack()
	else
		return tc:GetDefense()
	end
end
function c86433595.lvfunction(tc)
	if tc:IsType(TYPE_XYZ) then
		return tc:GetRank()
	elseif tc:GetLevel()>0 then
		return tc:GetLevel()
	else
		return 0
	end
end
--filters
function c86433595.startgroup(c,e)
	return c:IsFaceup() and not c:IsImmuneToEffect(e)
end
function c86433595.chkrandom(c,k)
	return c:GetFlagEffect(86433595)>0 and c:GetFlagEffectLabel(86433595)==k
end
function c86433595.excfilter(c,g)
	return g:IsContains(c)
end
--random swap
function c86433595.swapcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c86433595.startgroup,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil,e)
end
function c86433595.swapop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,86433595)
	Duel.Hint(HINT_CARD,1,86433595)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c86433595.startgroup,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if g:GetCount()<=1 then return end
	local ct=1
	for i in aux.Next(g) do
		i:RegisterFlagEffect(86433595,RESET_EVENT+EVENT_CUSTOM+86433595,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
		i:SetFlagEffectLabel(86433595,ct)
		ct=ct+1
	end
	for param=1,5 do
		local cg=g:Clone()
		cg:KeepAlive()
		local check=true
		while check do
			if math.fmod(cg:GetCount(),2)~=0 then
				local rm=math.random(1,ct)
				local chkr=cg:Filter(c86433595.chkrandom,nil,rm)
				if chkr:GetCount()>0 then
					cg:RemoveCard(chkr:GetFirst())
				end
			end
			if cg:GetCount()>=2 then
				local rd=Group.CreateGroup()
				rd:KeepAlive()
				if cg:GetCount()>2 then
					for i2=1,2 do
						local check2=true
						while check2 do
							local k=math.random(1,ct)
							local chk=cg:Filter(c86433595.chkrandom,nil,k)
							if chk:GetCount()>0 then
								rd:AddCard(chk:GetFirst())
								cg:RemoveCard(chk:GetFirst())
								check2=false
							end
						end
					end
				else
					rd:AddCard(cg:GetFirst())
					rd:AddCard(cg:GetNext())
					cg:RemoveCard(cg:GetFirst())
					cg:RemoveCard(cg:GetFirst())
				end
				local tc=rd:GetFirst()
				local td=rd:GetNext()
				local fixlv=0
				local code1,code2=c86433595.choosecod(param,tc),c86433595.choosecod(param,td)
				local val1,val2=c86433595.chooseval(param,tc),c86433595.chooseval(param,td)
				if param==2 and not ((tc:IsType(TYPE_XYZ) or tc:GetLevel()>0) and (td:IsType(TYPE_XYZ) or td:GetLevel()>0)) then fixlv=1 end
				if fixlv==0 then
					--effects
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(code1)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(val2)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
					local e1x=e1:Clone(c)
					e1x:SetCode(code2)
					e1x:SetValue(val1)
					td:RegisterEffect(e1x)
				end
			else
				check=false
			end
		end
	end
end	
--apply effect
function c86433595.actcon(e,tp,eg,ep,ev,re,r,rp)
	--copy exception
	local lclist=c86433595.local_list
	--------
	return (e:GetHandler():GetOriginalCode()~=86433595 and lclist and lclist[3]~=nil) or normalop~=nil
end
function c86433595.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c86433595.actop(e,tp,eg,ep,ev,re,r,rp)
	return
end
