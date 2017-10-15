--Digimon Angel's wrath: Seven Heaven
function c47000110.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47000110)
	e1:SetCondition(c47000110.condition)
	e1:SetTarget(c47000110.target)
	e1:SetOperation(c47000110.activate)
	c:RegisterEffect(e1)
end
function c47000110.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3FB) and (c:IsType(TYPE_XYZ) or c:IsLevelAbove(6))
end
function c47000110.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47000110.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47000110.filter(c)
	return c:IsDestructable()
end
function c47000110.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47000110.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47000110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c47000110.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if g:GetFirst():IsFaceup() then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	end
end
function c47000110.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:IsFaceup() and tc:GetAttack() or 0
		if Duel.Destroy(tc,REASON_EFFECT)>0 and atk~=0 then
			Duel.Recover(tp,atk/2,REASON_EFFECT)
		end
	end
end
