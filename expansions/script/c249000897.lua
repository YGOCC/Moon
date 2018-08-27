--Effect-Magician Reaper
function c249000897.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c249000897.poscon)
	e1:SetOperation(c249000897.posop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c249000897.destg)
	e2:SetOperation(c249000897.desop)
	c:RegisterEffect(e2)
end
function c249000897.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c249000897.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c249000897.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c71413901.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c249000897.filter(c)
	return c:IsSetCard(0x2098) and not c:IsCode(249000897)
end
function c249000897.filter2(c)
	return c:IsSetCard(0x2098) and not (c:IsPublic() and c:IsLocation(LOCATION_HAND))
end
function c249000897.desop(e,tp,eg,ep,ev,re,r,rp)
	if (not Duel.IsExistingMatchingCard(c249000897.filter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil))
		and (not Duel.IsExistingMatchingCard(c249000897.filter2,tp,LOCATION_HAND,0,1,nil)) then return end
	if not Duel.IsExistingMatchingCard(c249000897.filter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
		if Duel.IsExistingMatchingCard(c249000897.filter2,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c249000897.filter2,tp,LOCATION_HAND,0,1,1,nil)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		else
			return
		end	
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end