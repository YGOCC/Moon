--Yasmin, Young Princess of Gust Vine
function c160009933.initial_effect(c)
		   c:EnableReviveLimit()
		aux.AddFusionProcCodeFun(c,500315980,aux.FilterBoolFunction(c160009933.ffilter),1,true,true)
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160009933,0))
	 e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,160009933)
	e1:SetCondition(c160009933.condition)
	e1:SetTarget(c160009933.target)
	e1:SetOperation(c160009933.operation)
	c:RegisterEffect(e1)
	  --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c160009933.thcon)
	e2:SetTarget(c160009933.thtg)
	e2:SetOperation(c160009933.thop)
	c:RegisterEffect(e2)
   

end
function c160009933.ffilter(c)
	return  c:GetLevel()<=4 and c:GetCode()~=160009933 and not c:IsCode(160009933)  and c:GetLevel()>0  or c:IsHasEffect(500317451)
end
function c160009933.condition(e,tp,eg,ep,ev,re,r,rp)
	return  e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION or e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION+0x786
end
function c160009933.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c160009933.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	  Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c160009933.cfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function c160009933.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c160009933.cfilter,1,nil,1-tp)
end
function c160009933.filter(c)
	return c:IsSetCard(0x885a) and  (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c160009933.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160009933.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c160009933.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c160009933.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(6666,7))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end