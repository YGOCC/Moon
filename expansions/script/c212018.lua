--Predaplant Dracosera
function c212018.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_DARK),2,2)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(212018,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c212018.cttg)
	e1:SetOperation(c212018.ctop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(212018,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,212018)
	e2:SetCost(c212018.spcost)
	e2:SetTarget(c212018.sptg)
	e2:SetOperation(c212018.spop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c212018.atkval)
	c:RegisterEffect(e3)
end
function c212018.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x1041,1) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1041,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1041,1)
end
function c212018.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:AddCounter(0x1041,1) and tc:GetLevel()>1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c212018.lvcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c212018.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end
function c212018.costfilter(c,e,tp)
	return c:IsDiscardable() and Duel.IsExistingMatchingCard(c212018.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function c212018.spfilter(c,e,tp)
	return (c:IsSetCard(0x10f3) or c:IsSetCard(0x46)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c212018.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c212018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c212018.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(c212018.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c212018.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c212018.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c212018.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c212018.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c212018.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c212018.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1041)*600
	end