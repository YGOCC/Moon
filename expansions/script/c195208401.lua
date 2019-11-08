local cid,id=GetID()
--Ghastly Franne & Horror Show
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--Must be Special Summoned by shuffling 3 Tuners with 0 ATK and 1800 DEF from your GY into your Deck.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cid.spcon)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
	--You can only Special Summon "Ghastly Franne & Horror Show(s)" once per turn.
	c:SetSPSummonOnce(id)
	--(Quick Effect): You can banish 1 card you control; add 1 Tuner monster with 0 ATK and 1800 DEF from your Deck to your hand. You cannot conduct your Battle Phase the turn you activate this effect. You can only activate this effect of "Ghastly Franne & Horror Show" once per turn.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetCost(cid.cost)
	e3:SetTarget(cid.tg)
	e3:SetOperation(cid.op)
	c:RegisterEffect(e3)
end
function cid.filter(c,f)
	return c:IsType(TYPE_TUNER) and c:IsAttack(0) and c:IsDefense(1800) and (not f or f(c))
end
function cid.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_GRAVE,0,3,nil,Card.IsAbleToDeckAsCost)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE,0,3,3,nil,Card.IsAbleToDeckAsCost)
	c:SetMaterial(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,1,1,nil),POS_FACEUP,REASON_COST)
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,Card.IsAbleToHand) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,Card.IsAbleToHand)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
