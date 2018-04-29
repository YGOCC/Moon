--Armored Numeral Hunter
function c249000868.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c249000868.spcon)
	c:RegisterEffect(e1)
	--set code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(0x48)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c249000868.eqcon)
	e3:SetTarget(c249000868.eqtg)
	e3:SetOperation(c249000868.eqop)
	c:RegisterEffect(e3)
	--remove overlay replace
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55067058,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c249000868.rcon)
	e4:SetOperation(c249000868.rop)
	c:RegisterEffect(e4)
end
function c249000868.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)>=2
end
function c249000868.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_EXTRA,0,nil,0x48)
	local ct=g:GetClassCount(Card.GetCode)
	if ct < 4 then return false end
	return ec==nil or ec:GetEquipTarget()~=c
end
function c249000868.sumfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c249000868.filter(c,rk)
	return c:IsSetCard(0x48) and c:GetRank()<=rk and not c:IsForbidden() and not c:IsSetCard(0x7F)
end
function c249000868.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c249000868.sumfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c249000868.filter,tp,LOCATION_EXTRA,0,1,nil,ct+4) end
end
function c249000868.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c249000868.sumfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c249000868.filter,tp,LOCATION_EXTRA,0,1,1,nil,ct+4)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local atk=tc:GetTextAttack()/2
		local def=tc:GetTextDefense()/2		
		if atk<0 then atk=0 end
		if def<0 then def=0 end
		e:SetLabelObject(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c249000868.eqlimit)
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
		if def>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_EQUIP)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(def)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_ADJUST)
		e4:SetRange(LOCATION_SZONE)	
		e4:SetOperation(c249000868.operation)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
	end
end
function c249000868.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c249000868.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=e:GetHandler():GetEquipTarget()
	local code=eq:GetOriginalCode()
	if eq:IsFaceup() and eq:GetFlagEffect(249000868)==0 then
		Duel.MajesticCopy(eq,c)
		eq:RegisterFlagEffect(249000868,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1) 	
	end	
end
function c249000868.rcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==e:GetOwnerPlayer() and bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and ev <=2
end
function c249000868.rop(e,tp,eg,ep,ev,re,r,rp)
end
