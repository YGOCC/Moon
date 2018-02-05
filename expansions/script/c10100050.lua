--Schach König
function c10100050.initial_effect(c)
	--special summon(hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10100050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c10100050.spcon1)
	e1:SetTarget(c10100050.sptg1)
	e1:SetOperation(c10100050.spop1)
	c:RegisterEffect(e1)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c10100050.efilter)
	c:RegisterEffect(e4)
	--Activate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c10100050.target)
	e5:SetOperation(c10100050.activate)
	c:RegisterEffect(e5)
	--immune trap
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c10100050.efilter1)
	c:RegisterEffect(e6)
	--battle indestructable
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--death
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(10100050,2))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_LEAVE_FIELD)
    e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e9:SetRange(LOCATION_DECK+LOCATION_REMOVED+LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e9:SetCondition(c10100050.spcon)
	e9:SetOperation(c10100050.operation)
	c:RegisterEffect(e9)
end
function c10100050.cfilter(c,tp)
	return c:IsCode(10100049) and c:GetPreviousControler()==tp
end
function c10100050.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10100050.cfilter,1,nil,tp)
end
function c10100050.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10100050.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c10100050.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10100050.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10100056,0,0x4011,0,0,3,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10100050.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10100056,0,0x4011,0,0,3,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then return end
	for i=1,1 do
		local token=Duel.CreateToken(tp,10100056)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_LEAVE_FIELD)
			e1:SetOperation(c10100050.damop)
			token:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c10100050.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(c:GetPreviousControler(),1200,REASON_EFFECT)
	end
	e:Reset()
end
function c10100050.efilter1(e,te)
	return te:IsActiveType(TYPE_TRAP) 
end
function c10100050.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:GetLocation()~=LOCATION_DECK
end
function c10100050.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,0)
end