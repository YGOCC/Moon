--Not yet finalized values
--Custom constants
EFFECT_STAGE							=388		--
EFFECT_CANNOT_BE_EVOLUTE_MATERIAL		=389		--
TYPE_EVOLUTE							=0x100000000

CTYPE_EVOLUTE							=0x1

--Custom Type Tables
Auxiliary.Evolutes={} --number as index = card, card as index = function() is_xyz

--overwrite functions
local get_rank, get_orig_rank, prev_rank_field, is_rank, is_rank_below, is_rank_above, get_type, get_orig_type, get_prev_type_field = 
	Card.GetRank, Card.GetOriginalRank, Card.GetPreviousRankOnField, Card.IsRank, Card.IsRankBelow, Card.IsRankAbove, Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField

Card.GetRank=function(c)
	if Auxiliary.Evolutes[c] then return 0 end
	return get_rank(c)
end
Card.GetOriginalRank=function(c)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return 0 end
	return get_orig_rank(c)
end
Card.GetPreviousRankOnField=function(c)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return 0 end
	return prev_rank_field(c)
end
Card.IsRank=function(c,rk)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return false end
	return is_rank(c,rk)
end
Card.IsRankBelow=function(c,rk)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return false end
	return is_rank_below(c,rk)
end
Card.IsRankAbove=function(c,rk)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return false end
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
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Evolutes[c] then
		tpe=tpe|TYPE_EVOLUTE
		if not Auxiliary.Evolutes[c]() then
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
	return tpe
end

--Custom Functions
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
