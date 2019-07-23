--Cosmic Wing Recovery by TKNight

function c915.initial_effect(c) 
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c915.eqcon)
	e1:SetTarget(c915.eqtg)
	e1:SetOperation(c915.eqop)
	c:RegisterEffect(e1)

end
function c915.cfilter(c)
	return c:GetSequence()>=5
end
function c915.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c915.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c915.tgfilter(c)
	return c:IsSetCard(0xB3F) and c:IsType(TYPE_MONSTER)and c:IsFaceup() 
end
	
function c915.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsControler(tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c915.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c915.filter(c)
	return c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c915.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c915.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local eqc=g:GetFirst()
		if not eqc or not Duel.Equip(tp,eqc,tc,true) then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c915.eqlimit)
		e1:SetLabelObject(tc)
		eqc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(eqc)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_SET_CONTROL)
		e2:SetValue(tp)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		eqc:RegisterEffect(e2)
	end
end
function c915.eqlimit(e,c)
	return e:GetLabelObject()==c
end
