--Winter Bloom
local ref=_G['c'..18917023]
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,18917023)
	e2:SetCondition(ref.thcon)
	e2:SetCost(ref.thcost)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end

function ref.actfilter(c)
	return c:IsFaceup() and not (c.seedling or c:IsHasEffect(270))
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.actfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,ref.actfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(270)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local be1=Effect.CreateEffect(c)
		be1:SetDescription(aux.Stringid(269,0))
		be1:SetType(EFFECT_TYPE_SINGLE)
		be1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		be1:SetCode(269)
		be1:SetReset(RESET_EVENT+0x1fe0000)
		be1:SetCondition(ref.bloomcon)
		tc:RegisterEffect(be1)
	end
end
function ref.exfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function ref.bloomcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(ref.exfilter,tp,0,LOCATION_MZONE,1,nil)
end

function ref.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function ref.thcfilter(c)
	return c.seedling and c:IsAbleToRemoveAsCost()
end
function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thcfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.thcfilter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
