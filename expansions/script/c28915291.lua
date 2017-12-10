--VRT.EXE Ouroborus
--Design and code by Kindrindra
local ref=_G['c'..28915291]
function ref.initial_effect(c)
	--Fusion
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x72B),2,true)
	c:EnableReviveLimit()
	--aux.AddFusionProcFunFunRep(c,ref.matfilter,ref.matfilter,1,63,true)
	--Cannot Respond to Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(ref.effcon)
	e1:SetOperation(ref.spsumsuc)
	c:RegisterEffect(e1)
	--Disrespond
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28915291,0))
	e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e2:SetType(EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
	e2:SetCondition(ref.chaincon)
	e2:SetOperation(ref.chainop)
	c:RegisterEffect(e2)
	--Recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(ref.thtg)
	e3:SetOperation(ref.thop)
	c:RegisterEffect(e3)
end

function ref.matfilter(c)
	return c:IsFusionSetCard(0x72B)
end

function ref.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
end
function ref.spsumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(ref.chlimit)
end
function ref.chlimit(e,ep,tp)
	return tp==ep
end

function ref.chaincon(e,tp,eg,ep,ev,re,r,rp)
	AI.Chat("Con Chk")
	return re:GetHandler()==e:GetHandler()
end
function ref.chainop(e,tp,eg,ep,ev,re,r,rp)
	AI.Chat("Chain Sealed")
	Duel.SetChainLimit(ref.chlimit)
end

function ref.thfilter(c)
	return c:IsSetCard(0x72B) and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,ref.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
