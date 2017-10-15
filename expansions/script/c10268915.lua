--Paladins' Art: Devotion Aura
function c10268915.initial_effect(c)
	--destroy rep
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10268915.addct)
	e1:SetOperation(c10268915.addc)
	c:RegisterEffect(e1)
end
function c10268915.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x19121)
end
function c10268915.addct(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10268915.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10268915.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SelectTarget(tp,c10268915.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c10268915.addc(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x94c,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetTarget(c10268915.reptg)
		e1:SetOperation(c10268915.repop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
function c10268915.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return bit.band(r,REASON_RULE)==0
		and e:GetHandler():GetCounter(0x94c)>0 end
	return true
end
function c10268915.repop(e,tp,eg,ep,ev,re,r,rp,chk)
	e:GetHandler():RemoveCounter(tp,0x94c,1,REASON_EFFECT)
end