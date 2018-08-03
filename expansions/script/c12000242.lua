--Game Master Arcade
function c12000242.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x856))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--extra summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12000242,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x856))
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12000242,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12000242.thcon)
	e4:SetTarget(c12000242.thtg)
	e4:SetOperation(c12000242.thop)
	c:RegisterEffect(e4)
end
function c12000242.cfilter(c,tp)
	return c:IsPreviousSetCard(0x856) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000242.thfilter(c,tp)
	return c:IsAbleToHand() and c:IsSetCard(0x856) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and not c:IsLocation(LOCATION_DECK+LOCATION_HAND)
end
function c12000242.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12000242.cfilter,1,nil,tp) and eg:GetCount()==1
		and re and re:GetHandler():IsSetCard(0x856) and re:GetHandler():IsType(TYPE_LINK)
end
function c12000242.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12000242.thfilter,1,nil,tp) end
	local clone=eg:Clone()
	e:SetLabelObject(clone)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,clone,1,0,0)
end
function c12000242.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=eg:FilterSelect(tp,c12000242.thfilter,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end