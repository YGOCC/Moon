--Virtuakit-α Gather
function c932819075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,932819075+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c932819075.thcon)
	e3:SetTarget(c932819075.thtg)
	e3:SetOperation(c932819075.thop)
	c:RegisterEffect(e3)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(926435323,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c932819075.tdcon)
	e5:SetTarget(c932819075.tdtg)
	e5:SetOperation(c932819075.tdop)
	c:RegisterEffect(e5)
end
function c932819075.thcfilter(c,tp)
	return c:IsPreviousSetCard(0x1fe5) and c:GetPreviousControler()==tp
		and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c932819075.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c932819075.thcfilter,1,nil,tp)
end
function c932819075.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xfe5) and c:IsAbleToHand()
end
function c932819075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c932819075.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c932819075.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c932819075.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonCard():IsSetCard(0xfe5) and c:IsReason(0x100000000)
end
function c932819075.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c932819075.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
	end
end
