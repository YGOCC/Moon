function c90210029.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90210029,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c90210029.sptg)
	e2:SetOperation(c90210029.spop)
	c:RegisterEffect(e2)
	--banish to special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90210029,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c90210029.cost)
	e3:SetTarget(c90210029.target)
	e3:SetOperation(c90210029.operation)
	c:RegisterEffect(e3)
end
function c90210029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c90210029.banishfilter(c,e,tp)
	return (c:IsSetCard(0x12C) or c:IsSetCard(0x12D)) and c:IsType(TYPE_MONSTER) and c:GetCode()~=90210023 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c90210029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90210029.banishfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c90210029.banishfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c90210029.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c90210029.filter(c)
	return (c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130)) and c:IsAbleToDeckAsCost()
end
function c90210029.spfilter(c,e,tp)
	return (c:IsSetCard(0x12C) or c:IsSetCard(0x12D)) and c:IsType(TYPE_MONSTER) and c:GetCode()~=90210023
	and c:GetCode()~=90210037 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c90210029.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210029.filter,tp,LOCATION_GRAVE,0,1,c)
		and Duel.IsExistingMatchingCard(c90210029.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c90210029.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c90210029.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c90210029.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c90210029.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local bg=Duel.SelectMatchingCard(tp,c90210029.filter,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SendtoDeck(bg,nil,1,REASON_COST)
	Duel.ShuffleDeck(tp)
	local g=Duel.GetMatchingGroup(c90210029.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>=1 then
		local fid=e:GetHandler():GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		local tc=sg:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(90210029,RESET_EVENT+0x1fe0000,0,1,fid)
			tc=sg:GetNext()
		end
	end
end