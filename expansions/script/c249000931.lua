--Magical Forces Arts - Counter Synchro
function c249000931.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c249000931.condition)
	e1:SetTarget(c249000931.target)
	e1:SetOperation(c249000931.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c249000931.handcon)
	c:RegisterEffect(e2)
end
function c249000931.confilter(c)
	return c:IsSetCard(0x15A) and c:IsType(TYPE_MONSTER)  and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000931.cfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsControler(tp)
end
function c249000931.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(c249000931.cfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c249000931.confilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c249000931.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c249000931.filter1(c,e,tp,lv)
	local rlv=c:GetLevel()-lv
	return rlv>0 and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(c249000931.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,rlv)
end
function c249000931.filter2(c,tp,lv)
	if c:GetLevel() < 1 then return false end
	local rlv=lv-c:GetLevel()
	return rlv==0 and c:IsSetCard(0x15A) and c:IsAbleToRemove()
end
function c249000931.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and eg:GetCount()==1 then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		local tc=tg:GetFirst()
		if Duel.GetLocationCountFromEx(tp,tp,tc)>0 and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
			and tc:GetLevel()>0 and Duel.IsExistingMatchingCard(c249000931.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,tc:GetLevel())
			and tc:IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(27503418,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=Duel.SelectMatchingCard(tp,c249000931.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel())
			local lv=g1:GetFirst():GetLevel()-tc:GetLevel()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=Duel.SelectMatchingCard(tp,c249000931.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
			g2:AddCard(tc)
			Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
			Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			g1:GetFirst():CompleteProcedure()
		end
	end
end
function c249000931.handcon(e)
	return Duel.IsExistingMatchingCard(c249000931.confilter,tp,LOCATION_MZONE,0,1,nil)
end