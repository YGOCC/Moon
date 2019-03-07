--Saiko-Komon Dokurorider Mike N. Ike
--Script by TaxingCorn117
function c66823468.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(99721536)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66823468,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(c66823468.descon)
	e2:SetTarget(c66823468.destg)
	e2:SetOperation(c66823468.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(66823468,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c66823468.thtg)
	e3:SetOperation(c66823468.thop)
	c:RegisterEffect(e3)
end
--filters
function c66823468.filter(c)
	return (c:IsCode(99721536) or c:IsCode(31066283) or c:IsSetCard(0x1e0)) and c:IsAbleToHand()
end
--destroy
function c66823468.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c66823468.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return Duel.GetAttacker()==e:GetHandler() and d and d:IsFacedown() and d:IsDefensePos() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c66823468.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d:IsRelateToBattle() and d:IsFacedown() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
--to hand
function c66823468.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c66823468.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66823468.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c66823468.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66823468.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end