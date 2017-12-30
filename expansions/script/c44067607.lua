--Need Backup!
function c44067607.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44067607,1))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,44067607+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c44067607.target)
	e1:SetOperation(c44067607.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44067607,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c44067607.target2)
	e2:SetOperation(c44067607.operation)
	c:RegisterEffect(e2)
end
function c44067607.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x150) and c:IsCanAddCounter(0x85,1)
end
function c44067607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c44067607.filter(chkc) end
	if chk==0 then return true end 
	if Duel.IsExistingTarget(c44067607.filter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.SelectYesNo(tp,aux.Stringid(44067607,1)) then
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c44067607.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x85)
	else
	e:SetProperty(0)
	end
end
function c44067607.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	if tc:IsFaceup() and tc:IsSetCard(0x150) and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x85,1)
	end
end
function c44067607.tfilter(c,code)
	return c:IsSetCard(0x150) and not c:IsCode(code) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c44067607.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsSetCard(0x150) and tc:GetControler()==tp
		and Duel.IsExistingMatchingCard(c44067607.tfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) end
	tc:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44067607.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not e:GetHandler():IsRelateToEffect(e) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c44067607.tfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end