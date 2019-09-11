-- Aegis' Slumber

function c60000013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,60000013)
	e1:SetTarget(c60000013.target)
	e1:SetOperation(c60000013.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c60000013.reptg)
	e2:SetValue(c60000013.repval)
	e2:SetOperation(c60000013.repop)
	c:RegisterEffect(e2)
end

function c60000013.filter(c)
	return c:IsRace(RACE_FAIRY) and c:IsLevelAbove(8) and c:IsAbleToHand()
end
function c60000013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c60000013.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000013.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c60000013.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60000013.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c60000013.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsReason(REASON_BATTLE)
		and c:IsRace(RACE_FAIRY) and c:GetLevel()==8
end
function c60000013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c60000013.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c60000013.repval(e,c)
	return c60000013.repfilter(c,e:GetHandlerPlayer())
end
function c60000013.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end