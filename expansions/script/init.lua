--Not yet finalized values
--Custom constants
EFFECT_STAGE							=388		--
EFFECT_CANNOT_BE_EVOLUTE_MATERIAL		=389		--
EFFECT_PANDEMONIUM						=726
EFFECT_STABLE							=765
EFFECT_CANNOT_BE_POLARITY_MATERIAL		=766
EFFECT_DIMENSION_NUMBER					=500
EFFECT_CANNOT_BE_SPACE_MATERIAL			=501
TYPE_EVOLUTE							=0x100000000
TYPE_PANDEMONIUM						=0x200000000
TYPE_POLARITY							=0x400000000
TYPE_SPATIAL							=0x800000000
TYPE_CUSTOM								=TYPE_EVOLUTE+TYPE_PANDEMONIUM+TYPE_POLARITY+TYPE_SPATIAL

CTYPE_EVOLUTE							=0x1
CTYPE_PANDEMONIUM						=0x2
CTYPE_POLARITY							=0x4
CTYPE_SPATIAL							=0x8
CTYPE_CUSTOM							=CTYPE_EVOLUTE+CTYPE_PANDEMONIUM+CTYPE_POLARITY+CTYPE_SPATIAL

--Custom Type Tables
Auxiliary.Customs={} --check if card uses custom type, indexing card
Auxiliary.Evolutes={} --number as index = card, card as index = function() is_xyz
Auxiliary.Pandemoniums={} --number as index = card, card as index = function() is_pendulum
Auxiliary.Polarities={} --number as index = card, card as index = function() is_synchro
Auxiliary.Spatials={} --number as index = card, card as index = function() is_xyz

--overwrite constants
TYPE_EXTRA=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_EVOLUTE+TYPE_POLARITY+TYPE_SPATIAL

--Custom Functions
function Card.IsCustomType(c,tpe,scard,sumtype,p)
	return c:GetType(scard,sumtype,p)&tpe>0
end

--overwrite functions
local get_rank, get_orig_rank, prev_rank_field, is_rank, is_rank_below, is_rank_above, get_type, is_type, get_orig_type, get_prev_type_field, get_level, get_syn_level, get_rit_level, get_orig_level, is_xyz_level, 
	get_prev_level_field, is_level, is_level_below, is_level_above, change_position , card_remcounter, duel_remcounter = 
	Card.GetRank, Card.GetOriginalRank, Card.GetPreviousRankOnField, Card.IsRank, Card.IsRankBelow, Card.IsRankAbove, Card.GetType, Card.IsType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Card.GetLevel, 
	Card.GetSynchroLevel, Card.GetRitualLevel, Card.GetOriginalLevel, Card.IsXyzLevel, Card.GetPreviousLevelOnField, Card.IsLevel, Card.IsLevelBelow, Card.IsLevelAbove, Duel.ChangePosition, Card.RemoveCounter, Duel.RemoveCounter

Card.GetRank=function(c)
	if Auxiliary.Evolutes[c] or Auxiliary.Spatials[c] then return 0 end
	return get_rank(c)
end
Card.GetOriginalRank=function(c)
	if (Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]()) or (Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]()) then return 0 end
	return get_orig_rank(c)
end
Card.GetPreviousRankOnField=function(c)
	if (Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]()) or (Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]()) then return 0 end
	return prev_rank_field(c)
end
Card.IsRank=function(c,rk)
	if (Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]()) or (Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]()) then return false end
	return is_rank(c,rk)
end
Card.IsRankBelow=function(c,rk)
	if (Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]()) or (Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]()) then return false end
	return is_rank_below(c,rk)
end
Card.IsRankAbove=function(c,rk)
	if (Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]()) or (Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]()) then return false end
	return is_rank_above(c,rk)
end
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Evolutes[c] then
		tpe=tpe|TYPE_EVOLUTE
		if not Auxiliary.Evolutes[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
	end
	if Auxiliary.Polarities[c] then
		tpe=tpe|TYPE_POLARITY
		if not Auxiliary.Polarities[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	if Auxiliary.Spatials[c] then
		tpe=tpe|TYPE_SPATIAL
		if not Auxiliary.Spatials[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.IsType=function(c,tpe,scard,sumtype,p)
	local custpe=tpe>>32
	local otpe=tpe&0xffffffff
	if (scard and c:GetType(scard,sumtype,p)&otpe>0) or (not scard and c:GetType()&otpe>0) then return true end
	if custpe<=0 then return false end
	return c:IsCustomType(custpe,scard,sumtype,p)
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Evolutes[c] then
		tpe=tpe|TYPE_EVOLUTE
		if not Auxiliary.Evolutes[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
	end
	if Auxiliary.Polarities[c] then
		tpe=tpe|TYPE_POLARITY
		if not Auxiliary.Polarities[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	if Auxiliary.Spatials[c] then
		tpe=tpe|TYPE_SPATIAL
		if not Auxiliary.Spatials[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Evolutes[c] then
		tpe=tpe|TYPE_EVOLUTE
		if not Auxiliary.Evolutes[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	if Auxiliary.Pandemoniums[c] then
		tpe=tpe|TYPE_PANDEMONIUM
	end
	if Auxiliary.Polarities[c] then
		tpe=tpe|TYPE_POLARITY
		if not Auxiliary.Polarities[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	if Auxiliary.Spatials[c] then
		tpe=tpe|TYPE_SPATIAL
		if not Auxiliary.Spatials[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetLevel=function(c)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return 0 end
	return get_level(c)
end
GetSynchroLevel=function(c,sc)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return 0 end
	return get_syn_level(c,sc)
end
Card.GetRitualLevel=function(c,rc)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return 0 end
	return get_rit_level(c,rc)
end
Card.GetOriginalLevel=function(c)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return 0 end
	return get_orig_level(c)
end
Card.IsXyzLevel=function(c,xyz,lv)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return false end
	return is_xyz_level(c,xyz,lv)
end
Card.GetPreviousLevelOnField=function(c)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return 0 end
	return get_prev_level_field(c)
end
Card.IsLevel=function(c,lv)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return false end
	return is_level(c,lv)
end
Card.IsLevelBelow=function(c,lv)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return false end
	return is_level_below(c,lv)
end
Card.IsLevelAbove=function(c,lv)
	if Auxiliary.Polarities[c] and not Auxiliary.Polarities[c]() then return false end
	return is_level_above(c,lv)
end
Duel.ChangePosition=function(cc, au, ad, du, dd)
	if not ad then ad=au end if not du then du=au end if not dd then dd=au end
	if pcall(Group.GetFirst,cc) then
		local tg=cc:Clone()
		for c in aux.Next(tg) do
			if c:SwitchSpace() then cc=cc-c end
		end
	elseif cc:SwitchSpace() then return end
	change_position(cc,au,ad,du,dd)
end

Card.RemoveCounter=function(c,p,typ,ct,r)
	local n=c:GetCounter(typ)
	card_remcounter(c,p,typ,ct,r)
	if n-c:GetCounter(typ)==ct then return true else return false end
end

Duel.RemoveCounter=function(p,s,o,typ,ct,r,rp)
	if rp==nil or rp==PLAYER_NONE --[[2]] then
		duel_remcounter(p,s,o,typ,ct,r)
		return nil
	elseif rp==PLAYER_ALL --[[3]] then
		local n=Duel.GetCounter(p,s,o,typ)
		duel_remcounter(p,s,o,typ,ct,r)
		return n-Duel.GetCounter(p,s,o,typ)==ct,ct
	elseif rp==p then
		local n=Duel.GetCounter(p,s,0,typ)
		duel_remcounter(p,s,o,typ,ct,r)
		return n-Duel.GetCounter(p,s,0,typ)
	elseif rp==1-p then
		local n=Duel.GetCounter(p,0,o,typ)
		duel_remcounter(p,s,o,typ,ct,r)
		return n-Duel.GetCounter(p,0,o,typ)
	end
end

--Custom Functions
--Evolutes
function Card.GetStage(c)
	if not Auxiliary.Evolutes[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_STAGE)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsStage(c,stage)
	return c:GetStage()==stage
end
function Card.IsCanBeEvoluteMaterial(c,ec)
	if c:GetLevel()<=0 and c:GetRank()<=0 and not c:IsStatus(STATUS_NO_LEVEL) then return false end
	local tef={c:IsHasEffect(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,ec) then return false end
	end
	return true
end
function Auxiliary.AddOrigEvoluteType(c,isxyz)
	table.insert(Auxiliary.Evolutes,c)
	Auxiliary.Customs[c]=true
	local isxyz=isxyz==nil and false or isxyz
	Auxiliary.Evolutes[c]=function() return isxyz end
end
function Auxiliary.AddEvoluteProc(c,echeck,stage,...)
	--echeck - extra check after everything is settled, stage - Evolute "level"
	--... format - any number of materials + optional material - min, max (min can be 0, max can be nil which will set it to 99)	use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local t={...}
	local reqmats={}
	local extramat,min,max
	if type(t[#t])=='number' then
		max=t[#t]
		table.remove(t)
		if type(t[#t])=='number' then
			min=t[#t]
			extramat=t[#t-1]
			table.remove(t)
		else
			min=max
			max=99
			extramat=t[#t]
		end
		table.remove(t)
	end
	if not extramat then extramat,min,max=aux.FALSE,0,0 end
	c:EnableCounterPermit(0x88)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_STAGE)
	e1:SetValue(Auxiliary.StageVal(stage))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.EvoluteCondition(echeck,extramat,min,max,...))
	e2:SetTarget(Auxiliary.EvoluteTarget(echeck,extramat,min,max,...))
	e2:SetOperation(Auxiliary.EvoluteOperation)
	e2:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e2)
	if not Evochk then
		Evochk=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(Auxiliary.EvoluteCounter)
		Duel.RegisterEffect(ge1,0)
	end
end
function Auxiliary.StageVal(stage)
	return	function(e,c)
				local stage=stage
				--insert modifications here
				return stage
			end
end
function Auxiliary.EvoluteMatFilter(c,ec,tp,...)
	if c:IsFacedown() or not c:IsCanBeEvoluteMaterial(ec) then return false end
	for _,f in ipairs({...}) do
		if f(c,ec,tp) then return true end
	end
	return false
end
function Auxiliary.EvoluteValue(c)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	if lv>0 or c:IsStatus(STATUS_NO_LEVEL) then
		return lv+0x10000*rk
	else
		return rk+0x10000*lv
	end
end
function Auxiliary.EvolCheckRecursive(c,tp,mg,sg,ec,stage,echeck,extramat,min,max,f,...)
	if not f(c,ec,tp,sg) then return false end
	--if sg:CheckWithSumGreater(Auxiliary.EvoluteValue,stage+1) then return false end
	sg:AddCard(c)
	local res
	if ... then
		res=mg:IsExists(Auxiliary.EvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,...)
	else
		if min>0 then
			res=mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,Group.CreateGroup())
		else
			res=(sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0) 
				or (max>0 and mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,Group.CreateGroup()))
		end
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.ExEvolCheckRecursive(c,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	if not extramat(c,ec,tp,sg,sg2) then return false end
	sg:AddCard(c)
	sg2:AddCard(c)
	local res
	if sg2:GetCount()<min then
		res=mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	elseif sg2:GetCount()<max then
		res=(sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0) 
			or mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	else
		res=sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0
	end
	sg:RemoveCard(c)
	sg2:RemoveCard(c)
	return res
end
function Auxiliary.EvoluteCondition(echeck,extramat,min,max,...)
	local funs={...}
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local stage=c:GetStage()
				local mg=Duel.GetMatchingGroup(Auxiliary.EvoluteMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs),extramat)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.EvolCheckRecursive,1,nil,tp,mg,sg,c,stage,echeck,extramat,min,max,table.unpack(funs))
			end
end
function Auxiliary.EvoluteTarget(echeck,extramat,min,max,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.EvoluteMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs),extramat)
				local ct=#funs
				local stage=c:GetStage()
				local sg
				local sg2
				local tempfun
				::restart::
				sg=Group.CreateGroup()
				sg2=Group.CreateGroup()
				tempfun={table.unpack(funs)}
				while sg:GetCount()<ct+max do
					local cg
					if #tempfun>0 then
						cg=mg:Filter(Auxiliary.EvolCheckRecursive,sg,tp,mg,sg,c,stage,echeck,extramat,min,max,table.unpack(tempfun))
					elseif max>0 then
						cg=mg:Filter(Auxiliary.ExEvolCheckRecursive,sg,tp,mg,sg,c,stage,echeck,extramat,min,max,sg2)
					else
						cg=Group.CreateGroup()
					end
					if cg:GetCount()==0 then break end
					local tc=cg:SelectUnselect(sg,tp,true,true)
					if not tc then break end
					table.remove(tempfun,1)
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
						if #tempfun<=0 then
							sg2:AddCard(tc)
						end
					end
				end
				if sg:GetCount()>=ct+min then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					if sg:GetCount()>0 then goto restart end
					return false
				end
			end
end
function Auxiliary.EvoluteOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
	g:DeleteGroup()
end
function Auxiliary.ECSumFilter(c)
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+388 and c:IsType(TYPE_EVOLUTE)
end
function Auxiliary.EvoluteCounter(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=eg:Filter(Auxiliary.ECSumFilter,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x88,tc:GetStage())
		tc=g:GetNext()
	end
end

--Pandemoniums
function Auxiliary.AddOrigPandemoniumType(c)
	table.insert(Auxiliary.Pandemoniums,c)
	Auxiliary.Customs[c]=true
	Auxiliary.Pandemoniums[c]=aux.TRUE
end
function Auxiliary.EnablePandemoniumAttribute(c,xe,regfield,desc)
	--summon
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_FIELD)
	if desc then
		ge6:SetDescription(desc)
	else
		ge6:SetDescription(1074)
	end
	ge6:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge6:SetRange(LOCATION_SZONE)
	ge6:SetCountLimit(1,10000000)
	ge6:SetCondition(Auxiliary.PandCondition)
	ge6:SetCost(Auxiliary.PandCost)
	ge6:SetOperation(Auxiliary.PandOperation)
	ge6:SetValue(726)
	c:RegisterEffect(ge6)
	--add Pendulum-like redirect property
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetOperation(Auxiliary.PandEnableFUInED)
	c:RegisterEffect(e0)
	--reset Pendulum-like redirect property
	local sp=Effect.CreateEffect(c)
	sp:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	sp:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	sp:SetCode(EVENT_SPSUMMON_SUCCESS)
	sp:SetCondition(Auxiliary.PandDisConFUInED)
	sp:SetOperation(Auxiliary.PandDisableFUInED)
	c:RegisterEffect(sp)
	local th=Effect.CreateEffect(c)
	th:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	th:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	th:SetCode(EVENT_TO_HAND)
	th:SetCondition(Auxiliary.PandDisConFUInED)
	th:SetOperation(Auxiliary.PandDisableFUInED)
	c:RegisterEffect(th)
	local td=th:Clone()
	td:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(td)
	local rem=th:Clone()
	rem:SetCode(EVENT_REMOVE)
	c:RegisterEffect(rem)
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
		set:SetOperation(Auxiliary.PandSSet(c,REASON_RULE))
		c:RegisterEffect(set)
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
		if xe~=nil then
			local flags=xe:GetProperty()
			e1:SetProperty(flags)
			e1:SetHintTiming(TIMING_DAMAGE_STEP)
			e1:SetTarget(Auxiliary.PandActTarget(xe))
			e1:SetOperation(Auxiliary.PandAct(xe))
		end
		c:RegisterEffect(e1)
	end
	Duel.AddCustomActivityCounter(c:GetOriginalCode(),ACTIVITY_SPSUMMON,Auxiliary.PaCheck)
end
function Auxiliary.PaCheck(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function Auxiliary.PandCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(e:GetHandler():GetOriginalCode(),tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(Auxiliary.PandePendSwitch)
	Duel.RegisterEffect(e1,tp)
end
function Auxiliary.PandePendSwitch(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function Auxiliary.PaConditionFilter(c,e,tp,lscale,rscale)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM))
		and (lv>lscale and lv<rscale) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+726,tp,false,false)
		and not c:IsForbidden()
end
function Auxiliary.PandCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
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
	return g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale)
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
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		if ct<=0 then break end
		if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=tg:Select(tp,1,ct,nil)
		tg:Sub(g)
		sg:Merge(g)
		if g:GetCount()<ct then ft=0 break end
		ft=ft-g:GetCount()
		ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	end
	if ft>0 then
		local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
		if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft1,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg1:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
		if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
			local ct=math.min(ft2,ft)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg2:Select(tp,1,ct,nil)
			sg:Merge(g)
		end
	end
	if sg:GetCount()>0 then
		Duel.HintSelection(Group.FromCards(c))
		Duel.Release(c,REASON_RULE)
	end
end
function Auxiliary.PaCheckFilter(c)
	return c:IsFaceup() and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM
end
function Auxiliary.PandActCon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Auxiliary.PaCheckFilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
end
function Auxiliary.PandEnableFUInED(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsReason(REASON_DESTROY+REASON_RELEASE+REASON_MATERIAL) then
		Card.SetCardData(e:GetHandler(),CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+TYPE_PENDULUM)
	end
end
function Auxiliary.PandDisConFUInED(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_EXTRA)
end
function Auxiliary.PandDisableFUInED(e,tp,eg,ep,ev,re,r,rp)
	Card.SetCardData(e:GetHandler(),CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT)
end
function Auxiliary.PandSSetCon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function Auxiliary.PandSSet(tc,reason)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				if pcall(Group.GetFirst,tc) then
					local tg=tc:Clone()
					for cc in aux.Next(tg) do
						if cc:IsLocation(LOCATION_SZONE) then
							Duel.ChangePosition(cc,POS_FACEDOWN_ATTACK)
						else
							Duel.MoveToField(cc,cc:GetControler(),cc:GetControler(),LOCATION_SZONE,POS_FACEDOWN_ATTACK,nil)
						end
						Card.SetCardData(cc,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
						Duel.RaiseEvent(cc,EVENT_SSET,e,reason,cc:GetControler(),cc:GetControler(),0)
						local e1=Effect.CreateEffect(cc)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_CANNOT_TRIGGER)
						e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
						cc:RegisterEffect(e1)
					end
				else
					if tc:IsLocation(LOCATION_SZONE) then
						Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)
					else
						Duel.MoveToField(tc,tc:GetControler(),tc:GetControler(),LOCATION_SZONE,POS_FACEDOWN_ATTACK,nil)
					end
					Card.SetCardData(tc,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
					Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_RULE,tc:GetControler(),tc:GetControler(),0)
					local e1=Effect.CreateEffect(tc)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_TRIGGER)
					e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
end
function Auxiliary.PandActTarget(xe)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return true end
				if xe==nil then return end
				local tchk=(xe:GetCode()==EVENT_FREE_CHAIN or Duel.CheckEvent(xe:GetCode()))
				local cost=xe:GetCost()
				local target=xe:GetTarget()
				if tchk and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
					and (not target or target(e,tp,eg,ep,ev,re,r,rp,0))
					and Duel.SelectYesNo(tp,94) then
					e:SetProperty(xe:GetProperty())
					e:SetCategory(xe:GetCategory())
					if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
					if target then target(e,tp,eg,ep,ev,re,r,rp,1) end
					e:SetLabel(1)
					c:RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
				else
					e:SetCategory(0)
					e:SetProperty(xe:GetProperty()&EFFECT_FLAG_DAMAGE_STEP)
					e:SetLabel(0)
				end
			end
end
function Auxiliary.PandAct(xe)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				if e:GetLabel()==0 then return end
				local op=xe:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
end

--Polarities
function Card.GetStability(c)
	if not c:IsHasEffect(EFFECT_STABLE) then return 0 end
	local te=c:IsHasEffect(EFFECT_STABLE)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsStability(c,stability)
	return c:GetStability()==stability
end
function Card.IsCanBePolarityMaterial(c,ec)
	if c:GetLevel()<=0 and not c:IsStatus(STATUS_NO_LEVEL) then return false end
	local tef={c:IsHasEffect(EFFECT_CANNOT_BE_POLARITY_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,ec) then return false end
	end
	return true
end
function Auxiliary.AddOrigPolarityType(c,issynchro)
	table.insert(Auxiliary.Polarities,c)
	Auxiliary.Customs[c]=true
	local issynchro=issynchro==nil and false or issynchro
	Auxiliary.Polarities[c]=function() return issynchro end
end
function Auxiliary.AddPolarityProc(c,stability,f1,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_STABLE)
	e1:SetValue(Auxiliary.StabilityVal(stability))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.PolarityCondition(f1,f2))
	e2:SetTarget(Auxiliary.PolarityTarget(f1,f2))
	e2:SetOperation(Auxiliary.PolarityOperation)
	e2:SetValue(SUMMON_TYPE_SPECIAL+765)
	c:RegisterEffect(e2)
end
function Auxiliary.StabilityVal(stability)
	return	function(e,c)
				local stability=stability
				--insert modifications here
				return stability
			end
end
function Auxiliary.PolarityMatFilter(c,ec,tp,...)
	if not c:IsCanBePolarityMaterial(ec) then return false end
	for _,f in ipairs({...}) do
		if f(c,ec,tp) then return true end
	end
	return false
end
function Auxiliary.PolarCheckRecursive1(g2,pc,stability)
	return	function(sg,e,tp,mg)
				local sg2=g2:Filter(aux.TRUE,sg)
				return Auxiliary.SelectUnselectGroup(sg2,e,tp,nil,nil,Auxiliary.PolarCheckRecursive2(sg,pc,stability),0)
			end
end
function Auxiliary.PolarCheckRecursive2(g1,pc,stability)
	return	function(g2,e,tp,mg)
				local sg=g1:Clone()
				sg:Merge(g2)
				return Duel.GetLocationCountFromEx(tp,tp,sg,pc)>0 and math.abs(g1:GetSum(Card.GetLevel)-g2:GetSum(Card.GetLevel))==stability
			end
end
function Auxiliary.PolarityCondition(f1,f2)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local stability=c:GetStability()
				local mg=Duel.GetMatchingGroup(Auxiliary.PolarityMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,f1,f2)
				local g1=mg:Filter(f1,nil,c,tp)
				local g2=mg:Filter(f2,nil,c,tp)
				return Auxiliary.SelectUnselectGroup(g1,e,tp,nil,nil,Auxiliary.PolarCheckRecursive1(g2,c,stability),0)
			end
end
function Auxiliary.PolarityTarget(f1,f2)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.PolarityMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,f1,f2)
				local g1=mg:Filter(f1,nil,c,tp)
				local g2=mg:Filter(f2,nil,c,tp)
				local sg1=Auxiliary.SelectUnselectGroup(g1,e,tp,nil,nil,Auxiliary.PolarCheckRecursive1(g2,c,stability),1,tp,0,aux.TRUE)
				local mg2=mg:Sub(sg1)
				if not Auxiliary.PolarCheckRecursive1(g2,c,stability)(sg1,e,tp,mg2) then return false end
				local sg=sg1:Clone()
				local sg2=Group.CreateGroup()
				while true do
					local tg=g2:Sub(sg2)
					local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,tg,e,tp,1,99,Auxiliary.PolarCheckRecursive2(sg1,c,stability))
					if mg:GetCount()<=0 then break end
					Duel.Hint(HINT_SELECTMSG,tp,0)
					local tc=mg:SelectUnselect(sg,tp,true,true)
					if not tc then break end
					if sg2:IsContains(tc) then
						sg2:RemoveCard(tc)
						sg:RemoveCard(tc)
					elseif not sg:IsContains(tc) then
						sg2:AddCard(tc)
						sg:AddCard(tc)
					end
				end
				local tg=g2:Sub(sg2)
				if Auxiliary.PolarCheckRecursive2(sg1,c,stability)(sg2,e,tp,tg) then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					return false
				end
			end
end
function Auxiliary.PolarityOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x40000000)
	g:DeleteGroup()
end
--Spatials
function Card.SwitchSpace(c)
	if not Auxiliary.Spatials[c] or c:GetSummonType()~=SUMMON_TYPE_SPECIAL+500 or c:GetFlagEffect(500)==0 then return false end
	Auxiliary.Spatials[c]=nil
	local ospc=c.spt_other_space
	if not ospc then return false end
	c:SetEntityCode(ospc,true)
	c:ReplaceEffect(ospc,0,0)
	Duel.SetMetatable(c,_G["c"..ospc])
	local ct=c:GetFlagEffectLabel(500)
	if ct>1 then
		c:SetFlagEffectLabel(500,ct-1)
	else c:ResetFlagEffect(500) end
	return true
end
function Card.GetDimensionNo(c)
	if not Auxiliary.Spatials[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_DIMENSION_NUMBER)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsDimensionNo(c,djn)
	return c:GetDimensionNo()==djn
end
function Card.IsCanBeSpaceMaterial(c,sptc)
	local tef={c:IsHasEffect(EFFECT_CANNOT_BE_SPACE_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,sptc) then return false end
	end
	return true
end
function Auxiliary.AddOrigSpatialType(c,isxyz)
	local code,acode=c:GetOriginalCode(),Duel.ReadCard(c:GetOriginalCode(),CARDDATA_ALIAS)
	local mt=_G["c" .. code]
	local typ,rcode
	for i=240100000,240100999 do
		typ,rcode=Duel.ReadCard(i,CARDDATA_TYPE,CARDDATA_ALIAS)
		if typ and typ&TYPE_XYZ==TYPE_XYZ then
			if code==rcode or acode==i then
				mt.spt_other_space=i
				break
			end
		end
	end
	table.insert(Auxiliary.Spatials,c)
	Auxiliary.Customs[c]=true
	local isxyz=isxyz==nil and false or isxyz
	Auxiliary.Spatials[c]=function() return isxyz end
end
function Auxiliary.AddSpatialProc(c,sptcheck,djn,adiff,ddiff,...)
	--sptcheck - extra check after everything is settled, djn - Spatial "level", adiff - max material ATK difference, ddiff - max material DEF difference
	--... format - any number of materials	use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
			  
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge1:SetCode(EFFECT_DIMENSION_NUMBER)
	ge1:SetValue(Auxiliary.DimensionNoVal(djn))
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(Auxiliary.SpatialCondition(sptcheck,adiff,ddiff,...))
	ge2:SetTarget(Auxiliary.SpatialTarget(sptcheck,adiff,ddiff,...))
	ge2:SetOperation(Auxiliary.SpatialOperation)
	ge2:SetValue(SUMMON_TYPE_SPECIAL+500)
	c:RegisterEffect(ge2)
	local ge3=Effect.CreateEffect(c)
	ge3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsSummonType(SUMMON_TYPE_SPECIAL+500) then
			c:RegisterFlagEffect(500,RESET_EVENT+0x1fe0000,0,1,djn)
		end
	end)
	c:RegisterEffect(ge3)
	local ge4=Effect.CreateEffect(c)
	ge4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge4:SetCode(EFFECT_SEND_REPLACE)
	ge4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge4:SetRange(0xdf)
	ge4:SetTarget(Auxiliary.SpatialToGraveReplace)
	c:RegisterEffect(ge4)
	local ge5=Effect.CreateEffect(c)
	ge5:SetType(EFFECT_TYPE_SINGLE)
	ge5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge5:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(ge5)
end
function Auxiliary.SpatialToGraveReplace(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	Duel.Remove(c,POS_FACEUP,r)
	return true
end
function Auxiliary.DimensionNoVal(djn)
	return	function(e,c)
				local djn=djn
				--insert modifications here
				return djn
			end
end
function Auxiliary.SpaceMatFilter(c,sptc,tp,...)
	if c:IsFacedown() or not c:IsCanBeSpaceMaterial(sptc) then return false end
	for _,f in ipairs({...}) do
		if f(c,sptc,tp) then return true end
	end
	return false
end
function Auxiliary.SptCheckRecursive(c,tp,mg,sg,sptc,djn,sptcheck,adiff,ddiff,f,...)
	if not f(c,sptc,tp,sg) then return false end
	sg:AddCard(c)
	local res
	if ... then
		res=mg:IsExists(Auxiliary.SptCheckRecursive,1,sg,tp,mg,sg,sptc,djn,sptcheck,adiff,ddiff,...)
	else
		res=Auxiliary.SptCheckGoal(tp,sg,sptc,adiff,ddiff,sptcheck)
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SptCheckGoal(tp,sg,sptc,adiff,ddiff,sptcheck)
	return sg:IsExists(Auxiliary.SptMatCheckRecursive,1,nil,sg,Group.CreateGroup(),adiff,ddiff) and (not sptcheck or sptcheck(sg,sptc,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,sptc)>0
end
function Auxiliary.SptMatCheckRecursive(c,mg,sg,adiff,ddiff,fc)
	sg:AddCard(c)
	local res,diff
	if fc and mg:FilterCount(aux.TRUE,sg)==0 then
		if adiff then
			diff=math.abs(c:GetAttack()-fc:GetAttack())
			res=diff>0 and (not adiff or diff<=adiff)
		end
		if ddiff then
			diff=math.abs(c:GetDefense()-fc:GetDefense())
			res=(res) or (diff>0 and (not ddiff or diff<=ddiff))
		end
	else res=mg:IsExists(Auxiliary.SptMatCheckRecursive,1,sg,mg,sg,adiff,ddiff,c) end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.SpatialCondition(sptcheck,adiff,ddiff,...)
	local funs={...}
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local djn=c:GetDimensionNo()
				local mg=Duel.GetMatchingGroup(Auxiliary.SpaceMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs))
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.SptCheckRecursive,1,nil,tp,mg,sg,c,djn,sptcheck,adiff,ddiff,table.unpack(funs))
			end
end
function Auxiliary.SpatialTarget(sptcheck,adiff,ddiff,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.SpaceMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs))
				local ct=#funs
				local djn=c:GetDimensionNo()
				local sg
				local sg2
				local tempfun
				::restart::
				sg=Group.CreateGroup()
				sg2=Group.CreateGroup()
				tempfun={table.unpack(funs)}
				while sg:GetCount()<ct do
					local cg
					if #tempfun>0 then
						cg=mg:Filter(Auxiliary.SptCheckRecursive,sg,tp,mg,sg,c,djn,sptcheck,adiff,ddiff,table.unpack(tempfun))
					else
						cg=Group.CreateGroup()
					end
					if cg:GetCount()==0 then break end
					local tc=cg:SelectUnselect(sg,tp,true,true)
					if not tc then break end
					table.remove(tempfun,1)
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
						if #tempfun<=0 then
							sg2:AddCard(tc)
						end
					end
				end
				if sg:GetCount()>=ct then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					if sg:GetCount()>0 then goto restart end
					return false
				end
			end
end
function Auxiliary.SpatialOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x80000000)
	g:DeleteGroup()
end
