function c500315455.initial_effect(c)
	c:EnableReviveLimit()
--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500315455,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c500315455.eqcon)
	e1:SetCost(c500315455.discost)
	e1:SetTarget(c500315455.eqtg)
	e1:SetOperation(c500315455.eqop)
	c:RegisterEffect(e1)
			--evolute summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500315455,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c500315455.descon)
	e4:SetTarget(c500315455.destg)
	e4:SetOperation(c500315455.desop)
	c:RegisterEffect(e4)

if not c500315455.global_check then
		c500315455.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c500315455.chk)
		Duel.RegisterEffect(ge2,0)
		
	end
end
c500315455.evolute=true
c500315455.material1=function(mc) return  mc:IsCode(500314712) and mc:IsFaceup() end
c500315455.material2=function(mc) return  mc:GetLevel()==3  and mc:IsFaceup() end
function c500315455.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,388)
	Duel.CreateToken(1-tp,388)
			c160009541.stage_o=7
c160009541.stage=c160009541.stage_o
end

function c500315455.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1088,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1088,4,REASON_COST)
end
function c500315455.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	return ec==nil or ec:GetFlagEffect(500315455)==0
end
function c500315455.xfilter(c)
	return  c:IsAbleToChangeControler()
end
function c500315455.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)  end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c500315455.xfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c500315455.xfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c500315455.eqlimit(e,c)
	return e:GetOwner()==c
end
function c500315455.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()/2
			local def=tc:GetTextDefense()/2
			if tc:IsFacedown() or atk<0 then atk=0 end
			if tc:IsFacedown() or def<0 then def=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(500315455,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c500315455.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
			--if def>0 then
				--local e3=Effect.CreateEffect(c)
				--e3:SetType(EFFECT_TYPE_EQUIP)
				--e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				--e3:SetCode(EFFECT_UPDATE_DEFENSE)
				--e3:SetReset(RESET_EVENT+0x1fe0000)
				--e3:SetValue(def)
				--tc:RegisterEffect(e3)
			--end
	end
end
end
function c500315455.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+388 and c:GetMaterial():IsExists(c500315455.pmfilter,1,nil)
end
function c500315455.pmfilter(c)
	return c:IsCode(160002123)
end
function c500315455.deesfilter(c)
return c:IsFaceup() and c:IsDestructable()
end
function c500315455.destg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
local g=Duel.GetMatchingGroup(c500315455.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c500315455.desop(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(c500315455.deesfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
if g:GetCount()>0 then
Duel.Destroy(g,REASON_EFFECT)
end
end