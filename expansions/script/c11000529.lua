--Assault on Shya
function c11000529.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c11000529.cost)
	e1:SetTarget(c11000529.target)
	e1:SetOperation(c11000529.activate)
	c:RegisterEffect(e1)
end
function c11000529.cfilter(c,tp)
	return c:IsSetCard(0x1FD) and (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
end
function c11000529.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c11000529.cfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c11000529.cfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c11000529.filter(c,e,tp)
	return c:IsSetCard(0x1FD) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11000529.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c11000529.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11000529.filter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c11000529.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
