function c240100219.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSpatialProc(c,4,true,400,nil,aux.FilterBoolFunction(Card.IsSetCard,0x7c4),aux.FilterBoolFunction(Card.IsSetCard,0x7c4))
	local ae1=Effect.CreateEffect(c)
	ae1:SetCategory(CATEGORY_DESTROY)
	ae1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	ae1:SetRange(LOCATION_MZONE)
	ae1:SetCode(EVENT_ATTACK_ANNOUNCE)
	ae1:SetCondition(c240100219.descon)
	ae1:SetOperation(c240100219.desop)
	c:RegisterEffect(ae1)
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_QUICK_O)
	ae2:SetCode(EVENT_FREE_CHAIN)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetCountLimit(1)
	ae2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ae2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	ae2:SetCondition(function(e,tp) return Duel.GetTurnPlayer()~=tp end)
	ae2:SetTarget(c240100219.sptg)
	ae2:SetOperation(c240100219.spop)
	c:RegisterEffect(ae2)
end
function c240100219.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function c240100219.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function c240100219.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7c4) and c:IsAbleToGrave()
end
function c240100219.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c240100219.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c240100219.dfilter,tp,LOCATION_REMOVED,0,4,nil)
		and Duel.IsExistingMatchingCard(c240100219.desfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local dg=Duel.GetMatchingGroup(c240100219.desfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	local ct=dg:GetCount()
	if ct>8 then ct=8 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c240100219.dfilter,tp,LOCATION_REMOVED,0,4,ct,nil)
	Duel.SetTargetParam(g:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,g:GetCount(),0,0)
end
function c240100219.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)==0 then return end
	local ct=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c240100219.desfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,ct,ct,nil)
	Duel.HintSelection(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
