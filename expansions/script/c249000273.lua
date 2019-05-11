--Spell-Disciple's Regeration Tome
function c249000273.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,249000273+EFFECT_COUNT_CODE_OATH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetOperation(c249000273.activate)
	c:RegisterEffect(e1)
	if c249000273.counter==nil then
		c249000273.counter=true
		c249000273[0]=0
		c249000273[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c249000273.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_CHAINING)
		e3:SetOperation(c249000273.addcount)
		Duel.RegisterEffect(e3,0)
	end
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c249000273.condition)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c249000273.thtg)
	e4:SetOperation(c249000273.thop)
	c:RegisterEffect(e4)
end
function c249000273.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c249000273[0]=0
	c249000273[1]=0
end
function c249000273.addcount(e,tp,eg,ep,ev,re,r,rp)
	if re:GetOwner():IsSetCard(0x1D9) and re:IsActiveType(TYPE_MONSTER) and re:IsActivated() then
		local p=re:GetOwnerPlayer()
		c249000273[p]=c249000273[p]+1
	end
end
function c249000273.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c249000273.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c249000273.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,249000273)
	if (c249000273[tp]+1) < 3 then Duel.Draw(tp,c249000273[tp]+1,REASON_EFFECT) else Duel.Draw(tp,3,REASON_EFFECT) end
end
function c249000273.condition(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e) and Duel.GetTurnPlayer()==tp
end
function c249000273.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1D9) and c:IsAbleToHand()
end
function c249000273.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c249000273.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000273.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c249000273.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c249000273.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
