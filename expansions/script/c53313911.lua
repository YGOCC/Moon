--Mysterious Runner
function c53313911.initial_effect(c)
	--You can Special Summon this card (from your hand) by shuffling 2 of your banished "Mysterious" monsters into the deck.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c53313911.spcon)
	e1:SetOperation(c53313911.spop)
	c:RegisterEffect(e1)
	--When this card is targetted for a battle, you can shuffle this card in your deck, and shuffle the attacking monster in your opponent's deck.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetTarget(c53313911.tdtg)
	e2:SetOperation(c53313911.tdop)
	c:RegisterEffect(e2)
end
function c53313911.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcf6) and c:IsAbleToDeckOrExtraAsCost()
end
function c53313911.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c53313911.cfilter,tp,LOCATION_REMOVED,0,2,nil)
end
function c53313911.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c53313911.cfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c53313911.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.FromCards(e:GetHandler(),Duel.GetAttacker())
	Duel.GetAttacker():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
end
function c53313911.tdop(e,tp,eg,ep,ev,re,rp)
	local g=Group.FromCards(e:GetHandler(),Duel.GetAttacker()):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
