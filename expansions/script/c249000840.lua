--Xyz-Unlocker
function c249000840.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c249000840.cost)
	e1:SetTarget(c249000840.target)
	e1:SetOperation(c249000840.operation)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(249000840,ACTIVITY_SPSUMMON,c249000840.counterfilter)
end
function c249000840.counterfilter(c)
	return c:GetSummonType()~=SUMMON_TYPE_LINK
end
function c249000840.costfilter(c)
	return c:IsSetCard(0x1F7) and c:IsAbleToRemoveAsCost()
end
function c249000840.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler() 
	if chk==0 then return Duel.GetCustomActivityCount(249000840,tp,ACTIVITY_SPSUMMON)==0
	and Duel.IsExistingMatchingCard(c249000840.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		end
	if Duel.GetLP(tp) < 3000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,1500)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000840.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c249000840.splimitcost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c249000840.splimitcost(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c249000840.filter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()<=8
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000840.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c249000840.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000840.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000840.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(tc,tc2)
		end
		tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(tc,tc2)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetCountLimit(1)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c249000840.rmcon)
		e1:SetOperation(c249000840.rmop)
		e1:SetLabel(1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
		tc:CompleteProcedure()
	end
end
function c249000840.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c249000840.rmop(e,tp,eg,ep,ev,re,r,rp)
	local t=e:GetLabel()
	if t==1 then e:SetLabel(0)
	else Duel.Remove(e:GetLabelObject(),POS_FACEUP,REASON_EFFECT)
	end
end