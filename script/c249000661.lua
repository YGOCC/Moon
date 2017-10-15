--Xyz-Knight-Summoner Earth
function c249000661.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c249000661.reptg)
	e1:SetValue(c249000661.repval)
	e1:SetOperation(c249000661.repop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,249000661)
	e2:SetCost(c249000661.cost)
	e2:SetTarget(c249000661.target)
	e2:SetOperation(c249000661.operation)
	c:RegisterEffect(e2)
end
function c249000661.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsType(TYPE_XYZ)
		and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c249000661.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c249000661.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(39996157,0))
end
function c249000661.repval(e,c)
	return c249000661.repfilter(c,e:GetHandlerPlayer())
end
function c249000661.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c249000661.costfilter(c)
	return c:IsSetCard(0x6073) and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function c249000661.costfilter2(c)
	return c:IsSetCard(0x6073) and not c:IsPublic()
end
function c249000661.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000661.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000661.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249000661.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000661.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000661.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000661.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		local g=Duel.SelectMatchingCard(tp,c249000661.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		e:SetLabel(g:GetFirst():GetOriginalAttribute())
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249000661.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
		e:SetLabel(g:GetFirst():GetOriginalAttribute())
	end
end
function c249000661.filter1(c,e,tp)
	return c:IsSetCard(0x6073) and c:IsType(TYPE_MONSTER) and (((c:IsAbleToRemoveAsCost() and c:IsLocation(LOCATION_GRAVE)) or c:IsLocation(LOCATION_HAND) and not c:IsPublic())) 
		and Duel.IsExistingMatchingCard(c249000661.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),c:GetOriginalAttribute(),e,tp)
end
function c249000661.filter2(c,att,e,tp)
	return c:GetOriginalLevel() > 0	and Duel.IsExistingMatchingCard(c249000661.filter3,tp,LOCATION_EXTRA,0,1,nil,att,c:GetOriginalLevel(),e,tp)
end
function c249000661.filter3(c,att,rk,e,tp)
	return (c:GetRank()==rk or c:GetRank()==rk-1) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c249000661.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000661.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000661.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsControler(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	local g1=Duel.SelectMatchingCard(tp,c249000661.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,e:GetLabel(),e,tp)
	if g1:GetCount() > 0 and Duel.SendtoGrave(g1,REASON_EFFECT) then
		local g2=Duel.SelectMatchingCard(tp,c249000661.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e:GetLabel(),g1:GetFirst():GetOriginalLevel(),e,tp)
		local sc=g2:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			Duel.Overlay(sc,c)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(sc,tc2)
			end
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
			e1:SetCountLimit(1)
			e1:SetValue(aux.TRUE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
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