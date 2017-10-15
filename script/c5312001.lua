--Necromantian Queen
function c5312001.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,5312001)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c5312001.spcon)
	e2:SetOperation(c5312001.spop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5312001,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c5312001.target)
	e4:SetOperation(c5312001.operation)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5312001,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,5312001)
	e5:SetCondition(c5312001.spcon1)
	e5:SetCost(c5312001.spcost1)
	e5:SetTarget(c5312001.sptg1)
	e5:SetOperation(c5312001.spop1)
	c:RegisterEffect(e5)
end
function c5312001.spfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x223) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c5312001.spfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c5312001.spfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x223) and c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
end
function c5312001.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c5312001.spfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c5312001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c5312001.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c5312001.spfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c5312001.copyfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x223)
end
function c5312001.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_REMOVED) and c5312001.copyfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c5312001.copyfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c5312001.copyfilter,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c5312001.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetType()==TYPE_SPELL then
		local ae=tc:GetActivateEffect()
		if tc:GetLocation()==LOCATION_REMOVED and ae then
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(ae:GetDescription())
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END)
			e1:SetTarget(c5312001.spelltg)
			e1:SetOperation(c5312001.spellop)
			tc:RegisterEffect(e1)
		end
	end
end
function c5312001.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c5312001.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
function c5312001.spcon1(e)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c5312001.cfilter1(c)
	return ((c:IsType(TYPE_SPELL) and c:IsSetCard(0x223) and c:IsLocation(LOCATION_GRAVE)) 
		   or (c:IsCode(5312022) and c:IsLocation(LOCATION_SZONE) and c:IsType(TYPE_CONTINUOUS))) and c:IsAbleToRemoveAsCost()
end
function c5312001.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5312001.cfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c5312001.cfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c5312001.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c5312001.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_ZOMBIE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
	end
end