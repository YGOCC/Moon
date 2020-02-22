function c11111011.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111011,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,11111011)
	e1:SetTarget(c11111011.drtg)
	e1:SetOperation(c11111011.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c11111011.drcon)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,11111011)
	e3:SetCost(c11111011.cost)
	e3:SetTarget(c11111011.target)
	e3:SetOperation(c11111011.operation)
	c:RegisterEffect(e3)
	--DoubleTuningCheck
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c11111011.valcheck)
	c:RegisterEffect(e4)
end
function c11111011.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c11111011.rmfil(c)
	return c:IsSetCard(0x223) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c11111011.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SYNCHRO)>0
end
function c11111011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11111011.spfilter(c,e,tp)
    return c:IsRace(RACE_WARRIOR) and c:IsSetCard(0x223) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11111011.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.Draw(tp,1,REASON_EFFECT)
	if ct==0 then return end
	local dc=Duel.GetOperatedGroup():GetFirst()
	if not dc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,dc)
	if c11111011.spfilter(dc,e,tp) and Duel.SelectYesNo(tp,2) then
		Duel.BreakEffect()
		if Duel.SpecialSummon(dc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetTarget(c11111011.splimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.ShuffleHand(tp)
	else
		Duel.ShuffleHand(tp)
	end
end
function c11111011.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR)
end
function c11111011.costfilter(c)
	return c:IsSetCard(0x223) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c11111011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11111011.costfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c11111011.costfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c11111011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c11111011.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11111011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c11111011.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c11111011.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c11111011.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end