--coded by Lyris
--スペーシュル召喚
--Not yet finalized values
--Custom constants
EFFECT_DIMENSION_NUMBER					=500
EFFECT_CANNOT_BE_SPACE_MATERIAL			=501
TYPE_SPATIAL							=0x800000000

CTYPE_SPATIAL							=0x8

--Custom Type Tables
Auxiliary.Spatials={} --number as index = card, card as index = function() is_xyz

--overwrite functions
local get_rank, get_orig_rank, prev_rank_field, is_rank, is_rank_below, is_rank_above, get_type, get_orig_type, get_prev_type_field, change_position = 
	Card.GetRank, Card.GetOriginalRank, Card.GetPreviousRankOnField, Card.IsRank, Card.IsRankBelow, Card.IsRankAbove, Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField, Duel.ChangePosition

Card.GetRank=function(c)
	if Auxiliary.Spatials[c] then return 0 end
	return get_rank(c)
end
Card.GetOriginalRank=function(c)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return 0 end
	return get_orig_rank(c)
end
Card.GetPreviousRankOnField=function(c)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return 0 end
	return prev_rank_field(c)
end
Card.IsRank=function(c,rk)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return false end
	return is_rank(c,rk)
end
Card.IsRankBelow=function(c,rk)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return false end
	return is_rank_below(c,rk)
end
Card.IsRankAbove=function(c,rk)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return false end
	return is_rank_above(c,rk)
end
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
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
	if Auxiliary.Spatials[c] then
		tpe=tpe|TYPE_SPATIAL
		if not Auxiliary.Spatials[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Duel.ChangePosition=function(cc, au, ad, du, dd)
	local cc,au,ad,du,dd=cc,au,ad,du,dd
	local exg,eau,ead,edu,edd=nil,au,ad,du,dd
	if type(cc)=='group' then
		local tg=cc:Filter(function(c) return Auxiliary.Spatials[c] and c:GetSummonType()==SUMMON_TYPE_SPECIAL+500 --[[and c:GetFlagEffectLabel(500)>0]] end,nil)
		if tg:GetCount()>0 then
			exg=cc:Clone()
			exg:Sub(tg)
			cc=tg:Clone()
			for tc in aux.Next(tg) do
				tc:SwitchSpace()
				-- local ct=cc:GetFlagEffectLabel(500)
				-- if ct==1 then cc:ResetFlagEffect(500)
				-- else cc:SetFlagEffectLabel(500,cc:GetFlagEffectLabel(500)-1) end
				if tc:IsPosition(POS_FACEUP_DEFENSE) then cc:RemoveCard(tc)
				else
					if au and au>0 then au=POS_FACEUP_DEFENSE end
					if ad and ad>0 then ad=POS_FACEUP_DEFENSE end
					if du and du>0 then du=POS_FACEUP_DEFENSE end
					if dd and dd>0 then dd=POS_FACEUP_DEFENSE end
				end
			end
		end
	else
		-- exg=cc
		if Auxiliary.Spatials[cc] and cc:GetSummonType()==SUMMON_TYPE_SPECIAL+500 --[[and cc:GetFlagEffectLabel(500)>0]] then
			cc:SwitchSpace()
			-- local ct=cc:GetFlagEffectLabel(500)
			-- if ct==1 then cc:ResetFlagEffect(500)
			-- else cc:SetFlagEffectLabel(500,cc:GetFlagEffectLabel(500)-1) end
			if cc:IsPosition(POS_FACEUP_DEFENSE) then return
			else
				if au and au>0 then au=POS_FACEUP_DEFENSE end
				if ad and ad>0 then ad=POS_FACEUP_DEFENSE end
				if du and du>0 then du=POS_FACEUP_DEFENSE end
				if dd and dd>0 then dd=POS_FACEUP_DEFENSE end
			end
		end
	end
	change_position(cc,au,ad,du,dd)
	if exg then change_position(exg,eau,ead,edu,edd) end
end
--Custom Functions
function Card.SwitchSpace(c)
	Auxiliary.Spatials[c]=nil
	local tcode=c.spt_another_space or c.spt_origin_space
	c:SetEntityCode(tcode,true)
	c:ReplaceEffect(tcode,0,0)
	Duel.SetMetatable(c,_G["c"..tcode])
	Auxiliary.AddOrigSpatialType(c)
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
	-- local reqmats={}
--[[local extramat,min,max
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
	if not extramat then extramat,min,max=aux.FALSE,0,0 end]]
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
	ge4:SetTarget(Auxiliary.SpatialToGraveReplace)
	c:RegisterEffect(ge4)
end
function Auxiliary.SpatialToGraveReplace(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsLocation(LOCATION_REMOVED)==0 and c:GetDestination()==LOCATION_GRAVE end
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
	return sg:IsExists(Auxiliary.SptMatCheckRecursive,1,nil,sg,Group.CreateGroup(),adiff,ddiff) and (not sptcheck or sptcheck(sg,sptc,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,sptc)>0--Duel.GetMatchingGroupCount(Auxiliary.FilterFromEx,tp,LOCATION_MZONE,0,nil,tp)
end
-- function Auxiliary.FilterFromEx(c,tp)
	-- return c:GetSequence()>4 or Duel.IsExistingMatchingCard(function(c,tc) return c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(tc) end,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
-- end
function Auxiliary.SptMatCheckRecursive(c,mg,sg,adiff,ddiff,fc)
	sg:AddCard(c)
	local res,diff
	if fc and mg:FilterCount(aux.TRUE,sg)==0 then
		if adiff then
			diff=math.abs(c:GetAttack()-fc:GetAttack())
			res=diff>0 and diff<=adiff
		end
		if ddiff then
			diff=math.abs(c:GetDefense()-fc:GetDefense())
			res=res and diff>0 and diff<=ddiff
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
