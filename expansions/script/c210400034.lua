--created & coded by Lyris
--S－VINEの騎士クライッシャ
function c210400034.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSpatialProc(c,8,true,aux.TRUE,aux.TRUE)
	local ae1=Effect.CreateEffect(c)
	ae1:SetType(EFFECT_TYPE_QUICK_O)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_FREE_CHAIN)
	ae1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae1:SetCountLimit(1)
	ae1:SetCost(c210400034.cost)
	ae1:SetTarget(c210400034.tg)
	ae1:SetOperation(c210400034.op)
	c:RegisterEffect(ae1)
end
function c210400034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c210400034.tfilter(c,e)
	return c:IsCanBeEffectTarget(e) and c210400034.filter(c,c:GetOriginalType())
end
function c210400034.filter(c,typ)
	if bit.band(typ,TYPE_MONSTER)==TYPE_MONSTER then
		return c:IsAbleToRemove()
	elseif bit.band(typ,TYPE_SPELL)==TYPE_SPELL then
		return c:IsAbleToDeck()
	else return c:IsAbleToHand() end
end
function c210400034.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c210400034.tfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e)
	local tc=g:GetFirst()
	Duel.SetTargetCard(g)
	if tc:IsFaceup() or tc:IsLocation(LOCATION_MZONE) then
		local cat=CATEGORY_TOHAND
		if bit.band(tc:GetType(),TYPE_MONSTER)==TYPE_MONSTER then cat=CATEGORY_REMOVE elseif bit.band(tc:GetType(),TYPE_SPELL)==TYPE_SPELL then cat=CATEGORY_TODECK end
		e:SetCategory(cat)
		Duel.SetOperationInfo(0,cat,g,1,0,0)
	end
end
function c210400034.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
		if tc:IsType(TYPE_MONSTER) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
		if tc:IsType(TYPE_SPELL) then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) end
		if tc:IsType(TYPE_TRAP) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
	end
end
