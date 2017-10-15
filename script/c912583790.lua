--Virtuakit-α Teleport
function c912583790.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c912583790.target)
	e1:SetOperation(c912583790.operation)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(957890213,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c912583790.spcost)
	e2:SetTarget(c912583790.sptg)
	e2:SetOperation(c912583790.spop)
	c:RegisterEffect(e2)
end
function c912583790.filter(c,tp)
	return c:IsType(TYPE_UNION) and Duel.IsExistingMatchingCard(c912583790.filter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function c912583790.filter2(c,eqc)
	return c:IsFaceup() and c:IsSetCard(0xfe5) and eqc:CheckEquipTarget(c) and aux.CheckUnionEquip(eqc,c)
end
function c912583790.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c912583790.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(c912583790.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c912583790.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c912583790.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c912583790.filter2,tp,LOCATION_MZONE,0,1,1,nil,tc)
		local tc2=g:GetFirst()
		if tc2 and aux.CheckUnionEquip(tc,tc2) and Duel.Equip(tp,tc,tc2) then
			aux.SetUnionState(tc)
		end
	end
end
function c912583790.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c912583790.spfilter(c,e,tp)
	return c:IsSetCard(0xfe5) and not c:IsType(0x10000000) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c912583790.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c912583790.spfilter(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c912583790.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c912583790.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
