--Xyz-Knight-Summoner Ice
function c249000663.initial_effect(c)
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,249000663)
	e1:SetCost(c249000663.cost)
	e1:SetTarget(c249000663.target)
	e1:SetOperation(c249000663.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c249000663.spcon)
	e2:SetTarget(c249000663.sptg)
	e2:SetOperation(c249000663.spop)
	c:RegisterEffect(e2)
end
function c249000663.costfilter2(c)
	return c:IsSetCard(0x6073) and not c:IsPublic()
end
function c249000663.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c249000663.costfilter2,tp,LOCATION_HAND,0,1,c) end
	local g=Duel.SelectMatchingCard(tp,c249000663.costfilter2,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	e:SetLabel(g:GetFirst():GetOriginalAttribute())
end
function c249000663.filter1(c,e,tp)
	return c:IsSetCard(0x6073) and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c249000663.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c:GetOriginalAttribute(),e,tp) and not c:IsPublic()
end
function c249000663.filter2(c,att,e,tp)
	return c:GetOriginalLevel() > 0 and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c249000663.filter3,tp,LOCATION_EXTRA,0,1,nil,att,c:GetOriginalLevel()+2,e,tp)
end
function c249000663.filter3(c,att,rk,e,tp)
	return (c:GetRank()==rk or c:GetRank()==rk-1) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000663.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000663.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000663.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g1=Duel.SelectMatchingCard(tp,c249000663.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e:GetLabel(),e,tp)
	if g1:GetCount() > 0 and Duel.Remove(g1,POS_FACEUP,REASON_EFFECT) then
		local g2=Duel.SelectMatchingCard(tp,c249000663.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel(),g1:GetFirst():GetOriginalLevel()+2,e,tp)
		local sc=g2:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(sc,c)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,1)
			e1:SetValue(c249000663.aclimit)
			e1:SetCondition(c249000663.actcon)
			sc:RegisterEffect(e1,true)
			if not sc:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				sc:RegisterEffect(e2,true)
			end
			sc:CompleteProcedure()
		end
	end
end
function c249000663.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c249000663.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c249000663.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return ec:IsControler(tp) and ec:IsSetCard(0x6073)
end
function c249000663.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c249000663.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end