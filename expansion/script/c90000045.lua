--Royal Raid Helicopter
function c90000045.initial_effect(c)
	--Level Change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c90000045.target)
	e1:SetOperation(c90000045.operation)
	c:RegisterEffect(e1)
end
function c90000045.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1c) and c:IsLevelAbove(1)
end
function c90000045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000045.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c90000045.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c90000045.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(c90000045.filter,tp,LOCATION_MZONE,0,tc)
		local lv=g:GetFirst()
		while lv~=nil do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel())
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			lv:RegisterEffect(e1)
			lv=g:GetNext()
		end
	end
end