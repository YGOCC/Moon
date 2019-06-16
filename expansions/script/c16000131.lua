--Takita, Chicorady of Fiber VINE
function c16000131.initial_effect(c)

	--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--match winner
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,16000131)
	e2:SetTarget(c16000131.thtg)
	e2:SetOperation(c16000131.thop)
	c:RegisterEffect(e2)	
end

function c16000131.thfilter(c,e,tp)
	return c:IsSetCard(0x85a)  and c:IsType(TYPE_MONSTER) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16000131.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c16000131.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c16000131.thfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c16000131.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c16000131.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end



