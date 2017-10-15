--Empire Moon Ninja #2
function c90000082.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Pendulum Condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90000082.tg)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c90000082.condition)
	e2:SetCost(c90000082.cost)
	e2:SetTarget(c90000082.target)
	e2:SetOperation(c90000082.operation)
	c:RegisterEffect(e2)
	--Level Up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,90000082)
	e3:SetTarget(c90000082.target2)
	e3:SetOperation(c90000082.operation2)
	c:RegisterEffect(e3)
end
function c90000082.tg(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c90000082.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_SZONE,13-e:GetHandler():GetSequence())
end
function c90000082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function c90000082.filter(c,e,tp,lsc,rsc)
	return c:GetLevel()>lsc and c:GetLevel()<rsc and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_RITUAL)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,true)
end
function c90000082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90000082.filter,tp,LOCATION_HAND,0,1,nil,e,tp,lsc,rsc) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c90000082.operation(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if lsc>rsc then lsc,rsc=rsc,lsc end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000082.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,lsc,rsc)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,true,POS_FACEUP)
	end
end
function c90000082.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c90000082.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		local tc=tg:GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(tc:GetLevel())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e:GetHandler():RegisterEffect(e1)
		end
		Duel.ShuffleHand(1-tp)
	end
end