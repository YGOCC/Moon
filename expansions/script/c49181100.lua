--Pure Amalgam
--by Nix
--archetype setcode: 5AA
--known issues: 
function c49181100.initial_effect(c)
	aux.AddUnionProcedure(c,c49181100.unfilter)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49181100,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49181100.tgcon) --stops this card from being able to use the effect without having the equip
	e2:SetTarget(c49181100.tgtg)
	e2:SetOperation(c49181100.tgop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c49181100.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--equip from gy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49181100,1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,491811000)
	e4:SetCondition(c49181100.sadcon)
	e4:SetTarget(c49181100.sadtg)
	e4:SetOperation(c49181100.sadop)
	c:RegisterEffect(e4)
end
function c49181100.unfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c49181100.eftg(e,c)
	if e:GetHandler():GetEquipTarget():IsCode(49181100) then return end --doesn't grant effect to other copies of this card
	return e:GetHandler():GetEquipTarget()==c
end
function c49181100.desfilter(c)
	return c:IsType(TYPE_EQUIP)
end
function c49181100.tgfilter(c)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c49181100.tgcon(e)
	return e:GetHandler():GetEquipGroup():IsExists(Card.IsCode,1,nil,49181100) --line 20
end
function c49181100.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49181100.desfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c49181100.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_SZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c49181100.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c49181100.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c49181100.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c49181100.sadcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c49181100.tcfilter(tc,ec)
	return tc:IsFaceup() and ec:CheckEquipTarget(tc)
end
function c49181100.ecfilter(c)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0x5AA)
	 and Duel.IsExistingTarget(c49181100.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c49181100.sadtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		if not Duel.IsExistingTarget(c49181100.ecfilter,tp,LOCATION_GRAVE,0,1,nil) then return false end
		if e:GetHandler():IsLocation(LOCATION_HAND) then
			return Duel.GetLocationCount(tp,LOCATION_SZONE)>1
		else return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(49181100,1))
	local g=Duel.SelectTarget(tp,c49181100.ecfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local ec=g:GetFirst()
	e:SetLabelObject(ec)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(49181100,1))
	Duel.SelectTarget(tp,c49181100.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,ec:GetEquipTarget(),ec)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,ec,1,0,0)
end
function c49181100.sadop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local ec=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==ec then tc=g:GetNext() end
	if ec:IsFaceup() and ec:IsRelateToEffect(e) then 
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Equip(tp,ec,tc)
		end
	end
end