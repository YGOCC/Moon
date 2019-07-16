--coded by Lyris
--調波召喚
--Not yet finalized values
--Custom constants
EFFECT_CANNOT_BE_HARMONIZED_MATERIAL=531
TYPE_HARMONY						=0x80000000000
TYPE_CUSTOM							=TYPE_CUSTOM|TYPE_HARMONY
CTYPE_HARMONY						=0x800
CTYPE_CUSTOM						=CTYPE_CUSTOM|CTYPE_HARMONY

--Custom Type Table
Auxiliary.Harmonies={} --number as index = card, card as index = function() is_synchro

--overwrite constants
TYPE_EXTRA							=TYPE_EXTRA|TYPE_HARMONY

--overwrite functions
local get_type, get_orig_type, get_prev_type_field =
Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField
Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Harmonies[c] then
		tpe=tpe|TYPE_HARMONY
		if not Auxiliary.Harmonies[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Harmonies[c] then
		tpe=tpe|TYPE_HARMONY
		if not Auxiliary.Harmonies[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Harmonies[c] then
		tpe=tpe|TYPE_HARMONY
		if not Auxiliary.Harmonies[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end

--Custom Functions
function Auxiliary.AddOrigHarmonyType(c,issynchro)
	table.insert(Auxiliary.Harmonies,c)
	Auxiliary.Customs[c]=true
	local issynchro=issynchro==nil and false or issynchro
	Auxiliary.Harmonies[c]=function() return issynchro end
end
function Auxiliary.AddHarmonyProc(c,ph,...)
	--ph - Phase to be used as Harmonized Material
	--... format - any number of materials  use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(Auxiliary.HarmonyCondition(...))
	ge2:SetTarget(Auxiliary.HarmonyTarget(...))
	ge2:SetOperation(Auxiliary.HarmonyOperation(ph))
	ge2:SetValue(531)
	c:RegisterEffect(ge2)
	local ge5=Effect.CreateEffect(c)
	ge5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_NO_TURN_RESET)
	ge5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ge5:SetCountLimit(1)
	ge5:SetRange(0xff)
	ge5:SetOperation(Auxiliary.HCheckReg)
	c:RegisterEffect(ge5)
end
function Auxiliary.HarmonizedMatFilter(c,sc,...)
	if not c:IsCanBeHarmonizedMaterial() then return false end
	local tef2={c:IsHasEffect(EFFECT_CANNOT_BE_HARMONIZED_MATERIAL)}
	for _,te2 in ipairs(tef2) do
		if te2:GetValue()(te2,ec) then return false end
	end
	for _,f in ipairs({...}) do
		if f(c,sc) then return true end
	end
	return false
end
function Auxiliary.HCheckRecursive(c,tp,mg,sg,ec,f,...)
	if f and not f(c,ec,sg) then return false end
	sg:AddCard(c)
	local res
	if ... then
		res=mg:IsExists(Auxiliary.HCheckRecursive,1,sg,tp,mg,sg,ec,...)
	else
		res=Auxiliary.HCheckGoal()(tp,sg,ec)
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.HarmonyCondition(...)
	local funs={...}
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if Duel.GetLocationCountFromEx(tp)<=0 then return false end
				local mg=Duel.GetMatchingGroup(Auxiliary.HarmonizedMatFilter,tp,LOCATION_REMOVED,0,nil,c,table.unpack(funs))
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.HCheckRecursive,1,sg,tp,mg,sg,c,table.unpack(funs))
			end
end
function Auxiliary.HarmonyTarget(...)
	local funs={...}
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.HarmonizedMatFilter,tp,LOCATION_REMOVED,0,nil,c,table.unpack(funs))
				local ct=#funs
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
						cg=mg:Filter(Auxiliary.HCheckRecursive,sg,tp,mg,sg,c,table.unpack(tempfun))
					else
						cg=Group.CreateGroup()
					end
					if cg:GetCount()==0 then break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
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
				if sg:GetCount()==ct then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					if sg:GetCount()>0 then goto restart end
					return false
				end
			end
end
function Auxiliary.HarmonyOperation(ph)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+0x2000000000)
				g:DeleteGroup()
				local p
				for i=0,9 do
					p=ph&1<<i
					if p>0 then
						Duel.SkipPhase(tp,p,RESET_PHASE+p,1)
					end
					ph=ph&~1<<i
					if ph==0 then break end
				end
			end
end
function Auxiliary.HCards(c)
	if not Auxiliary.Harmonies[c] then return false end
	if c:IsLocation(LOCATION_GRAVE) then return true end
	if c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	return c:IsFaceup() or c:IsLocation(LOCATION_EXTRA)
end
function Auxiliary.HCheckReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=1-c:GetOwner()
	local g=Duel.GetMatchingGroup(Auxiliary.HCards,p,0x70,0,nil)
	if g:GetCount()==0 then
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_SINGLE)
		ge7:SetRange(LOCATION_MZONE)
		ge7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		ge7:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
		c:RegisterEffect(ge7)
	end
	local ge8=Effect.CreateEffect(c)
	ge8:SetType(EFFECT_TYPE_SINGLE)
	ge8:SetCode(EFFECT_SPSUMMON_COST)
	ge8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ge8:SetCost(Auxiliary.HCheck)
	ge8:SetOperation(Auxiliary.HCheckOp)
	c:RegisterEffect(ge8)
	local ge9=ge8:Clone()
	ge9:SetCode(EFFECT_FLIPSUMMON_COST)
	c:RegisterEffect(ge9)
end
function Auxiliary.HCheck(e,c,tp)
	local p=e:GetHandler():GetOwner()
	return p~=tp and Duel.IsExistingMachingCard(Auxiliary.HCards,tp,0x70,0,1,nil)
end
function Auxiliary.HCheckOp(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	if not Duel.IsExistingMachingCard(Auxiliary.HCards,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		Duel.ConfirmCards(1-p,Duel.GetFirstMachingCard(Auxiliary.HCards,p,LOCATION_EXTRA,0,nil))
	end
end
