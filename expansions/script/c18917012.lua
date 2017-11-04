--Seedling Cerberus
local ref=_G['c'..18917012]
function ref.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54161401,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(ref.spcon)
	e1:SetTarget(ref.sptg)
	e1:SetOperation(ref.spop)
	c:RegisterEffect(e1)
	--ATK Gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(ref.atkop)
	c:RegisterEffect(e2)
	--Bloom Condition
	local be1=Effect.CreateEffect(c)
	be1:SetDescription(aux.Stringid(269,0))
	be1:SetType(EFFECT_TYPE_SINGLE)
	be1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	be1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	be1:SetCode(269)
	be1:SetCondition(ref.bloomcon)
	c:RegisterEffect(be1)
	
	if not ref.global_check then
		ref.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(ref.chk)
		Duel.RegisterEffect(ge2,0)
	end
end

ref.seedling = true
function ref.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,269)
	Duel.CreateToken(1-tp,269)
end

function ref.bloomcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>=2000
end

function ref.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and ((re:GetHandler():GetType()==TYPE_SPELL) or (re:GetHandler():GetType()==TYPE_TRAP))
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(200)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.SendtoGrave(c,REASON_RULE)
		end
	end
end

function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and c:GetFlagEffect(1)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end