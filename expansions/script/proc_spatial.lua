--coded by Lyris
--スペーシュル召喚
--Not yet finalized values
--Custom constants
EFFECT_DIMENSION_NUMBER			=500
EFFECT_CANNOT_BE_SPACE_MATERIAL	=501
EFFECT_MUST_BE_SPACE_MATERIAL	=502
EFFECT_EXTRA_SPACE_MATERIAL		=503
TYPE_SPATIAL					=0x800000000
TYPE_CUSTOM						=TYPE_CUSTOM|TYPE_SPATIAL
CTYPE_SPATIAL					=0x8
CTYPE_CUSTOM					=CTYPE_CUSTOM|CTYPE_SPATIAL
SUMMON_TYPE_SPATIAL				=SUMMON_TYPE_SPECIAL+500
REASON_SPATIAL					=0x80000000

--Custom Type Table
Auxiliary.Spatials={} --number as index = card, card as index = function() is_xyz
table.insert(aux.CannotBeEDMatCodes,EFFECT_CANNOT_BE_SPACE_MATERIAL)

--overwrite constants
TYPE_EXTRA						=TYPE_EXTRA|TYPE_SPATIAL

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
Card.IsRank=function(c,...)
	if Auxiliary.Spatials[c] and not Auxiliary.Spatials[c]() then return false end
	local funs={...}
	for key,value in pairs(funs) do
		if c:GetRank()==value then return true end
	end
	return false
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
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
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
	if not ad then ad=au end if not du then du=au end if not dd then dd=au end
	local cc=Group.CreateGroup()+cc
	local tg=cc:Clone()
	for c in aux.Next(tg) do
		if ((c:IsPosition(POS_FACEUP_ATTACK) and bit.band(au,POS_FACEDOWN_ATTACK+POS_FACEDOWN_DEFENSE)>0)
		or (c:IsPosition(POS_FACEUP_DEFENSE) and bit.band(du,POS_FACEDOWN_ATTACK+POS_FACEDOWN_DEFENSE)>0))
		and c:SwitchSpace() then cc=cc-c end
	end
	return change_position(cc,au,ad,du,dd)
end

--Custom Functions
function Card.SwitchSpace(c)
	if not Auxiliary.Spatials[c] or not c:IsSummonType(SUMMON_TYPE_SPATIAL) or c:GetFlagEffect(500)==0 then return false end
	Auxiliary.Spatials[c]=nil
	local mt=_G["c" .. c:GetOriginalCode()]
	local ospc=mt.spt_other_space
	if not ospc then ospc=Duel.ReadCard(c:GetOriginalCode(),CARDDATA_ALIAS) end
	if ospc==0 then return false end
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
	if c:IsOnField() and not c:IsFaceup() then return false end
	local tef={c:IsHasEffect(EFFECT_CANNOT_BE_SPACE_MATERIAL)}
	for _,te in ipairs(tef) do
		if (type(te:GetValue())=="function" and te:GetValue()(te,spct)) or te:GetValue()==1 then return false end
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
	--... format - any number of materials  use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local t={...}
	local list={}
	local min,max
	for i=1,#t do
		if type(t[#t])=='number' then
			max=t[#t]
			table.remove(t)
			if type(t[#t])=='number' then
				min=t[#t]
				table.remove(t)
			else
				min=max
				max=99
			end
			table.insert(list,{t[#t],min,max})
			table.remove(t)
		end
		if #t<2 then break end
	end
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_SINGLE)
	ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ge1:SetCode(EFFECT_DIMENSION_NUMBER)
	ge1:SetValue(Auxiliary.DimensionNoVal(djn))
	c:RegisterEffect(ge1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(Auxiliary.SpatialCondition(sptcheck,adiff,ddiff,table.unpack(list)))
	ge2:SetTarget(Auxiliary.SpatialTarget(sptcheck,adiff,ddiff,table.unpack(list)))
	ge2:SetOperation(Auxiliary.SpatialOperation)
	ge2:SetValue(SUMMON_TYPE_SPATIAL)
	c:RegisterEffect(ge2)
	local ge3=Effect.CreateEffect(c)
	ge3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge3:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsSummonType(SUMMON_TYPE_SPATIAL) then
			c:RegisterFlagEffect(500,RESET_EVENT+RESETS_STANDARD,0,1,djn)
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
	return  function(e,c)
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
function Auxiliary.SptCheckRecursive(c,tp,sg,mg,sptc,ct,djn,sptcheck,adiff,ddiff,...)
	sg:AddCard(c)
	ct=ct+1
	local funs,max,chk={...},0
	for i=1,#funs do
		max=max+funs[i][3]
		if funs[i][1](c) then
			chk=true
		end
	end
	if max>99 then max=99 end
	local res=chk and (Auxiliary.SptCheckGoal(tp,sg,sptc,ct,adiff,ddiff,sptcheck,...)
		or (ct<max and mg:IsExists(Auxiliary.SptCheckRecursive,1,sg,tp,sg,mg,sptc,ct,djn,sptcheck,adiff,ddiff,...)))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.SptCheckGoal(tp,sg,sptc,ct,adiff,ddiff,sptcheck,...)
	local funs,min={...},0
	for i=1,#funs do
		if not sg:IsExists(funs[i][1],funs[i][2],nil) then return false end
		min=min+funs[i][2]
	end
	return ct>=min and sg:IsExists(Auxiliary.SptMatCheckRecursive,1,nil,sg,Group.CreateGroup(),adiff,ddiff) and (not sptcheck or sptcheck(sg,sptc,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,sptc)>0
		and not sg:IsExists(Auxiliary.SpaceUncompatibilityFilter,1,nil,sg,spct,tp)
end
function Auxiliary.SpaceUncompatibilityFilter(c,sg,spct,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not Auxiliary.SpaceCheckOtherMaterial(c,mg,spct,tp)
end
function Auxiliary.SpaceCheckOtherMaterial(c,mg,spct,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_SPACE_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and type(f)=="function" and not f(te,spct,mg) then return false end
	end
	return true
end
function Auxiliary.SptMatCheckRecursive(c,mg,sg,adiff,ddiff,fc)
	if not adiff and not ddiff then return true end
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
function Auxiliary.SpaceExtraFilter(c,lc,tp,...)
	local flist={...}
	local check=false
	for i=1,#flist do
		if flist[i][1](c) then
			check=true
		end
	end
	local tef1={c:IsHasEffect(EFFECT_EXTRA_SPACE_MATERIAL,tp)}
	local ValidSubstitute=false
	for _,te1 in ipairs(tef1) do
		local con=te1:GetCondition()
		if (not con or con(c,lc,1)) then ValidSubstitute=true end
	end
	if not ValidSubstitute then return false end
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	return c:IsCanBeSpaceMaterial(lc) and (not flist or #flist<=0 or check)
end
function Auxiliary.SpatialCondition(sptcheck,adiff,ddiff,...)
	local funs={...}
	return  function(e,c)
				if c==nil then return true end
				if (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_PANDEMONIUM)) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local djn=c:GetDimensionNo()
				local mg=Duel.GetMatchingGroup(Card.IsCanBeSpaceMaterial,tp,LOCATION_MZONE,0,nil,c)
				local mg2=Duel.GetMatchingGroup(Auxiliary.SpaceExtraFilter,tp,0xff,0xff,nil,c,tp,table.unpack(funs))
				if mg2:GetCount()>0 then mg:Merge(mg2) end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_SPACE_MATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.SptCheckRecursive,1,nil,tp,sg,mg,c,0,djn,sptcheck,adiff,ddiff,table.unpack(funs))
			end
end
function Auxiliary.SpatialTarget(sptcheck,adiff,ddiff,...)
	local funs,min,max={...},0,0
	for i=1,#funs do min=min+funs[i][2] max=max+funs[i][3] end
	if max>99 then max=99 end
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Card.IsCanBeSpaceMaterial,tp,LOCATION_MZONE,0,nil,c)
				local mg2=Duel.GetMatchingGroup(Auxiliary.SpaceExtraFilter,tp,0xff,0xff,nil,c,tp,table.unpack(funs))
				if mg2:GetCount()>0 then mg:Merge(mg2) end
				local bg=Group.CreateGroup()
				local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_BIGBANG_MATERIAL)}
				for _,te in ipairs(ce) do
					local tc=te:GetHandler()
					if tc then bg:AddCard(tc) end
				end
				if #bg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					bg:Select(tp,#bg,#bg,nil)
				end
				local sg=Group.CreateGroup()
				sg:Merge(bg)
				local finish=false
				local djn=c:GetDimensionNo()
				while not (sg:GetCount()>=max) do
					finish=Auxiliary.SptCheckGoal(tp,sg,c,#sg,adiff,ddiff,sptcheck,table.unpack(funs))
					local cg=mg:Filter(Auxiliary.SptCheckRecursive,sg,tp,sg,mg,c,#sg,djn,sptcheck,adiff,ddiff,table.unpack(funs))
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if (sg:GetCount()>=max) then finish=true end
						else
							sg:RemoveCard(tc)
						end
					elseif #bg>0 and #sg<=#bg then
						return false
					end
				end
				if finish then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.SpatialOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local tc=g:GetFirst()
	while tc do
		if c:IsHasEffect(EFFECT_EXTRA_SPACE_MATERIAL) then
			local tef={tc:IsHasEffect(EFFECT_EXTRA_SPACE_MATERIAL)}
			for _,te in ipairs(tef) do
				local op=te:GetOperation()
				if op then
					op(tc,tp)
				else
					Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+REASON_SPATIAL)
				end
			end
		else
			Duel.Remove(tc,POS_FACEUP,REASON_MATERIAL+REASON_SPATIAL)
		end
		tc=g:GetNext()
	end
	g:DeleteGroup()
end
