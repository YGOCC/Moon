--Spark Cosmo'n
function c81400264.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81400264,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c81400264.target)
	e1:SetOperation(c81400264.operation)
	c:RegisterEffect(e1)
end
function c81400264.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xCF11) and c:IsLevelAbove(1)
end
function c81400264.spfilter(c,e,tp)
	return c:IsSetCard(0xCF11) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81400264.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81400264.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c81400264.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81400264.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81400264.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local op=0
	if tc:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(70908596,1))
		else op=Duel.SelectOption(tp,aux.Stringid(70908596,1),aux.Stringid(70908596,2)) end
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81400264.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else e1:SetValue(-1) end
		if tc:RegisterEffect(e1) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c81400264.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g2:GetCount()>0 then
				Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end