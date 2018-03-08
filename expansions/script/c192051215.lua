--coded by Lyris
--Steelus Acceleratem
function c192051215.initial_effect(c)
	c:EnableReviveLimit()
	--1 Dragon Tuner + 1+ Dragon non-Tuner monsters
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	--When this card is Synchro Summoned: You can shuffle 3 "Steelus" cards from your GY into your Deck and draw 1 card. (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetDescription(aux.Stringid(192051215,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCondition(c192051215.tgcon)
	e1:SetCost(c192051215.cost)
	e1:SetTarget(c192051215.tdtg)
	e1:SetOperation(c192051215.tdop)
	c:RegisterEffect(e1)
	--When this card is Synchro Summoned: You can return 3 banished cards to your Graveyard. (1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetDescription(aux.Stringid(192051215,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCondition(c192051215.tgcon)
	e2:SetCost(c192051215.cost)
	e2:SetTarget(c192051215.tgtg)
	e2:SetOperation(c192051215.tgop)
	c:RegisterEffect(e2)
end
function c192051215.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c192051215.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c192051215.filter1(c)
	return c:IsSetCard(0x617) and c:IsAbleToDeck()
end
function c192051215.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c192051215.filter1,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c192051215.tdop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp,1) then return end
	local tg=Duel.SelectMatchingCard(tp,c192051215.filter1,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c192051215.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_REMOVED,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_REMOVED)
end
function c192051215.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(192051215,2))
	local sg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_REMOVED,0,3,3,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN,tp)
	end
end
