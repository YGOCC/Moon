--A.O. Ambusher
function c21730405.initial_effect(c)
	c:SetUniqueOnField(1,0,21730405)
	--link procedure
	aux.AddLinkProcedure(c,c21730405.matfilter,1,1)
	c:EnableReviveLimit()
	--unaffected by non-targeting
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21730405,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c21730405.imval)
	c:RegisterEffect(e2)
	--add from grave to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c21730405.regop)
	c:RegisterEffect(e3)
end
--link procedure
function c21730405.matfilter(c)
	return c:IsLinkSetCard(0x719) and not (c:IsSummonType(SUMMON_TYPE_LINK) and c:IsStatus(STATUS_SPSUMMON_TURN))
end
--unaffected by non-targeting
function c21730405.imval(e,re)
	if not (re:GetOwnerPlayer()~=e:GetHandlerPlayer()) or not re:IsActivated() then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
--add from grave to hand
function c21730405.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21730405,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0x86c0000+RESET_PHASE+PHASE_END)
	e1:SetTarget(c21730405.thtg)
	e1:SetOperation(c21730405.thop)
	c:RegisterEffect(e1)
end
function c21730405.thfilter(c)
	return c:IsSetCard(0x719) and c:IsAbleToHand()
end
function c21730405.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c21730405.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c21730405.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c21730405.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c21730405.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end