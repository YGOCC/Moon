--Coins of Mercy
function c500316071.initial_effect(c)
c:EnableCounterPermit(0x88)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,500316071+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c500316071.target)
	e1:SetOperation(c500316071.activate)
	c:RegisterEffect(e1)
end
function c500316071.filter(c)
	return c:IsFaceup() and c:IsType(CTYPE_EVOLUTE) and c:GetStage()>0
end
function c500316071.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c500316071.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500316071.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(500316071,1))
	Duel.SelectTarget(tp,c500316071.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x88)
end

function c500316071.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x88,1) then
		end
	end
