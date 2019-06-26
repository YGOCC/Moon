--A.O. Diver
function c21730407.initial_effect(c)
  --link procedure
	aux.AddLinkProcedure(c,c21730407.matfilter,1,1)
	c:EnableReviveLimit()
  --mill
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(21730407,0))
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21730407)
  e2:SetTarget(c21730407.tgtg)
  e2:SetOperation(c21730407.tgop)
  c:RegisterEffect(e2)
  --add from gy
  local e3=Effect.CreateEffect(c)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e3:SetCode(EVENT_SPSUMMON_SUCCESS)
  e3:SetOperation(c21730407.regop)
  c:RegisterEffect(e3)
end
--link procedure
function c21730407.matfilter(c)
	return c:IsLinkSetCard(0x719) and not (c:IsType(TYPE_LINK) and c:IsStatus(STATUS_SPSUMMON_TURN))
end
--mill
function c21730407.tgfilter(c)
	return c:IsSetCard(0x719) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c21730407.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21730407.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c21730407.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c21730407.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
--add from gy
function c21730407.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730407,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21731407)
	e1:SetReset(RESET_EVENT+0x86c0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730407.thtg)
	e1:SetOperation(c21730407.thop)
	c:RegisterEffect(e1)
end
function c21730407.thfilter(c)
	return c:IsSetCard(0x719) and c:IsAbleToHand()
end
function c21730407.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21730407.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21730407.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c21730407.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c21730407.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
