--Adaptive Mecha Girl
function c249000833.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon self
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000833.spcon)
	e2:SetOperation(c249000833.spop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(43237273,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c249000833.target)
	e3:SetOperation(c249000833.operation)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c249000833.spcon2)
	e4:SetTarget(c249000833.sptg)
	e4:SetOperation(c249000833.spop2)
	c:RegisterEffect(e4)
end
function c249000833.spfilter(c)
	return c:IsSetCard(0x1F5) and c:IsType(TYPE_MONSTER)
end
function c249000833.spfilter2(c)
	return c:IsSetCard(0x1F5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000833.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c249000833.spfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>1
		and Duel.IsExistingMatchingCard(c249000833.spfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,2,nil)
end
function c249000833.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000833.spfilter2,tp,LOCATION_GRAVE+LOCATION_MZONE+LOCATION_HAND,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000833.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and (c:IsSummonableCard() or c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK))
end
function c249000833.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c249000833.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000833.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c249000833.tgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c249000833.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		if tc and not tc:IsType(TYPE_TOKEN) then
			c:CopyEffect(tc:GetOriginalCodeRule(), RESET_EVENT+0x1fe0000)
		end
	end
end
function c249000833.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and not c:IsLocation(LOCATION_DECK)
end
function c249000833.spfilter3(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetRank()<=8
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(c249000833.spfilter4,tp,LOCATION_GRAVE,0,1,nil,c:GetRace(),c:GetAttribute())
end
function c249000833.spfilter4(c,rc,att)
	return c:IsRace(rc) and c:IsAttribute(att)
end
function c249000833.lzfilter(c)
	return c:GetSequence()>4
end
function c249000833.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000833.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c249000833.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	end
end
function c249000833.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000833.lzfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.BreakEffect()
	local g2=Duel.SelectMatchingCard(tp,c249000833.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g2:GetFirst()
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
		tc:CompleteProcedure()
	end
end
