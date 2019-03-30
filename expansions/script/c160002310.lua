--Paintress Dali
function c160002310.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
  --atk down
	 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c160002310.atktg)
	e1:SetValue(c160002310.val)
	c:RegisterEffect(e1)
		--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	 e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,160002310)
   e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(c160002310.thtg)
	e2:SetOperation(c160002310.thop)
	c:RegisterEffect(e2)


end
function c160002310.atktg(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c160002310.val(e,c)
	 return Duel.GetMatchingGroupCount(c160002310.ctfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*-200
end
function c160002310.ctfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function c160002310.thfilter(c,e,tp)
	return not c:IsType(TYPE_EFFECT) and  c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c160002310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsPreviousLocation(LOCATION_ONFIELD) and eg:GetCount()==1 and tc:IsSetCard(0xc50) and tc:IsType(TYPE_PENDULUM) 
	  and tc:IsReason(REASON_EFFECT+REASON_DESTROY)
		and tc:GetPreviousControler() end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c160002310.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
   if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=eg:GetFirst()
	if tc:IsRelateToEffect(e)  and  Duel.SendtoHand(tc,nil,REASON_EFFECT) ~=0 and tc:IsType(TYPE_NORMAL) and Duel.SelectYesNo(tp,aux.Stringid(6666,7))then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
Duel.Destroy(c,REASON_EFFECT)
end
--function c160002310.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c160002310.thfilter(chkc,e,tp) end
  --  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
  --	  and Duel.IsExistingTarget(c160002310.thfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
  --  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  --  local g=Duel.SelectTarget(tp,c160002310.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
  --  Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
  --  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
--end
--function c160002310.thop(e,tp,eg,ep,ev,re,r,rp)
 --   local c=e:GetHandler()
  --  if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
  --  local tc=Duel.GetFirstTarget()
  --  if tc:IsRelateToEffect(e) then
   --   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
  --  end
--end
