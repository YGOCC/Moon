--Elf 11
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cid.mfilter,2,2,cid.lcheck)
	c:EnableReviveLimit()
	--atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(cid.value)
	c:RegisterEffect(e1)
	--atk limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(cid.indcon)
	e2:SetValue(cid.atlimit)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cid.tgcon)
	e3:SetCountLimit(1)
	e3:SetTarget(cid.settg)
	e3:SetOperation(cid.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cid.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(cid.regop2)
	c:RegisterEffect(e5)
end
function cid.mfilter(c)
	return c:IsLevelAbove(0) and c:IsSetCard(0x219) and c:IsType(TYPE_NORMAL)
end
function cid.lcheck(g,lc)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function cid.filter(c)
	return c:IsSetCard(0x219) and c:IsLevelAbove(0)
end
function cid.fieldfilter(c)
	return c:IsSetCard(0x219) and c:IsCode(21021913)
end
function cid.value(e,c)
	local g=Duel.GetMatchingGroup(cid.filter,c:GetControler(),LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct*200
end
function cid.indcon(e)
	return Duel.IsExistingMatchingCard(cid.fieldfilter,e:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
end
function cid.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(0x219) and c~=e:GetHandler()
end
function cid.tgfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cid.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetLinkedGroup():IsExists(cid.tgfilter,2,nil)
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x219) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(id)
		if flag then
			c:SetFlagEffectLabel(id,flag+1)
		else
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function cid.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():IsSetCard(0x219) and re:IsActiveType(TYPE_SPELL) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(id)
		if flag and flag>0 then
			c:SetFlagEffectLabel(id,flag-1)
		end
	end
end
function cid.setfilter(c)
	return c:IsSetCard(0x219) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetHandler():GetFlagEffectLabel(21021912)
	if chk==0 then return ct and ct>0 and Duel.IsExistingMatchingCard(cid.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetHandler():GetFlagEffectLabel(21021912) or 0
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local tg=Group.CreateGroup()
	local tg1=Group.CreateGroup()
	local field=false
	local init=1
	if g:IsExists(Card.IsType,1,nil,TYPE_FIELD) then field=true end
	while ct>0 and (ft>0 or field) and g:GetCount()>0 do
		if ft==0 then g=g:Filter(Card.IsType,nil,TYPE_FIELD) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,init,1,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsType(TYPE_FIELD) then
				tg:Merge(sg)
				g:Remove(Card.IsType,nil,TYPE_FIELD)
				field=false
			else
				tg1:Merge(sg)
				g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
				ft=ft-1
			end
			init=0
			ct=ct-1
		else
			break
		end
	end
	tg:Merge(tg1)
	Duel.SSet(tp,tg)
	--local tc=tg:GetFirst()
	--while tc do
	--	local e1=Effect.CreateEffect(c)
	--	e1:SetType(EFFECT_TYPE_SINGLE)
	--	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	--	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--	e1:SetValue(LOCATION_REMOVED)
	--	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	--	tc:RegisterEffect(e1)
	--	tc=tg:GetNext()
	--end
end