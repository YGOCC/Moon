--Shimmering Master Summoner
function c249000719.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000719.spcon)
	e1:SetCost(c249000719.spcost)
	e1:SetTarget(c249000719.sptg)
	e1:SetOperation(c249000719.spop)
	c:RegisterEffect(e1)
end
function c249000719.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x1EA)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>1
end
function c249000719.sumfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0
end
function c249000719.costfilter(c)
	return c:IsSetCard(0x1EA) and c:IsAbleToRemoveAsCost()
end
function c249000719.costattfilter(c,att)
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAttribute(att) and c:GetCode()~=249000719
end
function c249000719.costfilter2(c,e,tp,ct)
	if not c:IsType(TYPE_SYNCHRO+TYPE_XYZ) then return end
	local lvrk
	if c:IsType(TYPE_XYZ) then lvrk=c:GetRank() else lvrk=c:GetLevel() end
	return (lvrk-4 <=ct*2 or lvrk-4 <=ct*2) and Duel.IsExistingMatchingCard(c249000719.costattfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttribute())
		and ((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false))
			or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)))
end
function c249000719.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c249000719.sumfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c249000719.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c249000719.costfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,ct) end
	Duel.Release(e:GetHandler(),REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c249000719.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local g2=Duel.SelectMatchingCard(tp,c249000719.costfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,ct)
	Duel.ConfirmCards(1-tp,g2)
	e:SetLabelObject(g2:GetFirst())
end
function c249000719.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000719.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()==0 then return end
	if Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)==0 then return end
	local tc=e:GetLabelObject()
--	if tc:IsRelateToEffect(e) then
		if tc:IsType(TYPE_SYNCHRO) and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsType(TYPE_XYZ) and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(tc,tc2)
			end
			tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
			if tc2 then
				Duel.Overlay(tc,tc2)
			end
		else return
		end
		if not tc:IsType(TYPE_EFFECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_EFFECT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
		end
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetCondition(c249000719.atkcon)
		e2:SetValue(500)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e3,true)
		local e4=Effect.CreateEffect(tc)
		e4:SetDescription(aux.Stringid(71413901,2))
		e4:SetCategory(CATEGORY_DESTROY)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e4:SetCode(EVENT_SPSUMMON_SUCCESS)
		e4:SetCondition(c249000719.stcon)
		e4:SetTarget(c249000719.sttg)
		e4:SetOperation(c249000719.stop)
		e4:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e4,true)
		local e5=Effect.CreateEffect(tc)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e5:SetCountLimit(1)
		e5:SetValue(c249000719.indescon)
		e5:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e5)
		tc:CompleteProcedure()
--	end
end
function c249000719.atkcon(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_DARK)
end
function c249000719.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c249000719.stcon(e)
	return e:GetHandler():IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_WIND)
end
function c249000719.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c249000719.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000719.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c249000719.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000719.stop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c249000719.indescon(e,re,r,rp)
	return e:GetHandler():IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_LIGHT)
end