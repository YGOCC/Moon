--Fallenblade - Golem
function c543516059.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x21f),1,1)
	--extra summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x21f))
	c:RegisterEffect(e1)
	--pow
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(543516059,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,543516037)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c543516059.destg)
	e2:SetOperation(c543516059.desop)
	c:RegisterEffect(e2)
	--leaves field special
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(543516059,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,543516036)
	e3:SetCost(c543516059.spcost1)
	e3:SetTarget(c543516059.sptg1)
	e3:SetOperation(c543516059.spop1)
	c:RegisterEffect(e3)
end
function c543516059.desfilter(c)
	return c:IsSetCard(0x21f) and c:IsAbleToRemove()
end
function c543516059.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c543516059.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c543516059.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c543516059.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c543516059.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,nil):GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c543516059.desfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_SZONE+LOCATION_GRAVE,0,1,sg,nil)
	if g:GetCount()>0 then
		local ct=Duel.Remove(g,POS_FACEUP,REASON_COST)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c543516059.spfilter1(c)
	return c:IsSetCard(0x21f) and c:IsAbleToRemoveAsCost()
end
function c543516059.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c543516059.spfilter1,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c543516059.spfilter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c543516059.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	  and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c543516059.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
	  and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
	  Duel.SendtoGrave(c,REASON_RULE)
  end
end