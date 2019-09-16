--created by Meedogh, coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_PANDEMONIUM	=726
TYPE_PANDEMONIUM	=0x200000000
TYPE_CUSTOM			=TYPE_CUSTOM|TYPE_PANDEMONIUM
CTYPE_PANDEMONIUM	=0x2
CTYPE_CUSTOM		=CTYPE_CUSTOM|CTYPE_PANDEMONIUM

--Custom Type Table
Auxiliary.Pandemoniums={} --number as index = card, card as index = function() is_pendulum

--overwrite functions
local get_type, get_orig_type, get_prev_type_field = 
	Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField

Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
		local ispen,isspell=Auxiliary.Pandemoniums[c]()
		if not ispen then
			tpe=tpe&~TYPE_PENDULUM
		end
		if c:IsLocation(LOCATION_PZONE) and not isspell then
			tpe=tpe&~TYPE_SPELL
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
		if not Auxiliary.Pandemoniums[c]() then
			tpe=tpe&~TYPE_PENDULUM
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
		local ispen,isspell=Auxiliary.Pandemoniums[c]()
		if not ispen then
			tpe=tpe&~TYPE_PENDULUM
		end
		if c:IsPreviousLocation(LOCATION_PZONE) and not isspell then
			tpe=tpe&~TYPE_SPELL
		end
	end
	return tpe
end

--Custom Functions
function Auxiliary.AddOrigPandemoniumType(c,ispendulum,is_spell)
	table.insert(Auxiliary.Pandemoniums,c)
	Auxiliary.Customs[c]=true
	local ispendulum=ispendulum==nil and false or ispendulum
	local is_spell=is_spell==nil and false or is_spell
	Auxiliary.Pandemoniums[c]=function() return ispendulum, is_spell end
end
function Auxiliary.EnablePandemoniumAttribute(c,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local t={...}
	local regfield,typ=nil,nil
	if type(t[#t])=='number' then
		typ=t[#t]
		table.remove(t)
	end
	if type(t[#t])=='boolean' then
		regfield=t[#t]
		table.remove(t)
	end
	if not PANDEMONIUM_CHECKLIST then
		PANDEMONIUM_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PandeReset)
		Duel.RegisterEffect(ge1,0)
	end
	--summon
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_FIELD)
	ge6:SetDescription(1074)
	ge6:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge6:SetRange(LOCATION_SZONE)
	ge6:SetCondition(Auxiliary.PandCondition)
	ge6:SetOperation(Auxiliary.PandOperation)
	ge6:SetValue(726)
	c:RegisterEffect(ge6)
	--add Pendulum-like redirect property
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetOperation(Auxiliary.PandEnConFUInED(typ))
	c:RegisterEffect(e0)
	--reset Pendulum-like redirect property
	local sp=Effect.CreateEffect(c)
	sp:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	sp:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	sp:SetCode(EVENT_SPSUMMON_SUCCESS)
	sp:SetCondition(Auxiliary.PandDisConFUInED)
	sp:SetOperation(Auxiliary.PandDisableFUInED(c,typ))
	c:RegisterEffect(sp)
	local th=Effect.CreateEffect(c)
	th:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	th:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	th:SetCode(EVENT_TO_HAND)
	th:SetCondition(Auxiliary.PandDisConFUInED)
	th:SetOperation(Auxiliary.PandDisableFUInED(c,typ))
	c:RegisterEffect(th)
	local td=th:Clone()
	td:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(td)
	local rem=th:Clone()
	rem:SetCode(EVENT_REMOVE)
	c:RegisterEffect(rem)
	--keep on field
	local kp=Effect.CreateEffect(c)
	kp:SetType(EFFECT_TYPE_SINGLE)
	kp:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(kp)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(Auxiliary.PandActCon)
	if #t>0 then
		local flags=0
		for _,xe in ipairs(t) do
			if type(xe)=='userdata' and xe:GetProperty() then flags=flags|xe:GetProperty() end
		end
		e1:SetProperty(flags)
		e1:SetHintTiming(TIMING_DAMAGE_CAL+TIMING_DAMAGE_STEP)
	end
	e1:SetTarget(Auxiliary.PandActTarget(table.unpack(t)))
	e1:SetOperation(Auxiliary.PandActOperation(table.unpack(t)))
	c:RegisterEffect(e1)
	--register by default
	if regfield==nil or regfield then
		--set
		local set=Effect.CreateEffect(c)
		set:SetDescription(1159)
		set:SetType(EFFECT_TYPE_FIELD)
		set:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		set:SetCode(EFFECT_SPSUMMON_PROC_G)
		set:SetRange(LOCATION_HAND)
		set:SetCondition(Auxiliary.PandSSetCon)
		set:SetOperation(Auxiliary.PandSSet(c,REASON_RULE,typ))
		c:RegisterEffect(set)
	end
	Duel.AddCustomActivityCounter(10000000,ACTIVITY_SPSUMMON,Auxiliary.PaCheck)
end
function Auxiliary.PaCheck(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function Auxiliary.PandeReset(e,tp,eg,ep,ev,re,r,rp)
	PANDEMONIUM_CHECKLIST=0
end
function Auxiliary.PandePendSwitch(e,c,tp,sumtp,sumpos)
	return sumtp&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end
function Auxiliary.PaConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pandemonium_level then
		lv=c.pandemonium_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM)))
		and (lv>lscale and lv<rscale) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+726,tp,false,false)
		and not c:IsForbidden()
end
function Auxiliary.PandCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if PANDEMONIUM_CHECKLIST&(0x1<<tp)~=0 or Duel.GetCustomActivityCount(10000000,tp,ACTIVITY_SPSUMMON)~=0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=c:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return aux.PandActCheck(e) and g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale) and c:GetFlagEffect(53313903)<=0
end
function Auxiliary.PandOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lscale=c:GetLeftScale()
	local rscale=c:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PaConditionFilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(Auxiliary.PaConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end 
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.GCheckAdditional=aux.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
	Auxiliary.GCheckAdditional=nil
	if not g then return end
	PANDEMONIUM_CHECKLIST=PANDEMONIUM_CHECKLIST|(0x1<<tp)
	sg:Merge(g)
	if sg:GetCount()>0 then
		Duel.HintSelection(Group.FromCards(c))
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetTargetRange(1,0)
		e0:SetTarget(Auxiliary.PandePendSwitch)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return eg:IsExists(Card.IsSummonType,1,nil,SUMMON_TYPE_SPECIAL+726) end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function Auxiliary.PaCheckFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM) and c:GetFlagEffect(726)>0
end
function Auxiliary.PandActCon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Auxiliary.PaCheckFilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function Auxiliary.PandEnConFUInED(tpe)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if (e:GetHandler():GetFlagEffect(706)>0 or e:GetHandler():GetFlagEffect(726)>0) and e:GetHandler():GetDestination()~=LOCATION_GRAVE then
					Auxiliary.PandDisableFUInED(e:GetHandler(),tpe)(e,tp,eg,ep,ev,re,r,rp)
				elseif e:GetHandler():GetDestination()==LOCATION_GRAVE then
					Auxiliary.PandEnableFUInED(e:GetHandler(),e:GetHandler():GetReason(),tpe)(e,tp,eg,ep,ev,re,r,rp)
				else
					return
				end
	end
end
function Auxiliary.PandEnableFUInED(tc,reason,tpe)
	if not tpe then tpe=TYPE_EFFECT end
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if pcall(Group.GetFirst,tc) then
					local tg=tc:Clone()
					for cc in aux.Next(tg) do
						Card.SetCardData(cc,CARDDATA_TYPE,TYPE_MONSTER+tpe+TYPE_PENDULUM)
						if not cc:IsOnField() or cc:GetDestination()==0 then
							Duel.SendtoExtraP(cc,nil,reason)
						end
					end
				else
					Card.SetCardData(tc,CARDDATA_TYPE,TYPE_MONSTER+tpe+TYPE_PENDULUM)
					if not tc:IsOnField() or tc:GetDestination()==0 then
						Duel.SendtoExtraP(tc,nil,reason)
					end
				end
			end
end
function Auxiliary.PandDisConFUInED(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function Auxiliary.PandDisableFUInED(tc,tpe)
	if not tpe then tpe=TYPE_EFFECT end
	return  function(e,tp,eg,ep,ev,re,r,rp)
				tc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+tpe)
			end
end
function Auxiliary.PandSSetCon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function Auxiliary.PandSSet(tc,reason,tpe)
	if not tpe then tpe=TYPE_EFFECT end
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				if pcall(Group.GetFirst,tc) then
					local tg=tc:Clone()
					for cc in aux.Next(tg) do
						cc:SetCardData(CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
						if cc:IsLocation(LOCATION_SZONE) then
							if cc:IsCanTurnSet() then
								Duel.ChangePosition(cc,POS_FACEDOWN_ATTACK)
								Duel.RaiseEvent(cc,EVENT_SSET,e,reason,cc:GetControler(),cc:GetControler(),0)
								cc:RegisterFlagEffect(706,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
							end
						else Duel.SSet(cc:GetControler(),cc) cc:RegisterFlagEffect(706,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1) end
						if not cc:IsLocation(LOCATION_SZONE) then
							cc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+tpe)
						end
					end
				else
					tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
					if tc:IsLocation(LOCATION_SZONE) then
						if tc:IsCanTurnSet() then
							Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)
							Duel.RaiseEvent(tc,EVENT_SSET,e,reason,tc:GetControler(),tc:GetControler(),0)
							tc:RegisterFlagEffect(706,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1)
						end
					else Duel.SSet(tc:GetControler(),tc) tc:RegisterFlagEffect(706,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE,1) end
					if not tc:IsLocation(LOCATION_SZONE) then
						tc:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+tpe)
					end
				end
			end
end
function Auxiliary.PandActCheck(e)
	local c=e:GetHandler()
	return e:IsHasType(EFFECT_TYPE_ACTIVATE) or c:GetFlagEffect(726)>0
end
function Auxiliary.PandActTarget(...)
	local fx={...}
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
				if chk==0 then return true end
				local c=e:GetHandler()
				c:RegisterFlagEffect(726,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE,1)
				if #fx==0 then
					e:SetCategory(0)
					e:SetProperty(0)
					e:SetLabel(0)
					return
				end
				local ops={}
				local t={}
				local cost=nil
				local tg=nil
				for i,xe in ipairs(fx) do
					local condition=xe:GetCondition()
					local code=xe:GetCode()
					local check_own_label=xe:GetLabelObject()
					if check_own_label then
						e:SetLabelObject(check_own_label)
					end
					cost=xe:GetCost()
					tg=xe:GetTarget()
					local tchk=(code==EVENT_FREE_CHAIN or Duel.CheckEvent(code))
					if code==EVENT_CHAINING then
						tchk=(tchk or Duel.GetCurrentChain()>1)
						ev=Duel.GetCurrentChain()-1
						re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
						eg=re:GetHandler()
					end
					if tchk and xe:CheckCountLimit(tp) and (not condition or condition(e,tp,eg,ep,ev,re,r,rp))
						and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
						and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
						table.insert(ops,xe:GetDescription())
					else table.insert(ops,1214) end
					table.insert(t,xe)
				end
				local op=0
				if #ops>1 then
					op=Duel.SelectOption(tp,1214,table.unpack(ops))
					if ops[op]==1214 then op=0 end
				elseif ops[1]~=1214 and Duel.SelectYesNo(tp,94) then op=1 end
				if op>0 then
					local xe=t[op]
					xe:UseCountLimit(tp)
					local confirm_own_label=xe:GetLabelObject()
					if confirm_own_label then
						e:SetLabelObject(confirm_own_label)
					end
					e:SetCategory(xe:GetCategory())
					cost=xe:GetCost()
					if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
					tg=xe:GetTarget()
					if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
					c:RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
				else
					e:SetCategory(0)
					e:SetLabel(0)
				end
				e:SetLabel(op)
			end
end
function Auxiliary.PandActOperation(...)
	local fx={...}
	return  function(e,tp,eg,ep,ev,re,r,rp)
				if e:GetLabel()==0 then return end
				local xe=fx[e:GetLabel()]
				if xe:GetCode()==EVENT_CHAINING then
					ev=Duel.GetCurrentChain()-1
					re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
					eg=re:GetHandler()
				end
				local confirm_own_label=xe:GetLabelObject()
				if confirm_own_label then
					e:SetLabelObject(confirm_own_label)
				end
				local op=xe:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
end
function Auxiliary.PandAct(tc)
	return  function(e,tp,eg,ep,ev,re,r,rp)
				tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
				if not tc:IsOnField() then
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
				tc:RegisterFlagEffect(726,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CANNOT_DISABLE,1)
			end
end
