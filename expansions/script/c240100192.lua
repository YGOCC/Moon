--Swordsmasterror Tiberius
function c240100192.initial_effect(c)
	--If this card attacks a Defense Position monster, inflict piercing battle damage.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 200 ATK for each "Swordsmaster" monster that was destroyed within the last 2 Standby Phases while this card was on the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100192.val)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetOperation(c240100192.regop)
	c:RegisterEffect(e2)
	--If this card is destroyed: Special Summon 1 "Swordsmaster" monster from your hand.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c240100192.target)
	e3:SetOperation(c240100192.operation)
	c:RegisterEffect(e3)
end
function c240100192.val(e,c)
	return c:GetFlagEffect(240100192)*200
end
function c240100192.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c240100192.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c240100192.rfilter,1,c) then
		c:RegisterFlagEffect(240100192,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY,0,2)
	end
end
function c240100192.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c240100192.spfilter(c,e,tp)
	return c:IsSetCard(0xbb2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100192.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c240100192.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
