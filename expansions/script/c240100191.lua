--Swordsmasterror Siegfried
function c240100191.initial_effect(c)
	--If this card attacks a Defense Position monster, inflict piercing battle damage.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e0)
	--Gains 100 ATK for each "Swordsmaster" monster in the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c240100191.val)
	c:RegisterEffect(e1)
	--If this card is sent to the GY: Target 1 Spell/Trap you control and 1 "Swordsmaster" monster in your GY, except "Swordsmasterror Siegfried"; destroy the first target and Special Summon the second target.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c240100191.sptg)
	e3:SetOperation(c240100191.spop)
	c:RegisterEffect(e3)
end
function c240100191.val(e,c)
	return Duel.GetMatchingGroupCount(c240100191.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)*100
end
function c240100191.rfilter(c)
	return c:IsSetCard(0xbb2) and c:IsType(TYPE_MONSTER)
end
function c240100191.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c240100191.spfilter(c,e,tp)
	return c:IsSetCard(0xbb2) and not c:IsCode(240100191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100191.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--Target 1 Spell/Trap you control and 1 "Swordsmaster" monster in your GY, except "Swordsmasterror Siegfried"
	if chkc then return false end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c240100191.desfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingTarget(c240100191.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectTarget(tp,c240100191.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectTarget(tp,c240100191.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
	end
end
function c240100191.spop(e,tp,eg,ep,ev,re,r,rp)
	--destroy the first target and Special Summon the second target
	local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	if not dg or not cg then return end
	local dc=dg:GetFirst()
	local cc=cg:GetFirst()
	if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e) and dc:IsDestructable() and cc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.Destroy(dc,REASON_EFFECT)
		Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
	end
end
