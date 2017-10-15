--Harpie Siren
function c13301.initial_effect(c)
	--send
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(13301,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,13301)
	e1:SetCondition(c13301.condition)
	e1:SetTarget(c13301.target)
	e1:SetOperation(c13301.operation)
	c:RegisterEffect(e1)
	--change levels
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13301,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,13301+1)
	e2:SetCondition(c13301.lvcon)
	e2:SetTarget(c13301.lvtg)
	e2:SetOperation(c13301.lvop)
	c:RegisterEffect(e2)
	--change name
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetValue(76812113)
	c:RegisterEffect(e3)
end
function c13301.condition(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x64) and re:GetHandler():IsType(TYPE_MONSTER)
end
function c13301.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x64) and c:IsAbleToGrave()
end
function c13301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13301.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c13301.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13301.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c13301.lvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x64) and not c:IsType(TYPE_XYZ)
end
function c13301.cfilter(c,tp,lv)
	return c:IsFaceup() and c:IsSetCard(0x64) and c:GetLevel()~=lv and not c:IsType(TYPE_XYZ)
end
function c13301.lvcon(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetHandler():GetLevel()
	return Duel.IsExistingMatchingCard(c13301.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lv)
end
function c13301.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13301.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13301.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c13301.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c13301.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c13301.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	local lc=g:GetFirst()
	local lv=tc:GetLevel()
	while lc~=nil do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		lc:RegisterEffect(e1)
		lc=g:GetNext()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c13301.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c13301.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WIND)
end