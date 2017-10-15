--Transfigured Agony Beast
function c906790134.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,2)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71921856,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c906790134.mattg)
	e1:SetOperation(c906790134.matop)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(77334267,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG2_XMDETACH+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c906790134.descost)
	e2:SetTarget(c906790134.destg)
	e2:SetOperation(c906790134.desop)
	c:RegisterEffect(e2)
end
function c906790134.filter(c)
	return c:IsSetCard(0xfe9) and c:IsType(TYPE_MONSTER)
end
function c906790134.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c906790134.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function c906790134.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c906790134.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function c906790134.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c906790134.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c906790134.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c906790134.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c906790134.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c906790134.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
	Duel.SetChainLimit(c906790134.chlimit)
end
function c906790134.chlimit(e,ep,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tp==ep or not g:IsContains(e:GetHandler())
end
function c906790134.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
