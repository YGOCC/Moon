--Voidictator Servant - Shield of Corvus
function c99998880.initial_effect(c)
	--cannot be battle target
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c99998880.tg)
	c:RegisterEffect(e1)
	--Banished?
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99998880,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCost(c99998880.cost)
	e2:SetTarget(c99998880.target)
	e2:SetOperation(c99998880.operation)
	c:RegisterEffect(e2)
	--Half Battle Damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c99998880.damcon)
	e3:SetValue(c99998880.val)
	c:RegisterEffect(e3)
end
function c99998880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99998880)==0 end
	Duel.RegisterFlagEffect(tp,99998880,RESET_PHASE+PHASE_END,0,1)
end
function c99998880.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c99998880.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c99998880.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x1c97)
end
function c99998880.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x2c97) or c:IsSetCard(0x4c97))
end
function c99998880.damcon(e)
	return Duel.IsExistingMatchingCard(c99998880.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c99998880.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end