--サンダー・高
function c2101400004.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c2101400004.target)
	e1:SetOperation(c2101400004.operation)
	c:RegisterEffect(e1)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2101400004,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c2101400004.condition)
	e1:SetTarget(c2101400004.tdtg)
	e1:SetOperation(c2101400004.tdop)
	c:RegisterEffect(e1)
end
function c2101400004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)~=0 end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*500
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c2101400004.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(p,LOCATION_MZONE,0)*500
	Duel.Damage(p,dam,REASON_EFFECT)
end
--to deck
function c2101400004.cfilter(c)
	return c:IsFaceup() and (c:IsLevel(4) or c:IsRank(4)) and c:IsRace(RACE_THUNDER) and (c:IsAttackAbove(1600) or c:IsDefenseAbove(1600))
end
function c2101400004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2101400004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end 
function c2101400004.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		e:SetCategory(CATEGORY_TODECK)
		e:SetLabel(0)
	end
end
function c2101400004.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and e:GetLabel()==1
		and Duel.SelectYesNo(tp,aux.Stringid(2101400004,1)) then
		Duel.BreakEffect()
		if tc:IsLocation(LOCATION_DECK) and tc:IsControler(tp) then
			Duel.ShuffleDeck(tp)
		end
	end
end