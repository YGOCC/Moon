--Signore Antilementale Vermebuco Sanguisuga
--Script by XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
	--evolute proc (placeholder)
	aux.AddEvoluteProc(c,nil,9,cid.matfilter1,aux.FALSE,99,99)
	--custom evolute proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cid.EvoluteCondition(cid.extrag,3,99,cid.matfilter1))
	e1:SetTarget(cid.EvoluteTarget(cid.extrag,3,99,cid.matfilter1))
	e1:SetOperation(cid.EvoluteOperation)
	e1:SetValue(SUMMON_TYPE_EVOLUTE)
	c:RegisterEffect(e1)
	--change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(cid.poscost)
	e2:SetTarget(cid.postg)
	e2:SetOperation(cid.posop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+100)
	e3:SetTarget(cid.settg)
	e3:SetOperation(cid.setop)
	c:RegisterEffect(e3)
	--recycle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id+200)
	e4:SetCondition(cid.rccon)
	e4:SetTarget(cid.rctg)
	e4:SetOperation(cid.rcop)
	c:RegisterEffect(e4)
end
cid.custom_spproc={SUMMON_TYPE_EVOLUTE,"flipFD"}
--filters
function cid.matfilter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) or c:IsRace(RACE_SEASERPENT)
end
function cid.extrag(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_SEASERPENT)
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_EARTH)
end
function cid.setfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa6e) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
		and Duel.IsExistingMatchingCard(cid.scfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cid.scfilter(c,code)
	return c:IsSetCard(0xa6e) and c:IsAbleToRemove() and not c:IsCode(code)
end
function cid.rcfilter(c,attr)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xa6e) and c:GetAttribute()~=attr and c:IsAbleToHand()
end
--custom evolute proc
function cid.EvoluteRecursiveFilter(c,tp,sg,mg,ec,ct,minc,maxc,forcedmat)
	sg:AddCard(c)
	if not (c.EvoFakeMaterial and c.EvoFakeMaterial()) then ct=ct+1 end
	
	local res=cid.EvoluteCheckGoal(tp,sg,ec,minc,ct,forcedmat)
		or (ct<maxc and mg:IsExists(cid.EvoluteRecursiveFilter,1,sg,tp,sg,mg,ec,ct,minc,maxc,forcedmat))
	sg:RemoveCard(c)
	if not (c.EvoFakeMaterial and c.EvoFakeMaterial()) then ct=ct-1 end
	return res
end
function cid.EvoluteCheckGoal(tp,sg,ec,minc,ct,forcedmat)
	if forcedmat then
		if not sg:IsExists(forcedmat,1,nil) then return false end
	end
	return ct>=minc and (ec:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE) or sg:CheckWithSumEqual(Auxiliary.EvoluteValue,ec:GetStage(),ct,ct,ec)) and Duel.GetLocationCountFromEx(tp)>0
end
function cid.EvoluteCondition(forcedmat,min,max,...)
	local funs={...}
	return	function(e,c)
				if c==nil then return true end
				if (c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_PANDEMONIUM)) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local matg=Group.CreateGroup()
				local mg=Auxiliary.GetEvoluteMaterials(c,tp)
				for _,f in pairs(funs) do
					local tempg=mg:Filter(f,nil)
					matg:Merge(tempg)
				end
				return matg:IsExists(cid.EvoluteRecursiveFilter,1,nil,tp,Group.CreateGroup(),matg,c,0,min,max,forcedmat)
			end
end
function cid.EvoluteTarget(forcedmat,minc,maxc,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Auxiliary.GetEvoluteMaterials(c,tp)
				local matg=Group.CreateGroup()
				for _,f in pairs(funs) do
					local tempg=mg:Filter(f,nil)
					matg:Merge(tempg)
				end
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
					finish=cid.EvoluteCheckGoal(tp,sg,c,minc,#sg,forcedmat)
					local cg=matg:Filter(cid.EvoluteRecursiveFilter,sg,tp,sg,matg,c,#sg,minc,maxc,forcedmat)
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
function cid.EvoluteOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	local fixg=Group.CreateGroup()
	fixg:KeepAlive()
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
			if tc:IsOnField() then
				Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE,1)
				fixg:AddCard(tc)
			else
				Duel.SendtoGrave(tc,REASON_MATERIAL+0x10000000)
			end
		end
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,e,REASON_MATERIAL+0x10000000,c:GetControler(),tc:GetControler(),0)
		tc=g:GetNext()
	end
	Duel.RaiseEvent(fixg,EVENT_BE_MATERIAL,e,REASON_MATERIAL+0x10000000,c:GetControler(),c:GetControler(),0)
	fixg:DeleteGroup()
	--Set Maximum for Convergents
	local cone={c:IsHasEffect(EFFECT_CONVERGENT_EVOLUTE)}
	for _,te in ipairs(cone) do
		te:SetValue(lvTotal)
	end
	g:DeleteGroup()
end
--change position
function cid.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsCanRemoveEC(tp,6,REASON_COST) and #g>0 and not g:IsExists(aux.NOT(Card.IsAbleToRemoveAsCost),1,nil) 
			and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.RemoveEC(tp,1,1,6,REASON_COST)
	local g=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og<=0 then return end
		local ct=og:GetClassCount(Card.GetPreviousAttributeOnField)
		if ct>0 then
			e:SetLabel(ct)
		end
	end
	if e:GetLabel()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function cid.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--set
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cid.setfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.setfilter,tp,LOCATION_REMOVED,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cid.setfilter,tp,LOCATION_REMOVED,0,1,1,nil,tp)
	local dg=Duel.GetMatchingGroup(cid.scfilter,tp,LOCATION_DECK,0,nil,g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,1,0,0)
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsSSetable() then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
			local code=tc:GetCode()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,cid.scfilter,tp,LOCATION_DECK,0,1,1,nil,code)
			if #g>0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
--recycle
function cid.rccon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cid.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and cid.rcfilter(chkc,e:GetHandler():GetAttribute()) end
	if chk==0 then return Duel.IsExistingTarget(cid.rcfilter,tp,LOCATION_REMOVED,0,1,nil,e:GetHandler():GetAttribute()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cid.rcfilter,tp,LOCATION_REMOVED,0,1,1,nil,e:GetHandler():GetAttribute())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cid.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end