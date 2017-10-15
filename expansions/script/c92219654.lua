--Red Moon Order Attack
function c92219654.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c92219654.condition)
	e1:SetTarget(c92219654.target)
	e1:SetOperation(c92219654.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c92219654.reptg)
	e2:SetValue(c92219654.repval)
	e2:SetOperation(c92219654.repop)
	c:RegisterEffect(e2)
end
function c92219654.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x39a) and c:IsDualState()
end
function c92219654.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_DUAL)
end
function c92219654.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c92219654.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c92219654.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c92219654.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	Duel.Destroy(tc,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c92219654.desfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=g:Select(tp,1,1,nil)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
function c92219654.repfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_DUAL) and c:IsLocation(LOCATION_MZONE+LOCATION_SZONE+LOCATION_FZONE+LOCATION_PZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c92219654.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c92219654.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(92219654,0))
end
function c92219654.repval(e,c)
	return c92219654.repfilter(c,e:GetHandlerPlayer())
end
function c92219654.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end