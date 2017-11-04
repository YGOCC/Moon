--Frontier Beast, Arcadia
--Design and code by Kindrindra
local ref=_G['c'..28915504]
function ref.initial_effect(c)
	if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCountLimit(1)
		ge1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge1:SetOperation(ref.chk)
		Duel.RegisterEffect(ge1,0)
	end

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE+LOCATION_ONFIELD)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(ref.atkval)
	c:RegisterEffect(e2)
	--DEF
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_FZONE+LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(ref.etarget)
	e4:SetValue(ref.efilter)
	c:RegisterEffect(e4)
end
ref.blink=true
function ref.material1(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD)
end
function ref.material2(c)
	return c:IsType(TYPE_MONSTER) --and c:IsRace(RACE_FISH)
end
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,555)
	Duel.CreateToken(1-tp,555)
end

function ref.atkval(e,c)
	if c:IsRace(RACE_FISH+RACE_SEASERPENT+RACE_AQUA) then return 500
	else return 0 end
end

function ref.etarget(e,c)
	return c:IsAttribute(ATTRIBUTE_WIND)
end
function ref.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end

ref.ODDcount=12
ref.ODDrange=LOCATION_FZONE
function ref.ODDcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(28915504)==0
end
function ref.ODDop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 if c:IsRelateToEffect(e) then
	 	--Cannot Target
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_FZONE+LOCATION_ONFIELD)
		e5:SetValue(aux.tgoval)
		e5:SetReset(RESET_EVENT+0x7c0000)
		c:RegisterEffect(e5)
		--Become Monster
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_IGNITION)
		e6:SetRange(LOCATION_FZONE)
		e6:SetCountLimit(1)
		e6:SetReset(RESET_EVENT+0x7c0000)
		e6:SetTarget(ref.tftg)
		e6:SetOperation(ref.tfop)
		c:RegisterEffect(e6)
		c:RegisterFlagEffect(28915504,RESET_EVENT+0x7c0000,0,1)
	end
end

function ref.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function ref.tfop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_FISH)
		c:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_WIND)
		c:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(3000)
		c:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(2500)
		c:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(9)
		c:RegisterEffect(e6,true)
	
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(28915504,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e7:SetCode(EVENT_PHASE+PHASE_END)
		e7:SetCountLimit(1)
		e7:SetLabel(fid)
		e7:SetLabelObject(c)
		e7:SetCondition(ref.retcon)
		e7:SetOperation(ref.retop)
		e7:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e7,tp)
	end
end
function ref.retfilter(c,fid)
	return c:GetFlagEffectLabel(28915504)==fid
end
function ref.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if not ref.retfilter(tc,e:GetLabel()) then
		e:Reset()
		return false
	else return true end
end
function ref.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if ref.retfilter(tc,e:GetLabel()) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end