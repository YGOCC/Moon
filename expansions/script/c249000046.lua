--Counter Summoner's Gem
function c249000046.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000046+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c249000046.target)
	e1:SetOperation(c249000046.activate)
	c:RegisterEffect(e1)
end
function c249000046.filter(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x25,1)
end
function c249000046.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c249000046.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000046.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SelectTarget(tp,c249000046.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x25)
end
function c249000046.tfilter(c)
	return c:GetCode()==249000046 and c:IsAbleToHand()
end
function c249000046.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:AddCounter(0x25,2) then
		if Duel.SelectYesNo(tp,aux.Stringid(249000046,0)) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
