--Extra-Esper Call
function c249000773.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c249000773.target)
	e1:SetOperation(c249000773.activate)
	c:RegisterEffect(e1)
	--level increase
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c249000773.lvcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c249000773.lvtg)
	e2:SetOperation(c249000773.lvop)
	c:RegisterEffect(e2)
end
function c249000773.filter(c)
	return c:IsSetCard(0x1F0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c249000773.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000773.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c249000773.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c249000773.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c249000773.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000773.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c249000773.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c249000773.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c249000773.lvfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000773.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c249000773.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc1=g:GetFirst()
	local op=0
	if tc1:GetLevel()==1 then op=Duel.SelectOption(tp,aux.Stringid(63485233,0))
	else op=Duel.SelectOption(tp,aux.Stringid(63485233,0),aux.Stringid(63485233,1)) end
	e:SetLabel(op)
end
function c249000773.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		if e:GetLabel()==0 then
			e1:SetValue(1)
			else
			e1:SetValue(-1)
		end
		tc:RegisterEffect(e1)
	end
end