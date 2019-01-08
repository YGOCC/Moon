--Restitutio dall'Organizzazione Angeli
--Script by XGlitchy30
function c16599472.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16599471)
	e1:SetCost(c16599472.cost)
	e1:SetTarget(c16599472.target)
	e1:SetOperation(c16599472.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,10599471)
	e2:SetCondition(c16599472.lpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c16599472.lptg)
	e2:SetOperation(c16599472.lpop)
	c:RegisterEffect(e2)
end
--filters
function c16599472.costfilter(c)
	return c:IsSetCard(0x1559) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c16599472.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c16599472.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
--Activate
function c16599472.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16599472.costfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16599472.costfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c16599472.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c16599472.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16599472.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16599472.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c16599472.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p=Duel.GetTurnPlayer()
	if tc:IsRelateToEffect(e) and tc:IsAbleToRemove() then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			if p==tp then
				e1:SetTargetRange(0,1)
			else
				e1:SetTargetRange(1,0)
			end
			e1:SetValue(c16599472.aclimit)
			e1:SetLabel(tc:GetType())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c16599472.aclimit(e,re,tp)
	local c=re:GetHandler()
	local typ=e:GetLabel()
	return ((typ&TYPE_SPELL==TYPE_SPELL and c:IsType(TYPE_SPELL)) or (typ&TYPE_TRAP==TYPE_TRAP and c:IsType(TYPE_TRAP))) and not c:IsImmuneToEffect(e)
end
--recover
function c16599472.lpcon(e,tp,eg,ep,ev,re,r,rp)
	local att=Duel.GetAttacker()
	local def=Duel.GetAttackTarget()
	return ep==tp
		and att and def and ((att:GetControler()==tp and att:IsRace(RACE_FAIRY) and att:IsRelateToBattle())
		or (def:GetControler()==tp and def:IsRace(RACE_FAIRY) and def:IsRelateToBattle()))
end
function c16599472.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c16599472.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c16599472.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(16599472,0)) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c16599472.tdfilter,tp,LOCATION_REMOVED,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTODECK)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToDeck() then
			local opt=Duel.SelectOption(tp,aux.Stringid(16599472,1),aux.Stringid(16599472,2))
			if opt==0 then
				Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
			else
				Duel.SendtoDeck(tc,nil,1,REASON_EFFECT)
			end
		end
	end
end
