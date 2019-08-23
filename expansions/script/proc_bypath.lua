--coded by Lyris
--バイパス召喚
--Not yet finalized values
--Custom constants
EFFECT_CELL							=686
EFFECT_CANNOT_BE_BYPATH_MATERIAL	=687
TYPE_BYPATH							=0x200000000000
TYPE_CUSTOM							=TYPE_CUSTOM|TYPE_BYPATH
CTYPE_BYPATH						=0x2000
CTYPE_CUSTOM						=CTYPE_CUSTOM|CTYPE_BYPATH

--Custom Type Table
Auxiliary.Bypaths={} --number as index = card, card as index = function() is_xyz
Auxiliary.BypathSeqs={}
table.insert(aux.CannotBeEDMatCodes,EFFECT_CANNOT_BE_BYPATH_MATERIAL)

--overwrite constants
TYPE_EXTRA							=TYPE_EXTRA|TYPE_BYPATH

--overwrite functions
local get_rank, get_orig_rank, prev_rank_field, is_rank, is_rank_below, is_rank_above, get_type, get_orig_type, get_prev_type_field = 
	Card.GetRank, Card.GetOriginalRank, Card.GetPreviousRankOnField, Card.IsRank, Card.IsRankBelow, Card.IsRankAbove, Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField

Card.GetRank=function(c)
	if Auxiliary.Bypaths[c] then return 0 end
	return get_rank(c)
end
Card.GetOriginalRank=function(c)
	if Auxiliary.Bypaths[c] and not Auxiliary.Bypaths[c]() then return 0 end
	return get_orig_rank(c)
end
Card.GetPreviousRankOnField=function(c)
	if Auxiliary.Bypaths[c] and not Auxiliary.Bypaths[c]() then return 0 end
	return prev_rank_field(c)
end
Card.IsRank=function(c,...)
	if Auxiliary.Bypaths[c] and not Auxiliary.Bypaths[c]() then return false end
	local funs={...}
	for key,value in pairs(funs) do
		if c:GetRank()==value then return true end
	end
	return false
end
Card.IsRankBelow=function(c,rk)
	if Auxiliary.Bypaths[c] and not Auxiliary.Bypaths[c]() then return false end
	return is_rank_below(c,rk)
end
Card.IsRankAbove=function(c,rk)
	if Auxiliary.Bypaths[c] and not Auxiliary.Bypaths[c]() then return false end
	return is_rank_above(c,rk)
end
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Bypaths[c] then
		tpe=tpe|TYPE_BYPATH
		if not Auxiliary.Bypaths[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Bypaths[c] then
		tpe=tpe|TYPE_BYPATH
		if not Auxiliary.Bypaths[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Bypaths[c] then
		tpe=tpe|TYPE_BYPATH
		if not Auxiliary.Bypaths[c]() then
			tpe=tpe&~TYPE_XYZ
		end
	end
	return tpe
end

--Custom Functions
function Card.GetCell(c)
	if not Auxiliary.Bypaths[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_CELL)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsCanBeBypathMaterial(c,bc)
	if c:IsFacedown() then return false end
	local tef2={bc:IsHasEffect(EFFECT_CANNOT_BE_BYPATH_MATERIAL)}
	for _,te2 in ipairs(tef2) do
		if te2:GetValue()(te2,c) then return false end
	end
	return true
end
function Auxiliary.AddOrigBypathType(c,isxyz)
	table.insert(Auxiliary.Bypaths,c)
	Auxiliary.Customs[c]=true
	local isxyz=isxyz==nil and false or isxyz
	Auxiliary.Bypaths[c]=function() return isxyz end
	Auxiliary.BypathSeqs[c]={}
end
function Auxiliary.AddBypathProc(c,cell,minc,maxc,...)
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CELL)
	e1:SetValue(Auxiliary.CellVal(cell))
	c:RegisterEffect(e1)
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(Auxiliary.BypathCondition(minc,maxc,...))
	ge2:SetTarget(Auxiliary.BypathTarget(minc,maxc,...))
	ge2:SetOperation(Auxiliary.BypathOperation)
	ge2:SetValue(0x26)
	c:RegisterEffect(ge2)
	if not BYPATH_CHECKLIST then
		BYPATH_CHECKLIST=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(function() BYPATH_CHECKLIST=0 end)
		Duel.RegisterEffect(ge1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(Auxiliary.GBypathCon)
	e2:SetOperation(Auxiliary.GBypathOp)
	e2:SetValue(Auxiliary.GBypathVal)
	c:RegisterEffect(e2)
end
function Auxiliary.CellVal(cell)
	return	function(e,c)
				local ce=cell
				--insert modifications here
				return ce
			end
end
function Auxiliary.ByCheckRecursive(c,tp,sg,mg,bc,min,max,ct,...)
	sg:AddCard(c)
	ct=ct+1
	local res=Auxiliary.ByCheckGoal(tp,sg,bc,min,ct,...)
		or (ct<max and mg:IsExists(Auxiliary.ByCheckRecursive,1,sg,tp,sg,mg,bc,min,max,ct,...))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.ByCheckGoal(tp,sg,bc,min,ct,...)
	local funs={...}
	for i=1,#funs do
		if not sg:IsExists(funs[i],ct,nil) then return false end
	end
	return ct>=min and Duel.GetLocationCountFromEx(tp,tp,sg,bc)>0 and sg:IsExists(Card.IsCanBeBypathMaterial,ct,nil,bc) and sg:IsExists(Auxiliary.ByGoalCheck,1,nil,sg,Group.CreateGroup())
end
function Auxiliary.ByGoalCheck(c,mg,sg,fc)
	sg:AddCard(c)
	local seq=c:GetSequence()
	local res
	if fc then
		if seq<5 then
			res=math.abs(seq-fc:GetSequence())==1
		else res=fc:GetColumnGroup():IsContains(c) end
	else res=mg:IsExists(Auxiliary.ByGoalCheck,1,sg,mg,sg,c) end
	sg:RemoveCard(c)
	return not res
end
function Auxiliary.BypathCondition(min,max,...)
	local funs={...}
	if not min then min=2 end
	if not max then max=99 end
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM+TYPE_PANDEMONIUM+TYPE_RELAY) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
				local sg=Group.CreateGroup()
				return g:IsExists(Auxiliary.ByCheckRecursive,1,nil,tp,sg,g,c,min,max,0,table.unpack(funs))
			end
end
function Auxiliary.BypathTarget(min,max,...)
	local funs={...}
	if not min then min=2 end
	if not max then max=99 end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local t=Auxiliary.BypathSeqs[c]
				while #t>0 do table.remove(t) end
				local mg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
				local sg=Group.CreateGroup()
				local finish=false
				while not (sg:GetCount()>=max) do
					finish=Auxiliary.ByCheckGoal(tp,sg,c,min,#sg,table.unpack(funs))
					local cg=mg:Filter(Auxiliary.ByCheckRecursive,sg,tp,sg,mg,c,min,max,#sg,table.unpack(funs))
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
					if not tc then break end
					local seq=tc:GetSequence()
					if tc:GetControler()~=tp and seq<5 then seq=4-seq end
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
						t[tc]=seq
						if (sg:GetCount()>=max) then finish=true end
					else
						sg:RemoveCard(tc)
						t[tc]=nil
					end
				end
				if finish then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.BypathOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	for tc in aux.Next(mg) do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetLabelObject(c)
	e1:SetCondition(function(e,tp,eg) return eg:GetFirst()==e:GetLabelObject() end)
	e1:SetOperation(Auxiliary.BypathOnSummon)
	Duel.RegisterEffect(e1,tp)
end
function Auxiliary.BypathOnSummon(e,tp)
	local c=e:GetLabelObject()
	local t=Auxiliary.BypathSeqs[c]
	local flag=0
	local mg=c:GetMaterial()
	for tc in aux.Next(mg) do
		for i,sq in pairs(t) do
			if i then
				flag=flag|0x1<<sq
			end
		end
	end
	flag=flag~0xff
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	e:Reset()
end
function Auxiliary.ByConditionFilter(c,e,tp,cell1,cell2,zone)
	if c:IsType(TYPE_LINK) then return false end
	local lv=c:GetIndicatorValue()
	return lv>=cell1 and lv<=cell2 and not c:IsForbidden()
		and (c:IsType(TYPE_EXTRA) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+0x26,tp,true,true) or
		c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+0x26,tp,true,true,POS_FACEUP,tp,zone))
end
function Auxiliary.ByOperationCheck(ft1,ft2)
	return	function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mg=g-exg
				return #exg<=ft2 and #mg<=ft1
			end
end
function Auxiliary.GBypathCon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if BYPATH_CHECKLIST&(0x1<<tp)~=0 then return false end
	local seq1=c:GetSequence()
	local cell1=c:GetCell()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_EXTRA,0)
	if seq1<5 then
		local rpz=Duel.GetFirstMatchingCard(function(tc) return tc:IsFaceup() and tc:IsType(TYPE_BYPATH) end,tp,LOCATION_MZONE,0,c)
		if rpz==nil then return false end
		local zone=0
		for i=seq1,rpz:GetSequence() do zone=zone|2^i end
		local cell2=rpz:GetCell()
		if cell1>cell2 then cell1,cell2=cell2,cell1 end
		return g:IsExists(Auxiliary.ByConditionFilter,1,nil,e,tp,cell1,cell2,zone)
	else return g:IsExists(Auxiliary.ByConditionFilter,1,nil,e,tp,1,cell1,c:GetColumnZone(LOCATION_MZONE,0,0,tp)) end
end
function Auxiliary.GBypathOp(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local seq1=c:GetSequence()
	local cell1,rpz,cell2=c:GetCell()
	local zone=0
	if seq1<5 then
		rpz=Duel.GetFirstMatchingCard(function(tc) return tc:IsFaceup() and tc:IsType(TYPE_BYPATH) end,tp,LOCATION_MZONE,0,c)
		for i=seq1,rpz:GetSequence() do zone=zone|2^i end
		cell2=rpz:GetCell()
	else zone=c:GetColumnZone(LOCATION_MZONE,0,0,tp) cell2=1 end
	if cell1>cell2 then cell1,cell2=cell2,cell1 end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)
	local ft2=1
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
	end
	local tg=Duel.GetMatchingGroup(Auxiliary.ByConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,cell1,cell2,zone)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Auxiliary.GCheckAdditional=Auxiliary.ByOperationCheck(ft1,ft2)
	local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft1))
	Auxiliary.GCheckAdditional=nil
	if not g then return end
	sg:Merge(g)
	BYPATH_CHECKLIST=BYPATH_CHECKLIST|(0x1<<tp)
	local hg=Group.FromCards(c)
	if rpz~=nil then hg=hg+rpz end
	Duel.HintSelection(hg)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
	e0:SetTargetRange(LOCATION_EXTRA,0)
	e0:SetValue(1)
	Duel.RegisterEffect(e0,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) e0:Reset() e:Reset() end)
	Duel.RegisterEffect(e2,tp)
	-----
	Duel.AdjustInstantly()
	for tc in aux.Next(g) do Duel.SpecialSummonStep(tc,SUMMON_TYPE_SPECIAL+0x26,tp,tp,true,true,POS_FACEUP,zone) end
	Duel.SpecialSummonComplete()
end
function Auxiliary.GBypathVal(e,c)
	local seq1=e:GetHandler():GetSequence()
	local rpz=Duel.GetFirstMatchingCard(function(tc) return tc:IsFaceup() and tc:IsType(TYPE_BYPATH) end,tp,LOCATION_MZONE,0,e:GetHandler())
	local zone=0
	if seq1<5 and rpz then
		for i=seq1,rpz:GetSequence() do zone=zone|2^i end
	else zone=e:GetHandler():GetColumnZone(LOCATION_MZONE,0,0,tp) end
	return 0x26,zone
end
