--Unseen Amalgam
--by Nix
--archetype setcode: 5AA
--known issues: 
function c49181103.initial_effect(c)
	aux.AddUnionProcedure(c,c49181103.unfilter)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49181103,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49181103.dircon) --stops this card from being able to use the effect without having the equip
	e2:SetOperation(c49181103.dirop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c49181103.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49181103,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,491811030)
	e4:SetCondition(c49181103.spcon)
	e4:SetTarget(c49181103.sptg)
	e4:SetOperation(c49181103.spop)
	c:RegisterEffect(e4)
end
function c49181103.unfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c49181103.eftg(e,c)
	if e:GetHandler():GetEquipTarget():IsCode(49181103) then return end --doesn't grant effect to other copies of this card
	return e:GetHandler():GetEquipTarget()==c
end
function c49181103.desfilter(c)
	return c:IsType(TYPE_EQUIP)
end
function c49181103.tgfilter(c)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c49181103.dircon(e)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,49181103) --line 20
end
function c49181103.dirop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c49181103.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c49181103.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c49181103.spfilter(c,e,tp)
	return c:IsSetCard(0x5AA) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49181103.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c49181103.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c49181103.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c49181103.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c49181103.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
