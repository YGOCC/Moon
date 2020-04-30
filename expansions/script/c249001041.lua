--Armor of Justice Assailant
function c249001041.initial_effect(c)
	aux.EnableDualAttribute(c)
	c:EnableCounterPermit(0x26)
	--special summon (to hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67225377,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,249001041)
	e1:SetCondition(c249001041.spcon)
	e1:SetCost(c249001041.spcost1)
	e1:SetTarget(c249001041.sptg1)
	e1:SetOperation(c249001041.spop1)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7200041,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(aux.IsDualState)
	e2:SetTarget(c249001041.addct)
	e2:SetOperation(c249001041.addc)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c249001041.reptg)
	c:RegisterEffect(e3)
	--double attack
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetCondition(aux.IsDualState)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    --destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(56921677,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLED)
	e5:SetCondition(c249001041.condition)
	e5:SetTarget(c249001041.target)
	e5:SetOperation(c249001041.operation)
	c:RegisterEffect(e5)
end
function c249001041.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not (r==REASON_RULE)
end
function c249001041.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c249001041.spfilter1(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x205) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249001041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249001041.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c249001041.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c249001041.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249001041.spfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249001041.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x26)
end
function c249001041.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x26,2)
	end
end
function c249001041.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsDualState(e) and (e:GetHandler():IsCanRemoveCounter(tp,0x26,1,REASON_COST) or e:GetHandler():IsAbleToHand()) and not e:GetHandler():IsReason(REASON_REPLACE) end
	if e:GetHandler():IsCanRemoveCounter(tp,0x26,1,REASON_COST) then e:GetHandler():RemoveCounter(tp,0x26,1,REASON_EFFECT) else Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
	return true
end
function c249001041.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and aux.IsDualState(e)
end
function c249001041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c249001041.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
end