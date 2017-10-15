--Naga Giant Turtle
function c11000414.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11000414,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c11000414.spcon)
	e1:SetTarget(c11000414.sptg)
	e1:SetOperation(c11000414.spop)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c11000414.ccon)
	e2:SetTarget(c11000414.tktg)
	e2:SetOperation(c11000414.tkop)
	c:RegisterEffect(e2)
end
function c11000414.spfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and (c:IsSetCard(0x204) or c:IsSetCard(0x1204)) and c:IsType(TYPE_MONSTER)
		and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c11000414.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11000414.spfilter,1,e:GetHandler(),tp)
end
function c11000414.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11000414.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c11000414.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x204) or c:IsSetCard(0x1204)
end
function c11000414.ccon(e)
	return Duel.IsExistingMatchingCard(c11000414.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c11000414.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,11000405,0,0x4011,500,500,2,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c11000414.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,11000405,0,0x4011,500,500,2,RACE_SEASERPENT,ATTRIBUTE_WATER) then return end
	local token=Duel.CreateToken(tp,11000405)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end