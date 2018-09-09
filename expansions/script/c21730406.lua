--S.G. Excavator
function c21730406.initial_effect(c)
	--link procedure
	aux.AddLinkProcedure(c,c21730406.matfilter,1,1)
	c:EnableReviveLimit()
	--unaffected by non-targeting
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c21730406.imcon)
	e2:SetValue(c21730406.imval)
	c:RegisterEffect(e2)
	--add from grave to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c21730406.regop)
	c:RegisterEffect(e3)
end
--link procedure
function c21730406.matfilter(c)
	return c:IsLinkSetCard(0x719) and not c:IsType(TYPE_LINK)
end
--unaffected by non-targeting
function c21730406.imcon(e)
	return e:GetHandler():IsLinkState()
end
function c21730406.imval(e,re)
	if not (re:GetOwnerPlayer()~=e:GetHandlerPlayer()) or not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
--add from grave to hand
function c21730406.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730406,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730406.thtg)
	e1:SetOperation(c21730406.thop)
	c:RegisterEffect(e1)
end
function c21730406.thfilter(c)
	return c:IsSetCard(0x719) and c:IsAbleToHand()
end
function c21730406.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21730406.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21730406.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c21730406.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c21730406.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end