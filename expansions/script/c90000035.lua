--Toxic Clean Land
function c90000035.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,90000035)
	e1:SetCondition(c90000035.condition1)
	e1:SetTarget(c90000035.target1)
	e1:SetOperation(c90000035.operation1)
	c:RegisterEffect(e1)
	--Draw & Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c90000035.cost2)
	e2:SetOperation(c90000035.operation2)
	c:RegisterEffect(e2)
	--Effect Damage X2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(c90000035.value3)
	c:RegisterEffect(e3)
end
function c90000035.condition1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c90000035.filter1(c,e,tp,dam)
	return c:IsSetCard(0x14) and (c:IsAttackBelow(dam) or c:IsDefenseBelow(dam)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c90000035.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000035.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,ev) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90000035.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000035.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ev)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c90000035.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsAbleToGraveAsCost()
end
function c90000035.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and Duel.IsPlayerCanDraw(tp) end
	local g=Duel.GetMatchingGroup(c90000035.filter2,tp,LOCATION_SZONE,0,nil)
	local ct=Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(ct)
end
function c90000035.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ct1=e:GetLabel()
	if ct1==0 then return end
	local ct2=Duel.Draw(tp,ct1,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Recover(tp,ct2*700,REASON_EFFECT)
end
function c90000035.value3(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return val*2 end
	return val
end