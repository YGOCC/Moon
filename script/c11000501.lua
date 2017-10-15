--Shya Divine Shaman
function c11000501.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x1FD),aux.NonTuner(nil),1)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11000501,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11000501.condition)
	e1:SetTarget(c11000501.target)
	e1:SetOperation(c11000501.operation)
	c:RegisterEffect(e1)
end
function c11000501.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c11000501.filter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c11000501.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c11000501.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x1FD) 
		and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c11000501.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local d=dg:FilterCount(c11000501.filter,nil)
	local fg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if d>0 then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rg=fg:Select(tp,d,d,nil)
		Duel.HintSelection(rg)
		Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
	end
end
