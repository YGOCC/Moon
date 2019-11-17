local m=110600013
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.pentg)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsType(TYPE_PENDULUM) and not re:GetHandler():IsSetCard(0x303))
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_PENDULUM) and not re:GetHandler():IsSetCard(0x303)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cfilter(c)
	return c:IsSetCard(0x303)
end
function cm.thfilter(c)
	return cm.cfilter(c) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,c)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) 
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.penfilter(c)
	return cm.cfilter(c) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT) then
			Duel.ConfirmCards(1-tp,g) 
			if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
				and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
		end
	end
end