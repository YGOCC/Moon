--Overdrive
function c20386022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c20386022.target)
	e1:SetOperation(c20386022.activate)
	c:RegisterEffect(e1)
end
function c20386022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x31C55) or c:IsSetCard(0x4FA2) or c:IsSetCard(0x31C56)
end
function c20386022.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20386022.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20386022.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c20386022.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20386022.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x94b,3)
	end
end