--Fordring the Charging Paladin
function c10268938.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c10268938.tfilter,aux.NonTuner(Card.IsSetCard,0x19121),1)
	c:EnableReviveLimit()
		--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c10268938.efilter)
	c:RegisterEffect(e3)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10268938)
	e1:SetTarget(c10268938.target)
	e1:SetOperation(c10268938.activate)
	c:RegisterEffect(e1)
		--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c10268938.indes)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c10268938.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c10268938.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x19121)
end
function c10268938.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingMatchingCard(c10268938.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local ct=Duel.GetMatchingGroupCount(c10268938.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTDECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c10268938.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c10268938.tfilter(c)
	return c:IsSetCard(0x19121)
end
function c10268938.indes(e,c)
	return c:IsSetCard(0xFAB4B) and c:IsFaceup()
end