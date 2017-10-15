--Chronomis the Space Time Mistress Sorceress
function c249000634.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--register location
	if not c249000634.global_check then
		c249000634.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DRAW)
		ge1:SetOperation(c249000634.regop)
		Duel.RegisterEffect(ge1,0)
	end
	--return cards
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,249000634)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c249000634.cost)
	e1:SetTarget(c249000634.target)
	e1:SetOperation(c249000634.operation)
	c:RegisterEffect(e1)
	--change target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21501505,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000634.condition)
	e2:SetTarget(c249000634.target2)
	e2:SetOperation(c249000634.operation2)
	c:RegisterEffect(e2)
	--pzone destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c249000634.skcon)
	e3:SetTarget(c249000634.sktg)
	e3:SetOperation(c249000634.skop)
	c:RegisterEffect(e3)
end
function c249000634.regop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_RULE) == 0 then return end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,LOCATION_HAND,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(249000634,RESET_PHASE+PHASE_END,0,1)
		tc=g:GetNext()
	end
	g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_MONSTER)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(249000634,RESET_PHASE+PHASE_END,0,2)
		tc=g:GetNext()
	end
end
function c249000634.costfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToDeckAsCost() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE+LOCATION_HAND))
end
function c249000634.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000634.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	and Duel.CheckLPCost(tp,1000) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.PayLPCost(tp,1000)
	local g=Duel.SelectMatchingCard(tp,c249000634.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c249000634.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000634.flagfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,1)
		or Duel.IsExistingMatchingCard(c249000634.flagfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,2) end
end
function c249000634.flagfilter(c,count)
	return c:GetFlagEffect(249000634)==count
end
function c249000634.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000634.flagfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,1)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	g=Duel.SelectMatchingCard(tp,c249000634.flagfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,ft,ft,nil,2)
	if g:GetCount() > 0 then Duel.MoveToField(g,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true) end
end
function c249000634.condition(e,tp,eg,ep,ev,re,r,rp)
	if e==re or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc==e:GetHandler()
end
function c249000634.filter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c249000634.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsOnField() and c249000634.filter(chkc,re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	if chk==0 then return Duel.IsExistingTarget(c249000634.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000634.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c249000634.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end
function c249000634.skcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c249000634.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c249000634.skop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c2356994.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
