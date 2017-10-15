--Necromantia Library
function c5312024.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c5312024.atktg)
	e2:SetValue(c5312024.atkval)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c5312024.tdcon)
	e3:SetTarget(c5312024.tdtg)
	e3:SetOperation(c5312024.tdop)
	c:RegisterEffect(e3)
end
function c5312024.atktg(e,c)
	return c:IsSetCard(0x223)
end
function c5312024.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c5312024.atkval(e,c)
	return Duel.GetMatchingGroupCount(c5312024.atkfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)*100
end
function c5312024.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x223) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c5312024.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c5312024.filter,1,nil)
end
function c5312024.tdfilter(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c5312024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c5312024.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5312024.tdfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c5312024.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c5312024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end