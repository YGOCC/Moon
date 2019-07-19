--Power Portrait Animating
function c160007452.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c160007452.target)
	e1:SetOperation(c160007452.activate)
	c:RegisterEffect(e1)
end
function c160007452.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EVOLUTE)
end
function c160007452.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c160007452.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c160007452.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c160007452.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c160007452.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup()  and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EVOLUTE_LEVEL)
		e1:SetValue(c160007452.xyzlv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)

	end
end
function c160007452.xyzlv(e,c,rc)
	return c:GetStage()
end