--Lithos Alchemist Aussa
function c2223331.initial_effect(c)
	--if used for ritual search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCondition(c2223331.thcon)
	e1:SetTarget(c2223331.thtg)
	e1:SetOperation(c2223331.thop)
	e1:SetCountLimit(1,2223331)
	c:RegisterEffect(e1)

	--if in grave, Shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73881652,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c2223331.gravecost)
	e2:SetTarget(c2223331.gravetarget)
	e2:SetOperation(c2223331.graveoperation)
	c:RegisterEffect(e2)
end

function c2223331.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_RITUAL)
end

function c2223331.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsSetCard(0x222) and c:IsAbleToHand()
end

function c2223331.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK)
		and chkc:IsControler(tp)
		and c2223331.thfilter(chkc)
	end
   
	if chk==0 then 
		return Duel.IsExistingTarget(c2223331.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c2223331.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c2223331.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c2223331.gravefilter(c)
	return c:IsType(TYPE_RITUAL)
	and c:IsSetCard(0x222) 
	and c:IsAbleToHand() 
	and c:IsFaceup()
end

function c2223331.gravecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end

function c2223331.gravetarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_EXTRA)
		and chkc:IsControler(tp) 
		and c2223331.gravefilter(chkc)
	end
   
	if chk==0 then 
		return Duel.IsExistingTarget(c2223331.gravefilter,tp,LOCATION_EXTRA,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c2223331.gravefilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c2223331.graveoperation(e,tp,eg,ep,ev,re,r,rp)
 local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end