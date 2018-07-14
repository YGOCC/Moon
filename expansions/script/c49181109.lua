--Bestial Amalgam
--by Nix
--archetype setcode: 5AA
--known issues:
function c49181109.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49181109,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c49181109.target)
	e1:SetOperation(c49181109.operation)
	c:RegisterEffect(e1)
end
function c49181109.filter(c,e,tp,ec)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_UNION) and c:CheckEquipTarget(c,ec)
end
function c49181109.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK) and c49181109.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
		return Duel.IsExistingMatchingCard(c49181109.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(c49181109.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
end
function c49181109.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=Duel.SelectMatchingCard(tp,c49181109.filter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,ec):GetFirst()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Equip(tp,ec,c)
		aux.SetUnionState(c)
	end
end