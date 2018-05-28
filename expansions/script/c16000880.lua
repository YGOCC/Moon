--Medivatale Cactusat
function c16000880.initial_effect(c)
	   --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16000880)
	e1:SetCondition(c16000880.sprcon)
	c:RegisterEffect(e1) 
--summon success
	local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_HAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c16000880.thtg)
	e2:SetOperation(c16000880.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--become material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c16000880.mtcon)
	e5:SetOperation(c16000880.mtop)
	c:RegisterEffect(e5)  
end
function c16000880.cfilter(c)
	return c:IsFaceup() and  c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT)
end
function c16000880.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and not Duel.IsExistingMatchingCard(c16000880.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c16000880.thfilter(c)
	return c:IsSetCard(0xab5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c16000880.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000880.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16000880.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16000880.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16000880.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c16000880.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c16000880.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetReasonCard()
	return  ec:GetMaterial():IsExists(c16000880.ffilter,1,nil) and r&(REASON_SUMMON+REASON_FUSION+REASON_SYNCHRO+REASON_RITUAL+REASON_XYZ+REASON_LINK)==0
end
function c16000880.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16000880)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
   e1:SetDescription(aux.Stringid(16000880,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c16000880.cost)
	e1:SetTarget(c16000880.target)
	e1:SetOperation(c16000880.operation)	
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	   rc:RegisterFlagEffect(16000880,RESET_EVENT+0x1fe0000,0,1)
	end
rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000880,0))
end
function c16000880.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c16000880.xxfilter(c)
	return c:IsType(TYPE_MONSTER)
end

function c16000880.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp  and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c16000880.xxfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c16000880.xxfilter,tp,0,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c16000880.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

