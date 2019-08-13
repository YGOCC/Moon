--Dragofinity Angel
function c249000985.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c249000985.matval)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c249000985.sumop)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c249000985.target)
	e3:SetOperation(c249000985.operation)
	c:RegisterEffect(e3)
end
function c249000985.mfilter(c,e)
	return c==e:GetHandler()
end
function c249000985.matval(e,c,mg)
	return c:IsRace(RACE_DRAGON) and mg:IsExists(c249000985.mfilter,1,nil,e)
end
function c249000985.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,249000985)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(79785958,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1FF))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,249000985,RESET_PHASE+PHASE_END,0,1)
end
function c249000985.filter2(c)
	return c:IsSetCard(0x1FF) and c:IsType(TYPE_MONSTER)
end
function c249000985.filter(c)
	if Duel.IsExistingMatchingCard(c249000985.filter2,tp,LOCATION_GRAVE,0,1,nil) then
		return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
	end
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function c249000985.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c249000985.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000985.filter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c249000985.filter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c249000985.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.SendtoHand(tc,nil,REASON_EFFECT) end
end