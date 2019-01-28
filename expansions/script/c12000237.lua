--Tera Magnus the Game Master
function c12000237.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12000237.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000237,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12000237)
	e2:SetCondition(c12000237.thcon1)
	e2:SetTarget(c12000237.thtg)
	e2:SetOperation(c12000237.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(c12000237.thcon2)
	c:RegisterEffect(e3)
end
function c12000237.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x856)
end
function c12000237.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return not Duel.IsExistingMatchingCard(c12000237.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12000237.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_LINK and c:GetReasonCard():IsSetCard(0x856)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000237.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re and c:IsReason(REASON_EFFECT) and re:GetHandler():IsSetCard(0x856)
		and re:GetHandler():IsType(TYPE_LINK) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000237.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12000237.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end