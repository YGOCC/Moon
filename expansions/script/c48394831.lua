function c48394831.initial_effect(c)
	--Equip (0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c48394831.target)
	e1:SetOperation(c48394831.operation)
	c:RegisterEffect(e1)
	--Equip Limit (1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetValue(c48394831.eqlimit)
	c:RegisterEffect(e2)
	--Equip Search (2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c48394831.escondition)
	e3:SetTarget(c48394831.estarget)
	e3:SetOperation(c48394831.esoperation)
	c:RegisterEffect(e3)
	--Normal Summon (3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetTarget(c48394831.nstarget)
	e4:SetOperation(c48394831.nsoperation)
	c:RegisterEffect(e4)
end

--Equip (0)
function c48394831.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf77)
end

function c48394831.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c48394831.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c48394831.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c48394831.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c48394831.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end

--Equip Limit (1)
function c48394831.eqlimit(e,c)
	return c:IsSetCard(0xf77)
end

--Equip Search (2)
function c48394831.escondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(48394830)
end

function c48394831.estarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c48394830.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c48394831.esoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c48394830.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c48394831.filter(c)
	return c:IsCode(48394830) and c:IsAbleToHand()
end

--Normal Summon (3)
function c48394831.nstarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c48394831.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c48394831.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c48394831.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end

function c48394831.nsoperation(e,tp,eg,ep,ev,re,r,rp)
    	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c48394831.filter1(tc) then
		tc:EnableDualState()
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCountLimit(1)
		tc:RegisterEffect(e5,true)
	end
        Duel.Equip(tp,e:GetHandler(),tc)
        Duel.Summon(tp,tc,true,nil)
		
    end

function c48394831.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and not c:IsDualState()
end