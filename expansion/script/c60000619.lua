--Sharpshooter, Leather Boots
function c60000619.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--salvage archetype
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000619,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c60000619.thtg)
	e1:SetOperation(c60000619.thop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--salvage archetype 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60000619,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCondition(c60000619.drcon)
	e3:SetTarget(c60000619.drtg)
	e3:SetOperation(c60000619.drop)
	c:RegisterEffect(e3)
end
function c60000619.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x604) and c:IsLevelBelow(5) and c:IsAbleToHand()
end
function c60000619.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c60000619.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000619.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60000619.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60000619.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e2:SetReset(RESET_PHASE+PHASE_END)
        e2:SetTargetRange(1,0)
        e2:SetTarget(c60000619.splimit)
        Duel.RegisterEffect(e2,tp)
    end
end
function c60000619.splimit(e,c)
	return c:GetAttribute()~=ATTRIBUTE_WIND
end
function c60000619.filter2(c)
	return c:IsFaceup() and c:IsLevelBelow(5) and c:IsAttribute(0x8)
end
function c60000619.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler() and r==REASON_SYNCHRO
end
function c60000619.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c60000619.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000619.filter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60000619.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60000619.drop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,tc)
    end
end