--created by Meedogh, coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_CANNOT_BE_BIGBANG_MATERIAL	=624
EFFECT_MUST_BE_BIGBANG_MATERIAL		=625
TYPE_BIGBANG						=0x8000000000
TYPE_CUSTOM							=TYPE_CUSTOM|TYPE_BIGBANG
CTYPE_BIGBANG						=0x80
CTYPE_CUSTOM						=CTYPE_CUSTOM|CTYPE_BIGBANG

--Custom Type Table
Auxiliary.Bigbangs={} --number as index = card, card as index = function() is_synchro

--overwrite constants
TYPE_EXTRA							=TYPE_EXTRA|TYPE_BIGBANG

--overwrite functions
local get_type, get_orig_type, get_prev_type_field = 
	Card.GetType, Card.GetOriginalType, Card.GetPreviousTypeOnField

Card.GetType=function(c,scard,sumtype,p)
	local tpe=scard and get_type(c,scard,sumtype,p) or get_type(c)
	if Auxiliary.Bigbangs[c] then
		tpe=tpe|TYPE_BIGBANG
		if not Auxiliary.Bigbangs[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if Auxiliary.Bigbangs[c] then
		tpe=tpe|TYPE_BIGBANG
		if not Auxiliary.Bigbangs[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if Auxiliary.Bigbangs[c] then
		tpe=tpe|TYPE_BIGBANG
		if not Auxiliary.Bigbangs[c]() then
			tpe=tpe&~TYPE_SYNCHRO
		end
	end
	return tpe
end

--Custom Functions
function Card.IsCanBeBigbangMaterial(c,ec)
	if c:IsType(TYPE_LINK) then return false end
	local tef={c:IsHasEffect(EFFECT_CANNOT_BE_BIGBANG_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,ec) then return false end
	end
	return true
end
function Card.GetVibe(c)
	---1 = Negative; +0 = Neutral; +1 = Positive
	local stat=c:GetAttack()-c:GetDefense()
	if stat==0 then return stat
	else return stat/math.abs(stat) end
end
function Card.GetBigbangAttack(c)
	return c:GetAttack()*c:GetVibe()
end
function Card.GetBigbangDefense(c)
	return c:GetDefense()*c:GetVibe()
end
function Auxiliary.AddOrigBigbangType(c,issynchro)
	table.insert(Auxiliary.Bigbangs,c)
	Auxiliary.Customs[c]=true
	local issynchro=issynchro==nil and false or issynchro
	Auxiliary.Bigbangs[c]=function() return issynchro end
end
function Auxiliary.AddBigbangProc(c,...)
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
	local ge2=Effect.CreateEffect(c)
	ge2:SetType(EFFECT_TYPE_FIELD)
	ge2:SetCode(EFFECT_SPSUMMON_PROC)
	ge2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge2:SetRange(LOCATION_EXTRA)
	ge2:SetCondition(Auxiliary.BigbangCondition(table.unpack(list)))
	ge2:SetTarget(Auxiliary.BigbangTarget(table.unpack(list)))
	ge2:SetOperation(Auxiliary.BigbangOperation)
	ge2:SetValue(624)
	c:RegisterEffect(ge2)
end
function Auxiliary.BigbangCondition(...)
	local funs={...}
	return  function(e,c)
				if c==nil then return true end
				if (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_PANDEMONIUM)) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(Card.IsCanBeBigbangMaterial,tp,LOCATION_MZONE,0,nil,c)
				return mg:IsExists(Auxiliary.BigbangRecursiveFilter,1,nil,tp,Group.CreateGroup(),mg,c,0,table.unpack(funs))
			end
end
function Auxiliary.BigbangRecursiveFilter(c,tp,sg,mg,bc,ct,...)
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
	local res=chk and (Auxiliary.BigbangCheckGoal(tp,sg,bc,ct,...)
		or (ct<max and mg:IsExists(Auxiliary.BigbangRecursiveFilter,1,sg,tp,sg,mg,bc,ct,...)))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.BigbangCheckGoal(tp,sg,bc,ct,...)
	local funs,min={...},0
	for i=1,#funs do
		if not sg:IsExists(funs[i][1],1,nil) then return false end
		min=min+funs[i][2]
	end
	return ct>=min and Duel.GetLocationCountFromEx(tp,tp,sg,bc)>0 and sg:GetSum(Card.GetBigbangAttack)>=bc:GetAttack() and sg:GetSum(Card.GetBigbangDefense)>=bc:GetDefense()
end
function Auxiliary.BigbangTarget(...)
	local funs,min,max={...},0,0
	for i=1,#funs do min=min+funs[i][2] max=max+funs[i][3] end
	if max>99 then max=99 end
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Card.IsCanBeBigbangMaterial,tp,LOCATION_MZONE,0,nil,c)
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
				while not (sg:GetCount()>=max) do
					finish=Auxiliary.BigbangCheckGoal(tp,sg,c,#sg,table.unpack(funs))
					local cg=mg:Filter(Auxiliary.BigbangRecursiveFilter,sg,tp,sg,mg,c,#sg,table.unpack(funs))
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
function Auxiliary.BigbangOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_DESTROY+REASON_MATERIAL+0x8000000000)
	g:DeleteGroup()
end
