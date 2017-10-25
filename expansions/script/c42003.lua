--robot
function c42003.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c42003.cost)
	e1:SetCondition(c42003.drwcon)
	e1:SetTarget(c42003.target)
	e1:SetOperation(c42003.operation)
	c:RegisterEffect(e1)
--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c42003.thtg)
	e2:SetOperation(c42003.thop)
	c:RegisterEffect(e2)
end

function c42003.drwcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(42008)
end
function c42003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c42003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c42003.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c42003.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x98) and c:IsAbleToHand()
end
function c42003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c42003.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(101001037)==0
		and Duel.IsExistingTarget(c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local b1=Duel.IsExistingTarget(c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(42003,0),aux.Stringid(42003,1))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c42003.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c42003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end