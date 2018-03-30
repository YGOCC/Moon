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
Auxiliary.Pandemoniums={} --number as index = card, card as index = function() is_pendulum, is_spell_on_field
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
get_prev_level_field, is_level, is_level_below, is_level_above, change_position = 
Card.GetRank, Card.GetOriginalRank, Card.GetPreviousRankOnField, Card.IsRank, Card.IsRankBelow, Card.IsRankAbove, Card.GetType, Card.IsType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Card.GetLevel, 
Card.GetSynchroLevel, Card.GetRitualLevel, Card.GetOriginalLevel, Card.IsXyzLevel, Card.GetPreviousLevelOnField, Card.IsLevel, Card.IsLevelBelow, Card.IsLevelAbove, Duel.ChangePosition

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
		local ispen, isspell=Auxiliary.Pandemoniums[c]()
		if not ispen then
			tpe=tpe&~TYPE_PENDULUM
		end
		if c:IsLocation(LOCATION_PZONE) then
			tpe=tpe|TYPE_TRAP
			if not isspell then
				tpe=tpe&~TYPE_SPELL
			end
		end
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
		if not Auxiliary.Pandemoniums[c]() then
			tpe=tpe&~TYPE_PENDULUM
		end
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
		local ispen, isspell=Auxiliary.Pandemoniums[c]()
		if not ispen then
			tpe=tpe&~TYPE_PENDULUM
		end
		if c:IsPreviousLocation(LOCATION_PZONE) then
			tpe=tpe|TYPE_TRAP
			if not isspell then
				tpe=tpe&~TYPE_SPELL
			end
		end
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
	-- if (du and (du&POS_FACEDOWN)~=0) or (au and (au&POS_FACEDOWN)~=0) then
	if pcall(Group.GetFirst,cc) then
		local tg=cc:Clone()
		for c in aux.Next(tg) do
			if c:SwitchSpace() then cc=cc-c end
		end
	elseif cc:SwitchSpace() then return end
	-- end
	change_position(cc,au,ad,du,dd)
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
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_COUNTER_PERMIT+0x88)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_MZONE)
	c:RegisterEffect(e0)
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
function Auxiliary.PendCondition()
	return	function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if rpz==nil or c==rpz or not rpz:IsType(TYPE_PENDULUM) then return false end
		local lscale=c:GetLeftScale()
		local rscale=rpz:GetRightScale()
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
	return g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale,SUMMON_TYPE_PENDULUM)
	end
end
function Auxiliary.AddOrigPandemoniumType(c,ispendulum,is_spell)
	table.insert(Auxiliary.Pandemoniums,c)
	Auxiliary.Customs[c]=true
	local ispendulum=ispendulum==nil and false or ispendulum
	local is_spell=is_spell==nil and false or is_spell
	Auxiliary.Pandemoniums[c]=function() return ispendulum, is_spell end
end
function Auxiliary.EnablePandemoniumAttribute(c,xe,regfield,reghand)
	--register by default
	if regfield==nil or regfield then
		--summon
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_PZONE+LOCATION_SZONE+LOCATION_HAND)
		-- e1:SetCondition(Auxiliary.PandCondition(xe))
		e1:SetTarget(Auxiliary.PandActTarget(xe))
		e1:SetOperation(Auxiliary.PandOperation(xe))
		c:RegisterEffect(e1)
		--set
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_MONSTER_SSET)
		--e3:SetValue(TYPE_TRAP+TYPE_PANDEMONIUM)
		e3:SetValue(TYPE_TRAP+TYPE_PENDULUM) --by default, it minuses PENDULUM and adds PANDEMONIUM
		c:RegisterEffect(e3)
	end
	-- if reghand==nil or reghand then
	-- local e4=Effect.CreateEffect(c)
	-- e4:SetDescription(1160)
	-- e4:SetType(EFFECT_TYPE_ACTIVATE)
	-- e4:SetCode(EVENT_FREE_CHAIN)
	-- e4:SetRange(LOCATION_HAND)
	-- e4:SetLabel(LOCATION_HAND)
	-- e4:SetTarget(Auxiliary.PandActTarget)
	-- e4:SetValue(LOCATION_PZONE)
	-- c:RegisterEffect(e4)
	-- end
end
function Auxiliary.PaConditionFilter(c,e,tp,lscale,rscale,st)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_PANDEMONIUM))))
	and (lv>lscale and lv<rscale) and c:IsCanBeSpecialSummoned(e,st,tp,false,false)
	and not c:IsForbidden()
end
function Auxiliary.PandActTarget(xe)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local lscale=c:GetLeftScale()
		local rscale=c:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		local loc=0
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
		if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
		local g=nil
		if loc~=0 then
			g=Duel.GetFieldGroup(tp,loc,0)
			if c:IsLocation(LOCATION_HAND) then g=g-c end
		end
		local b1=c:IsReleasable() and Duel.GetTurnPlayer()~=tp and g and g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale,SUMMON_TYPE_SPECIAL+726)
		local te=xe
		local cost=nil
		local target=nil
		local b2=te~=nil
		if b2 then
			local condition=te:GetCondition()
			cost=te:GetCost()
			target=te:GetTarget()
			b2=b2 and (not condition or condition(e,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(e,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(e,tep,eg,ep,ev,re,r,rp,0))
		end
		if chk==0 then return (not c:IsStatus(STATUS_SET_TURN) or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)) and (c:GetLocation()~=LOCATION_HAND and c:IsFacedown() or (c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))) end
		local opt=nil
		if b1 and b2 then opt=Duel.SelectOption(tp,1150,1074,1214)
		elseif b2 then
			opt=Duel.SelectOption(tp,1150,1214)
			if opt==1 then opt=2 end
		elseif b1 then opt=Duel.SelectOption(tp,1074,1214)+1
		else opt=Duel.SelectOption(tp,1214)+2 end
		e:SetLabel(opt)
		if c:IsLocation(LOCATION_HAND) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) else Duel.ChangePosition(c,POS_FACEUP) end
		if opt==0 then
			e:SetCategory(te:GetCategory())
			e:SetProperty(te:GetProperty())
			if cost then cost(e,tep,eg,ep,ev,re,r,rp,1) end
			if target then target(e,tep,eg,ep,ev,re,r,rp,1) end
		elseif opt==1 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_EXTRA)
		else
			e:SetCategory(0)
			e:SetProperty(0)
		end
	end
end
function Auxiliary.PandOperation(xe)
	return	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if e:GetLabel()==0 then
			if xe then
				local op=xe:GetOperation()
				if op then op(e,tp,eg,ep,ev,re,r,rp) end
			end
			return
		elseif e:GetLabel()==2 then return end
		if not c:IsReleasable() then return end
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
		local tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
		ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
		ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		if ect and ect<ft2 then ft2=ect end
		local sg=Group.CreateGroup()
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
		Duel.SpecialSummon(sg,726,tp,tp,false,false,POS_FACEUP)
		Duel.Release(c,REASON_COST)
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
	local tcode=c.spt_other_space or c.spt_another_space or c.spt_origin_space
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.SetMetatable(c,_G["c"..tcode])
	Auxiliary.AddOrigSpatialType(c)
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
	table.insert(Auxiliary.Spatials,c)
	Auxiliary.Customs[c]=true
	local isxyz=isxyz==nil and false or isxyz
	Auxiliary.Spatials[c]=function() return isxyz end
end
function Auxiliary.AddSpatialProc(c,sptcheck,djn,adiff,ddiff,...)
	--sptcheck - extra check after everything is settled, djn - Spatial "level", adiff - max material ATK difference, ddiff - max material DEF difference
	--... format - any number of materials	use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local t={...}
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
	ge2:SetValue(500)
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
	ge4:SetRange(0xdf)
	ge4:SetTarget(Auxiliary.SpatialToGraveReplace)
	c:RegisterEffect(ge4)
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
