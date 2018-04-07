--Creation Hyper-Drive
function c32.initial_effect(c)
	--(1) Ritual Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCost(c32.thcost)
	e1:SetTarget(c32.thtg)
	e1:SetOperation(c32.thop)
	c:RegisterEffect(e1)
	--(2) Destroy Replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c32.reptg)
	e2:SetValue(c32.repval)
	e2:SetOperation(c32.repop)
	c:RegisterEffect(e2)
end
--Ritual Summon
function c32.thcfilter(c)
  return c:IsSetCard(0x107b) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c32.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c32.thcfilter,tp,LOCATION_HAND,0,1,nil) or Duel.IsExistingMatchingCard(c32.thcfilter,tp,LOCATION_FZONE,0,1,nil) or Duel.IsExistingMatchingCard(c32.thcfilter,tp,LOCATION_GRAVE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c32.thcfilter,tp,LOCATION_HAND,0,1,1,nil)  or Duel.IsExistingMatchingCard(c32.thcfilter,tp,LOCATION_FZONE,0,1,nil) or Duel.IsExistingMatchingCard(c32.thcfilter,tp,LOCATION_GRAVE,0,1,nil)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c32.spfilter(c,e,tp)
  return c:IsSetCard(0x8323) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c32.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  and Duel.IsExistingMatchingCard(c32.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c32.thop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c32.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
	Duel.SpecialSummon(g,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)  end
end
--Destroy Replace
function c32.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_RITUAL) and c:IsSetCard(0x893)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c32.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c32.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c32.repval(e,c)
	return c32.repfilter(c,e:GetHandlerPlayer())
end
function c32.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
