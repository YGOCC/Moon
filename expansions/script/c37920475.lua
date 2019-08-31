--Paladino Evoluzione
--Scripted by: XGlitchy30
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	--bigbang
	c:EnableReviveLimit()
	aux.AddOrigBigbangType(c)
	aux.AddBigbangProc(c,aux.NOT(aux.FilterEqualFunction(Card.GetVibe,0)),1,aux.FilterEqualFunction(Card.GetVibe,0),1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(cid.eqcon)
	e1:SetTarget(cid.eqtg)
	e1:SetOperation(cid.eqop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cid.reptg)
	e2:SetValue(cid.repval)
	e2:SetOperation(cid.repop)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetTarget(cid.statstg)
	e3:SetOperation(cid.statsop)
	c:RegisterEffect(e3)
end
--EQUIP
--filters
function cid.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
---------
function cid.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+340)
end
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local matf=mat:Filter(Card.IsReason,nil,REASON_DESTROY)
	if chk==0 then return #matf>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_GRAVE,0,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	local matf=mat:Filter(Card.IsReason,nil,REASON_DESTROY)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.filter),tp,LOCATION_GRAVE,0,nil)
	if ft<=0 or #g<=0 or #matf<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=#matf
	if ft<ct then ct=ft end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,ct,nil)
	if #g1<=0 then return end
	Duel.HintSelection(g1)
	local tc=g1:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,false,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cid.eqlimit)
		tc:RegisterEffect(e1)
		tc=g1:GetNext()
	end
	Duel.EquipComplete()
end
function cid.eqlimit(e,c)
	return e:GetOwner()==c
end
--DESTROY REPLACE
--filters
function cid.repfilter(c,e)
	return c:IsLocation(LOCATION_ONFIELD) and c==e:GetHandler() and not c:IsReason(REASON_REPLACE)
		and bit.band(c:GetDestination(),LOCATION_MZONE)==0 and bit.band(c:GetDestination(),LOCATION_SZONE)==0
		and bit.band(c:GetDestination(),LOCATION_FZONE)==0 and bit.band(c:GetDestination(),LOCATION_PZONE)==0
end
function cid.dryfilter(c,e,tp)
	return c:IsLocation(LOCATION_SZONE) and e:GetHandler():GetEquipGroup():IsContains(c)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
---------
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_EFFECT)~=0 and re and eg:IsExists(cid.repfilter,1,nil,e)
		and Duel.IsExistingMatchingCard(cid.dryfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e) and e:GetHandler():GetFlagEffect(id)<=0 
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,cid.dryfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function cid.repval(e,c)
	return cid.repfilter(c,e)
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE,1)
end
--ATK/DEF
--filters
function cid.deqfilter(c,e)
	return e:GetHandler():GetEquipGroup():IsContains(c) and bit.band(c:GetOriginalType(),TYPE_MONSTER)>0
end
---------
function cid.statstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetHandler():GetBattleTarget()
	if chk==0 then return d and d:IsSummonType(SUMMON_TYPE_SPECIAL) 
		and Duel.IsExistingMatchingCard(cid.deqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e)
	end
	if Duel.IsExistingMatchingCard(cid.deqfilter,tp,LOCATION_SZONE,0,1,nil,e) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
	end
	if Duel.IsExistingMatchingCard(cid.deqfilter,tp,0,LOCATION_SZONE,1,nil,e) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_SZONE)
	end
end
function cid.statsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=c:GetBattleTarget()
	if d:IsRelateToBattle() and d:IsSummonType(SUMMON_TYPE_SPECIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cid.deqfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e)
		if #g>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)==1 and c:IsFaceup() then
				local atk,def=g:GetFirst():GetTextAttack(),g:GetFirst():GetTextDefense()
				if atk<=0 and def<=0 then return end
				local opt,eval
				if atk>0 and def>0 then
					opt=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5))
				elseif atk>0 then
					opt=Duel.SelectOption(tp,aux.Stringid(id,4))
				else
					opt=Duel.SelectOption(tp,aux.Stringid(id,5))+1
				end
				if not opt then return end
				if opt==0 then eval=atk else eval=def end
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(eval)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				c:RegisterEffect(e2)
			end
		end
	end
end
