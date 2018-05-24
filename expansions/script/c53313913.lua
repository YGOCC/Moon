--Mysterious Caterpillar
function c53313913.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P: If an effect is activated that would destroy a card(s) you control: You can destroy this card, also negate the activation and destroy it.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c53313913.target)
	e1:SetOperation(c53313913.operation)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
	--M: Once per turn: You can target 1 Spell/Trap card you control and 1 Spell/Trap card on the field: Shuffle both targets in the decks.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetTarget(c53313913.tdtg)
	e2:SetOperation(c53313913.tdop)
	c:RegisterEffect(e2)
end
function c53313913.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if not re then
		ev=Duel.GetCurrentChain()-1
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		eg=re:GetHandler()
	end
	if chk==0 then
		if not Duel.IsChainNegatable(ev) then return false end
		if re:IsHasCategory(CATEGORY_NEGATE) and ev>1
			and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
		local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
		return ex and tg~=nil and tc+tg:Filter(Card.IsOnField,nil):FilterCount(Card.IsControler,nil,tp)-tg:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c53313913.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	if not re then
		ev=math.max(Duel.GetCurrentChain()-1,1)
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		eg=re:GetHandler()
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c53313913.filter1(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,TYPE_SPELL+TYPE_TRAP)
end
function c53313913.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c53313913.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c53313913.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1,TYPE_SPELL+TYPE_TRAP)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function c53313913.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==2 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
