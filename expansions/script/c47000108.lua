--Digimon Luminamon
function c47000108.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3FB),4,2)
	c:EnableReviveLimit()
--toHand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(47000108,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c47000108.hdcost)
	e1:SetTarget(c47000108.pentarget)
	e1:SetOperation(c47000108.penactivate)
	c:RegisterEffect(e1)
--gain atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000108,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RECOVER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c47000108.atkcon)
	e4:SetOperation(c47000108.atkop)
	c:RegisterEffect(e4)
end
function c47000108.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3FB) and c:IsAbleToHand()
end
function c47000108.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47000108.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c47000108.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47000108.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c47000108.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47000108.penactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	if	Duel.SendtoHand(tc,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.SetTargetPlayer(tp)
			Duel.SetTargetParam(500)
			Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Recover(p,d,REASON_EFFECT)
		end
	end
end
function c47000108.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c47000108.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ev)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e:GetHandler():RegisterEffect(e1)
	Duel.RaiseSingleEvent(e:GetHandler(),47000108,e,r,rp,ep,ev)
end
