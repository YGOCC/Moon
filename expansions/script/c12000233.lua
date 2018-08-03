--Tera Golem the Game Master
function c12000233.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12000233)
	e1:SetTarget(c12000233.reptg)
	e1:SetValue(c12000233.repval)
	e1:SetOperation(c12000233.repop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000233,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12001233)
	e2:SetCondition(c12000233.thcon)
	e2:SetTarget(c12000233.thtg)
	e2:SetOperation(c12000233.thop)
	c:RegisterEffect(e2)
end
function c12000233.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x856) and c:IsControler(tp)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c12000233.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsDiscardable() and eg:IsExists(c12000233.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12000233.repval(e,c)
	return c12000233.repfilter(c,e:GetHandlerPlayer())
end
function c12000233.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD)
end
function c12000233.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12000233.thfilter(c)
	return c:IsSetCard(0x856) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12000233.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000233.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12000233.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12000233.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
