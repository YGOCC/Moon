--32083013
function c32083013.initial_effect(c)
--spsummon
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(32083013,0))
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e1:SetCode(EVENT_ATTACK_ANNOUNCE)
e1:SetRange(LOCATION_HAND)
e1:SetCost(c32083013.cost)
e1:SetCondition(c32083013.spcon)
e1:SetTarget(c32083013.sptg)
e1:SetOperation(c32083013.spop)
c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32083013,1))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c32083013.condition)
	e2:SetTarget(c32083013.target)
	e2:SetOperation(c32083013.operation)
	c:RegisterEffect(e2)
end
function c32083013.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c32083013.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c32083013.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
end
function c32083013.cfilter(c)
	return c:IsSetCard(0x7D53) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c32083013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32083013.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c32083013.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32083013.spcon(e,tp,eg,ep,ev,re,r,rp)
local at=Duel.GetAttacker()
return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c32083013.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c32083013.spop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if c and Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then
Duel.Remove(Duel.GetAttacker(),POS_FACEUP,REASON_EFFECT)
end
end