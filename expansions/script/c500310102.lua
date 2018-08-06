--Sweetiehard Evasion
function c500310102.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c500310102.target)
	e1:SetOperation(c500310102.operation)
	c:RegisterEffect(e1)
end
function c500310102.filter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xa34)
end
function c500310102.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c500310102.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c500310102.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c500310102.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c500310102.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 and tc:IsLocation(LOCATION_REMOVED) then
			tc:RegisterFlagEffect(500310102,RESET_EVENT+0x1fe0000,0,1)
			--bring back
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_IGNITION)
			e2:SetCost(aux.bfgcost)
			e2:SetRange(LOCATION_GRAVE)
			e2:SetCondition(c500310102.retcon)
			e2:SetOperation(c500310102.retop)
			e2:SetLabelObject(tc)
			c:RegisterEffect(e2)
		end
	end
end
function c500310102.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and tc:GetFlagEffect(500310102)>0
end
function c500310102.retop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
