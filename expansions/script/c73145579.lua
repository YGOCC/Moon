--Sylphic Aura
--Scripted by Specific
function c73145579.initial_effect(c)
	--Spirit Return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--Cannot Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Activation Limit
	local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(73145579,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,73145579)
	e2:SetCondition(c73145579.limcon1)
	e2:SetCost(c73145579.limcost)
	e2:SetOperation(c73145579.limop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCondition(c73145579.limcon2)
	c:RegisterEffect(e3)
	--Normal Summon
	local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(73145579,1))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetTarget(c73145579.sumtg)
	e4:SetOperation(c73145579.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end
function c73145579.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x125)
end
function c73145579.limcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c73145579.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c73145579.limcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c73145579.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c73145579.limcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c73145579.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c73145579.chainop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c73145579.sucop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(c73145579.cedop)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabelObject(e2)
	Duel.RegisterEffect(e4,tp)
end
function c73145579.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x125) and rc:IsType(TYPE_RITUAL) then
		Duel.SetChainLimit(c73145579.chainlm)
	end
end
function c73145579.chainlm(e,rp,tp)
	return tp==rp
end
function c73145579.sucfilter(c)
	return c:IsSetCard(0x125) and c:IsType(TYPE_RITUAL)
end
function c73145579.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c73145579.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c73145579.cedop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c73145579.chainlm)
	end
end
function c73145579.sumfilter(c)
	return c:IsSetCard(0x125) and not c:IsCode(73145579) and c:IsSummonable(true,nil)
end
function c73145579.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c73145579.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c73145579.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c73145579.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end