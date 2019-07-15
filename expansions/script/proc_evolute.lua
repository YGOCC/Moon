--created by Chahine, coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_STAGE						=388		--
EFFECT_CANNOT_BE_EVOLUTE_MATERIAL	=389	 --
EFFECT_EXTRA_EVOLUTE_MATERIAL		=390
EFFECT_EVOLUTE_LEVEL				=391
EFFECT_MUST_BE_EVOLUTE_MATERIAL		=392
EFFECT_CONVERGENT_EVOLUTE			=393
TYPE_EVOLUTE						=0x100000000
TYPE_CUSTOM							=TYPE_CUSTOM|TYPE_EVOLUTE
CTYPE_EVOLUTE						=0x1
CTYPE_CUSTOM						=CTYPE_CUSTOM|CTYPE_EVOLUTE

SUMMON_TYPE_EVOLUTE					=SUMMON_TYPE_SPECIAL+388

--Custom Type Table
Auxiliary.Evolutes={} --number as index = card, card as index = function() is_xyz

--overwrite constants
TYPE_EXTRA							=TYPE_EXTRA|TYPE_EVOLUTE

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
Card.IsRank=function(c,...)
	if Auxiliary.Evolutes[c] and not Auxiliary.Evolutes[c]() then return false end
	local funs={...}
	for key,value in pairs(funs) do
		if c:GetRank()==value then return true end
	end
	return false
	--return is_rank(c,rk)
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
GLOBAL_E_COUNTER={0,0}
GLOBAL_E_COUNTER[0]=0
GLOBAL_E_COUNTER[1]=0
function Auxiliary.AddECounter(p,ct)
	GLOBAL_E_COUNTER[p]=GLOBAL_E_COUNTER[p]+ct
	Duel.Hint(HINT_NUMBER,p,GLOBAL_E_COUNTER[p])
	Duel.Hint(HINT_NUMBER,1-p,GLOBAL_E_COUNTER[p])
	--TODO: Figure out how to make this work?
	--Duel.Hint(HINT_MESSAGE,p,1550,GLOBAL_E_COUNTER[p])
	--Duel.Hint(HINT_MESSAGE,1-p,1550,GLOBAL_E_COUNTER[p])
end
function Auxiliary.GetECounter(p)
	return GLOBAL_E_COUNTER[p]
end
function Card.AddEC(c,ct,p)
	c:AddCounter(0x1088,ct)
	if p then Auxiliary.AddECounter(p,ct) end
	--TODO: Remove once all Evolutes are updated
	--c:AddCounter(0x88,ct)
end
function Card.GetEC(c)
	return c:GetCounter(0x1088)
end
function Card.RefillEC(c)
	local val=0
	if c:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE) then
		local cone={c:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE)}
		for _,te in ipairs(cone) do
			val = val+te:GetValue()
		end
	else
		val = c:GetStage() - c:GetEC()
	end
	c:AddEC(val,c:GetControler())
	return val
end
function Card.IsCanRemoveEC(c,p,ct,r)
--  if Auxiliary.GetECounter(p)>=ct then return true end
	return c:IsCanRemoveCounter(p,0x1088,ct,REASON_COST)
end
function Duel.IsCanRemoveEC(p,s,o,ct,r)
--  if Auxiliary.GetECounter(p)>=ct then return true end
	return Duel.IsCanRemoveCounter(p,s,o,0x1088,ct,r)
end
function Card.RemoveEC(c,p,ct,r)
	if Auxiliary.GetECounter(p)>0 then
		Auxiliary.AddECounter(p,-ct)
	end
	if ct>0 then c:RemoveCounter(p,0x1088,ct,r) end
end
function Duel.RemoveEC(p,s,o,ct,r)
	if Auxiliary.GetECounter(p)>=ct then
		Auxiliary.AddECounter(p,-ct)
	end
	if ct>0 then Duel.RemoveCounter(p,s,o,0x1088,ct,r) end
end
function Card.IsCanBeEvoluteMaterial(c,ec)
	if c:GetLevel()<=0 and c:GetRank()<=0 and not c:IsStatus(STATUS_NO_LEVEL) then return false end
	if not c:IsLocation(LOCATION_MZONE) then
		local tef1={c:IsHasEffect(EFFECT_EXTRA_EVOLUTE_MATERIAL)}
		local ValidSubstitute=false
		for _,te1 in ipairs(tef1) do
			local con=te1:GetCondition()
			if con(c,ec,1) then ValidSubstitute=true end
		end
		if not ValidSubstitute then return false end
	else
		if c:IsFacedown() then return false end
	end
	local tef2={c:IsHasEffect(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)}
	for _,te2 in ipairs(tef2) do
		if te2:GetValue()(te2,ec) then return false end
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
	if type(echeck)=='function' then table.insert(t,echeck) end
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
	end
	if not extramat then extramat,min,max=aux.FALSE,#t,#t end
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_SINGLE)
	r1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	r1:SetCode(EFFECT_CANNOT_TURN_SET)
	r1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(r1)
	
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
	e2:SetCondition(Auxiliary.EvoluteCondition(echeck,extramat,min,max,table.unpack(t)))
	e2:SetTarget(Auxiliary.EvoluteTarget(echeck,extramat,min,max,table.unpack(t)))
	e2:SetOperation(Auxiliary.EvoluteOperation)
	e2:SetValue(SUMMON_TYPE_EVOLUTE)
	c:RegisterEffect(e2)
	if (type(echeck)=='string') and echeck=="Convergent" then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CONVERGENT_EVOLUTE)
		c:RegisterEffect(e3)
	end
	if not Evochk then
		Evochk=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(Auxiliary.EvoluteCounter)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge2:SetCode(EFFECT_COUNTER_PERMIT+0x88)
		ge2:SetTarget(function(e,c)return c:IsType(TYPE_EVOLUTE) end)
		ge2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		ge2:SetValue(LOCATION_MZONE)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge3:SetCode(EFFECT_RCOUNTER_REPLACE+0x88)
		ge3:SetCondition(Auxiliary.ECounterUseCon)
		ge3:SetOperation(Auxiliary.ECounterUseOp)
		Duel.RegisterEffect(ge3,0)
		--Cannot be Summoned Face-down
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD)
		ge4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge4:SetTargetRange(1,1)
		ge4:SetTarget(Auxiliary.FaceDownEvoluteLimit)
		Duel.RegisterEffect(ge4,tp)
	end
end
--Cannot be Summoned Face-down
function Auxiliary.FaceDownEvoluteLimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (c:IsType(TYPE_EVOLUTE) and (sumpos==POS_FACEDOWN_ATTACK or sumpos==POS_FACEDOWN_DEFENSE))
end
--E-C Replace
function Auxiliary.ECounterUseCon(e,tp,eg,ep,ev,re,r,rp)
	return Auxiliary.GetECounter(tp)>=ev
end
function Auxiliary.ECounterUseOp(e,tp,eg,ep,ev,re,r,rp)
	Auxiliary.AddECounter(tp,-ev)
end
function Auxiliary.StageVal(stage)
	return  function(e,c)
				local stage=stage
				--insert modifications here
				return stage
			end
end
function Card.GetValueForEvolute(c,ec)
	return Auxiliary.EvoluteValue(c,ec)
end
function Auxiliary.EvoluteValue(c,ec)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	if c:IsHasEffect(EFFECT_EVOLUTE_LEVEL) then
		local tef={c:IsHasEffect(EFFECT_EVOLUTE_LEVEL)}
		for _,te in ipairs(tef) do
			return te:GetValue()(te,ec)
		end
	end
	if lv>0 or c:IsStatus(STATUS_NO_LEVEL) then
		return lv+0x10000*rk
	else
		return rk+0x10000*lv
	end
end
function Auxiliary.EvoluteRecursiveFilter(c,tp,sg,mg,ec,ct,minc,maxc,...)
	sg:AddCard(c)
	if not (c.EvoFakeMaterial and c.EvoFakeMaterial()) then ct=ct+1 end
	
	local res=Auxiliary.EvoluteCheckGoal(tp,sg,ec,minc,ct,...)
		or (ct<maxc and mg:IsExists(Auxiliary.EvoluteRecursiveFilter,1,sg,tp,sg,mg,ec,ct,minc,maxc,...))
	sg:RemoveCard(c)
	if not (c.EvoFakeMaterial and c.EvoFakeMaterial()) then ct=ct-1 end
	return res
end
function Auxiliary.EvoluteCheckGoal(tp,sg,ec,minc,ct,...)
	local funs={...}
	for _,f in pairs(funs) do
		if not sg:IsExists(f,1,nil) then return false end
	end
	return ct>=minc and (ec:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE) or sg:CheckWithSumEqual(Auxiliary.EvoluteValue,ec:GetStage(),ct,ct,ec)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0
end
function Auxiliary.EvoluteCondition(outdate1,outdate2,min,max,...)
	local funs={...}
	return  function(e,c)
				if c==nil then return true end
				if (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_PANDEMONIUM)) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Auxiliary.GetEvoluteMaterials(c,tp)
				return mg:IsExists(Auxiliary.EvoluteRecursiveFilter,1,nil,tp,Group.CreateGroup(),mg,c,0,min,max,table.unpack(funs))
			end
end
function Auxiliary.GetEvoluteMaterials(ec,tp)
	return Duel.GetMatchingGroup(Card.IsCanBeEvoluteMaterial,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_FZONE,0,nil,ec)
end
function Auxiliary.EvoluteTarget(outdate1,outdate2,minc,maxc,...)
	local funs={...}
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Auxiliary.GetEvoluteMaterials(c,tp)
				local bg=Group.CreateGroup()
				local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_EVOLUTE_MATERIAL)}
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
				while not (sg:GetCount()>=maxc) do
					finish=Auxiliary.EvoluteCheckGoal(tp,sg,c,minc,#sg,table.unpack(funs))
					local cg=mg:Filter(Auxiliary.EvoluteRecursiveFilter,sg,tp,sg,mg,c,#sg,minc,maxc,table.unpack(funs))
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if (sg:GetCount()>=maxc) then finish=true end
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
function Auxiliary.EvoluteOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local tc=g:GetFirst()
	local lvTotal=0
	while tc do
		lvTotal = lvTotal + tc:GetValueForEvolute(c)
		if not tc:IsLocation(LOCATION_MZONE) then
			local tef={tc:IsHasEffect(EFFECT_EXTRA_EVOLUTE_MATERIAL)}
			for _,te in ipairs(tef) do
				local op=te:GetOperation()
				op(tc,tp)
			end
		else
			Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
		end
		tc=g:GetNext()
	end
	--Set Maximum for Convergents
	local cone={c:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE)}
	for _,te in ipairs(cone) do
		te:SetValue(lvTotal)
	end
	g:DeleteGroup()
end
function Auxiliary.ECSumFilter(c)
	return c:IsSummonType(SUMMON_TYPE_EVOLUTE) and c:IsType(TYPE_EVOLUTE)
end
function Auxiliary.EvoluteCounter(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=eg:Filter(Auxiliary.ECSumFilter,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE) then tc:AddEC(tc:GetStage(),tp) end
		if tc:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE) then 
			local cone={tc:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE)}
			for _,te in ipairs(cone) do
				tc:AddEC(te:GetValue(),tp)
			end
			--[[local mg=tc:GetMaterial()
			local mc=mg:GetFirst()
			local val=0
			while mc do
				val = val+mc:GetValueForEvolute(tc)
				mc=mg:GetNext()
			end
			tc:AddEC(val)]]
		end
		tc=g:GetNext()
	end
end
