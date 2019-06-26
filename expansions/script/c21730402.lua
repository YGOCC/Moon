--A.O. Dampener
function c21730402.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730402,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c21730402.spcon)
	c:RegisterEffect(e1)
  --negate
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730402,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCost(c21730402.cost)
	e2:SetTarget(c21730402.target)
	e2:SetOperation(c21730402.operation)
	c:RegisterEffect(e2)
end
--special summon
function c21730402.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--negate
function c21730402.filter(c,tp)
	return c:IsSetCard(0x719) and Duel.IsExistingTarget(c21730402.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function c21730402.tgfilter(c)
  return c:IsFaceup() and not c:IsDisabled()
end
function c21730402.rcost(c)
	return c:IsFaceup() and c:IsCode(21730412) and c:IsReleasable() and c:GetFlagEffect(21730412)==0 and not c:IsDisabled() and not c:IsForbidden()
end
function c21730402.cost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	local b1=Duel.CheckReleaseGroup(tp,c21730402.filter,1,false,nil,nil,tp)
	local b2=Duel.IsExistingMatchingCard(c21730402.rcost,tp,LOCATION_FZONE,0,1,nil)
	if chk==0 then return c:IsAbleToRemoveAsCost() and (b1 or b2) end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(21730412,2))) then
		local tg=Duel.GetFirstMatchingCard(c21730402.rcost,tp,LOCATION_FZONE,0,nil)
		Duel.Release(tg,REASON_COST)
	else
		local g=Duel.SelectReleaseGroup(tp,c21730402.filter,1,1,false,nil,nil,tp)
		Duel.Release(g,REASON_COST)
	end
end
function c21730402.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and c21730402.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21730402.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c21730402.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c21730402.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end
