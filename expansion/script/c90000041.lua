--Toxic Waste Maze
function c90000041.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Name
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetCondition(c90000041.condition)
	e2:SetTarget(c90000041.target)
	e2:SetValue(90000041)
	c:RegisterEffect(e2)
	--Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,90000041)
	e3:SetCondition(c90000041.condition2)
	e3:SetTarget(c90000041.target2)
	e3:SetOperation(c90000041.operation)
	c:RegisterEffect(e3)
	--Damage X2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c90000041.value)
	c:RegisterEffect(e4)
end
function c90000041.condition(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c90000041.target(e,c)
	return not c:IsSetCard(0x14)
end
function c90000041.value(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return val*2 end
	return val
end
function c90000041.condition2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c90000041.filter(c,e,tp,dam)
	return c:IsSetCard(0x14) and (c:IsAttackBelow(dam) or c:IsDefenseBelow(dam)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000041.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000041.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90000041.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000041.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end