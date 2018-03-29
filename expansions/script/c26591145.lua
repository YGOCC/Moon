--Arti della Xenofiamma - Aurora
--Script by XGlitchy30
function c26591145.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26591145+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c26591145.target)
	e1:SetOperation(c26591145.activate)
	c:RegisterEffect(e1)
end
--filters
function c26591145.thfilter(c,tp)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c26591145.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c26591145.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x23b9) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL)
end
function c26591145.scfilter(c)
	return c:IsSetCard(0x23b9) and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
--Activate
function c26591145.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c26591145.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp)
		or Duel.IsExistingMatchingCard(c26591145.scfilter,tp,LOCATION_DECK,0,1,nil)
	end
	local opt=0
	if Duel.IsExistingMatchingCard(c26591145.scfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingTarget(c26591145.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591145,0),aux.Stringid(26591145,1))
	elseif Duel.IsExistingMatchingCard(c26591145.scfilter,tp,LOCATION_DECK,0,1,nil) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591145,1))+1
	elseif Duel.IsExistingTarget(c26591145.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil,tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(26591145,0))
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,c26591145.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SetChainLimit(c26591145.limit)
		end
	else
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c26591145.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c26591145.scfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
--limit
function c26591145.limit(e,ep,tp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return tp==ep or not g:IsContains(e:GetHandler())
end
