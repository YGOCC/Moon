--Ammunition of the Army
function c600000024.initial_effect(c)
	c:EnableCounterPermit(0x4a8)
	c:SetUniqueOnField(1,1,600000024)
	--add counters
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c600000024.target)
	e1:SetOperation(c600000024.activate)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(600000024,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c600000024.cttg)
	e2:SetOperation(c600000024.ctop)
	c:RegisterEffect(e2)
	--Cannot Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c600000024.sumlimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(600000024,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_TOHAND)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,60000024)
	e7:SetCondition(c600000024.thcon)
	e7:SetTarget(c600000024.thtg)
	e7:SetOperation(c600000024.thop)
	c:RegisterEffect(e7)
	--Destroy replace
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_DESTROY_REPLACE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTarget(c600000024.desreptg)
	e8:SetOperation(c600000024.desrepop)
	c:RegisterEffect(e8)
end
function c600000024.sumlimit(e,c)
	return not c:IsSetCard(0x24a8)
end
function c600000024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x4a8,20,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,20,0,0x4a8)
end
function c600000024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x4a8,20)
	end
end
function c600000024.ctfilter(c,e,tp)
	return c:IsFaceup() or c:IsFacedown()
end
function c600000024.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x4a8,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c600000024.ctfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x4a8)
end
function c600000024.ctop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroupCount(c600000024.ctfilter,tp,LOCATION_REMOVED,0,nil)
	e:GetHandler():AddCounter(0x4a8,sg)
end
function c600000024.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_MZONE and c:IsReason(REASON_EFFECT)
		and c:IsReason(REASON_DESTROY)
end
function c600000024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c600000024.cfilter,1,nil)
end
function c600000024.thfilter(c)
	return c:IsSetCard(0x24a8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c600000024.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp and c600000024.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c600000024.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c600000024.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c600000024.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c600000024.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x4a8)>1 end
	return Duel.SelectEffectYesNo(tp,600000024,2)
end
function c600000024.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x4a8,2,REASON_EFFECT)
end