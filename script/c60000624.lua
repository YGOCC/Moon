--Sharpshooter, Wind Cyclone Dragon
function c60000624.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,0x8),aux.NonTuner(Card.IsSetCard,0x604),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,60000624)
	e1:SetTarget(c60000624.reptg)
	e1:SetValue(c60000624.repval)
	e1:SetOperation(c60000624.repop)
	c:RegisterEffect(e1)
	--Negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000624,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60000624.condition)
	e2:SetCost(c60000624.cost)
	e2:SetTarget(c60000624.target)
	e2:SetOperation(c60000624.operation)
	c:RegisterEffect(e2)
	--salvage archetype monster
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60000624,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(c60000624.thcon)
	e5:SetTarget(c60000624.thtg)
	e5:SetOperation(c60000624.thop)
	c:RegisterEffect(e5)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60000624,2))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c60000624.pencon)
	e4:SetTarget(c60000624.pentarget)
	e4:SetOperation(c60000624.penop)
	c:RegisterEffect(e4)
end
function c60000624.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c60000624.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c60000624.filter,1,nil,tp) and e:GetHandler():IsAbleToRemove() end
	return Duel.SelectYesNo(tp,aux.Stringid(60000624,1))
end
function c60000624.repval(e,c)
	return c60000624.filter(c,e:GetHandlerPlayer())
end
function c60000624.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function c60000624.sacfil(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c60000624.condition(e,tp,eg,ep,ev,re,r,rp)
    if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
    if re:IsHasCategory(CATEGORY_NEGATE)
        and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
    local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
    return ex and tg~=nil and tc+tg:FilterCount(c60000624.sacfil,nil,tp)-tg:GetCount()>0
end
function c60000624.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsReleasable() end
	e:SetLabel(c:GetAttack())
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c60000624.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c60000624.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	e:GetHandler():RegisterFlagEffect(60000624,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	if e:GetLabel() and e:GetLabel()>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
	end
end
function c60000624.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(60000624)>0
end
function c60000624.filter2(c)
	return c:IsSetCard(0x604) and c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and c:IsAbleToHand()
end
function c60000624.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c60000624.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000624.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60000624.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60000624.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c60000624.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c60000624.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60000624.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c60000624.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60000624.penop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

