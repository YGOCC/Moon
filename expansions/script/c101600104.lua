--Stardust
function c101600104.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600104,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c101600104.spcon)
	e1:SetTarget(c101600104.sptg)
	e1:SetOperation(c101600104.spop)
	e1:SetCountLimit(1,11600104)
	c:RegisterEffect(e1)
	--"synchro custom"
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101600104,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101600104.target)
	e4:SetOperation(c101600104.operation)
	e4:SetCountLimit(1,101610104)
	c:RegisterEffect(e4)
end
function c101600104.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>0
end
function c101600104.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c101600104.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c101600104.synfilter(c,e,tp)
	local lv=c:GetLevel()
	local lv2=e:GetHandler():GetOriginalLevel()
	return lv>0 and c:IsSetCard(0xcd01) and not c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101600104.exfilter,tp,LOCATION_EXTRA,0,1,nil,lv+lv2,e,tp)
end
function c101600104.exfilter(c,lv,e,tp)
	return c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c101600104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c101600104.synfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101600104.synfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local rg=Group.FromCards(g:GetFirst(),e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(e:GetHandler():GetLevel()+g:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101600104.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101600104.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
		local sc=sg:GetFirst()
		Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end
