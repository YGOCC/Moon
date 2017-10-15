function c100000986.initial_effect(c)
aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--handes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000986,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1)
	e1:SetTarget(c100000986.target)
	e1:SetOperation(c100000986.operation)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
		--hande
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000986,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetTarget(c100000986.targets)
	e2:SetOperation(c100000986.operations)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
function c100000986.filter(c)
	return c:IsSetCard(0x117)
end
function c100000986.filterd(c)
	return c:IsSetCard(0x117) and c:IsAbleToHand()
end
function c100000986.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c100000986.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000986.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c100000986.filter,1,1,REASON_EFFECT)~=0 then
	end
end
function c100000986.targets(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c100000986.filterd(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000986.filterd,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100000986.filterd,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100000986.operations(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
