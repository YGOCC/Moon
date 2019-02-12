--Requirement Request
--Script by XGlitchy30
function c86433602.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,86433602+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c86433602.activate)
	c:RegisterEffect(e1)
	--avoid cost payment
	local e2x=Effect.CreateEffect(c)
	e2x:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2x:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2x:SetCode(EVENT_TO_GRAVE)
	e2x:SetOperation(c86433602.updatecount)
	c:RegisterEffect(e2x)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c86433602.adjustcon)
	e2:SetOperation(c86433602.changecost)
	c:RegisterEffect(e2)
end
c86433602.global_count=0
local local_count=0
local normalcon=nil
local normaltg=nil
local normalop=nil
c86433602.local_list={normalcon,normaltg,normalop,local_count,nil}
--change operation
function c86433602.repop(e,tp,eg,ep,ev,re,r,rp)
	--copy exception
	local lclist=c86433602.local_list
	--------
	local nc,np=nil,nil
	if lclist and e:GetHandler():GetOriginalCode()~=86433602 then nc,np=lclist[1],lclist[3] else nc,np=normalcon,normalop end
	if nc(e,tp,eg,ep,ev,re,r,rp) then
		np(e,tp,eg,ep,ev,re,r,rp)
		e:SetOperation(np)
	else
		Duel.Hint(HINT_CARD,e:GetHandlerPlayer(),86433602)
		e:SetOperation(np)
	end
end
--filters
function c86433602.checkfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
--Activate
function c86433602.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--effects condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(c86433602.effcon)
	e1:SetOperation(c86433602.effop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--target protection
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA)
	e2:SetTarget(c86433602.tgtg)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
--update count
function c86433602.updatecount(e,tp,eg,ep,ev,re,r,rp)
	c86433602.global_count=c86433602.global_count+1
	local_count=c86433602.global_count
	if e:GetHandler():GetFlagEffect(80433602)<=0 then
		e:GetHandler():RegisterFlagEffect(80433602,RESET_EVENT+EVENT_CUSTOM+86433602,EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
	end
	e:GetHandler():SetFlagEffectLabel(80433602,local_count)
end
--avoid cost payment
function c86433602.flagcheck(c)
	return c:GetFlagEffect(86433602)<=0
end
function c86433602.flaglabel(c,ct)
	return c:IsCode(86433602) and c:GetFlagEffect(80433602)>0 and c:GetFlagEffectLabel(80433602)<ct
end
function c86433602.adjustcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c86433602.flaglabel,tp,LOCATION_GRAVE,0,1,e:GetHandler(),local_count)
end
function c86433602.changecost(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	if not c:IsLocation(LOCATION_GRAVE) or not c:IsControler(p) or Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER) then return end
	local g=Duel.GetMatchingGroup(c86433602.flagcheck,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_OVERLAY+LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	for rc in aux.Next(g) do
		if rc:GetFlagEffect(86433602)<=0 then
			rc:RegisterFlagEffect(86433602,RESET_EVENT+EVENT_CUSTOM+86433602,EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
			local egroup={rc:IsHasEffect(EFFECT_DEFAULT_CALL)}
			for _,te1 in ipairs(egroup) do
				local ce=te1:GetLabelObject()
				if not ce then
					te1:Reset()
				end
				if ce then
					local cond=ce:GetCondition()
					local cost=ce:GetCost()
					if cost then
						local e1=ce:Clone()
						if cond then
							e1:SetCondition(aux.ModifyCon(cond,function (e,tp,eg,ep,ev,re,r,rp) return not cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(c86433602.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) end))
						else
							e1:SetCondition(function (e,tp,eg,ep,ev,re,r,rp) return not cost(e,tp,eg,ep,ev,re,r,rp,0) and Duel.IsExistingMatchingCard(c86433602.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) end)
						end
						e1:SetCost(function (e,tp,eg,ep,ev,re,r,rp,chk)
										if chk==0 then return true end
									end)
						rc:RegisterEffect(e1)
						local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_FIELD)
						e2:SetCode(EFFECT_ACTIVATE_COST)
						e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						e2:SetLabelObject(ce)
						e2:SetTargetRange(1,0)
						e2:SetCondition(c86433602.costcon)
						e2:SetTarget(c86433602.costtarget)
						e2:SetOperation(c86433602.costop)
						Duel.RegisterEffect(e2,tp)
						local reset=Effect.CreateEffect(c)
						reset:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						reset:SetProperty(EFFECT_FLAG_DELAY)
						reset:SetCode(EVENT_ADJUST)
						reset:SetLabel(p)
						reset:SetCountLimit(1)
						reset:SetCondition(c86433602.resetcostcon)
						reset:SetOperation(aux.ResetEffectFunc(ce,'cost',cost))
						Duel.RegisterEffect(reset,tp)
						local reset2=reset:Clone()
						reset2:SetLabelObject(rc)
						reset2:SetOperation(c86433602.resetflag)
						Duel.RegisterEffect(reset2,tp)
						local reset3=reset:Clone()
						reset3:SetLabelObject(e1)
						reset3:SetOperation(c86433602.reseteff)
						Duel.RegisterEffect(reset3,tp)
						local reset4=reset:Clone()
						reset4:SetLabelObject(e2)
						reset4:SetOperation(c86433602.reseteff)
						Duel.RegisterEffect(reset4,tp)
					end
				end
			end
		end
	end
end
function c86433602.resetcostcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_GRAVE) or not c:IsControler(e:GetLabel()) or Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER)
end
function c86433602.resetflag(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c:GetFlagEffect(86433602)>0 then
		c:ResetFlagEffect(86433602)
	end
	e:Reset()
end
function c86433602.reseteff(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	c:Reset()
	e:Reset()
end
--Effects Conditions
function c86433602.altcon(e,tp,eg,ep,ev,re,r,rp)
	return not cost(e,tp,eg,ep,ev,re,r,rp,0)
end
function c86433602.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)
end
function c86433602.effop(e,tp,eg,ep,ev,re,r,rp)
	--copy exception
	local lclist=c86433602.local_list
	--------
	local con=re:GetCondition()
	local op=re:GetOperation()
	if not con or not op then return end
	if lclist and e:GetHandler():GetOriginalCode()~=86433602 then
		normalcon=con
		normalop=op
	else
		lclist[1]=con
		lclist[3]=op
	end
	re:SetOperation(c86433602.repop)
end
--target protection
function c86433602.tgtg(e,c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
--Cost Modification
function c86433602.costcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetHandler():GetFlagEffect(86433602)>0
end
function c86433602.costtarget(e,te,tp)
	return te==e:GetLabelObject() and te:GetHandler()==e:GetLabelObject():GetHandler() and te:GetCost()
end
function c86433602.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(86433602,1)) then
		e:GetLabelObject():SetCost(c86433602.standardcost)
	end
end
function c86433602.standardcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end