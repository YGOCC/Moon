--Cantante della Xenofiamma
--Script by XGlitchy30
function c26591134.initial_effect(c)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c26591134.disable)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26591134,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCost(c26591134.thcost)
	e2:SetTarget(c26591134.thtg)
	e2:SetOperation(c26591134.thop)
	c:RegisterEffect(e2)
end
--filters
function c26591134.thfilter(c)
	return c:IsSetCard(0x23b9) and c:IsAbleToHand() and not c:IsCode(26591134)
end
--disable
function c26591134.disable(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and c:GetSummonLocation()==LOCATION_EXTRA and not c:IsSetCard(0x23b9)
end
--tohand
function c26591134.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c26591134.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c26591134.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26591134.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c26591134.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c26591134.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end