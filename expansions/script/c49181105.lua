--Amalgambit
--by Nix
--archetype setcode: 5AA
--known issues: 
function c49181105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c49181105.eqtg)
	e2:SetOperation(c49181105.eqop)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49181105,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c49181105.descon)
	e2:SetTarget(c49181105.destg)
	e2:SetOperation(c49181105.desop)
	c:RegisterEffect(e2)
end
function c49181105.efilter(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c49181105.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c)
end
function c49181105.eqfilter(c,tc)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0x5AA) and c:CheckEquipTarget(tc)
end
function c49181105.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c49181105.efilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c49181105.efilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c49181105.efilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c49181105.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c49181105.eqfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc,true)
	end
end
function c49181105.cfilter(c,tp)
	return c:IsSetCard(0x5AA) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()<5
end
function c49181105.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49181105.cfilter,1,nil,tp) and Duel.GetTurnPlayer()~=tp
end
function c49181105.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c49181105.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
