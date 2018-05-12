--Newtrix Night Veil
function c240100232.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c240100232.target)
	e1:SetOperation(c240100232.operation)
	c:RegisterEffect(e1)
	--Equip only to a "Newtrix" monster.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c240100232.eqlimit)
	c:RegisterEffect(e2)
	--It does not have to activate its effects.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(240100231)
	c:RegisterEffect(e3)
	--If this card is destroyed and the equipped monster (if any) is not on the field: You can target 1 "Newtrix" monster in your GY; Special Summon it.
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(122518919,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c240100232.spcon)
	e4:SetTarget(c240100232.sptg)
	e4:SetOperation(c240100232.spop)
	c:RegisterEffect(e4)
end
function c240100232.eqlimit(e,c)
	return c:IsSetCard(0xd10)
end
function c240100232.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd10)
end
function c240100232.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c240100232.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c240100232.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c240100232.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c240100232.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c240100232.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetPreviousEquipTarget() or not e:GetHandler():GetPreviousEquipTarget():IsOnField()
end
function c240100232.spfilter(c,e,tp)
	return c:IsSetCard(0xd10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c240100232.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c240100232.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c240100232.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c240100232.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c240100232.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFirstTarget()
	if g:IsRelateToEffect(e) then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
