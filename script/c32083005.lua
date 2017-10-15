--32083005
function c32083005.initial_effect(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32083005,0))
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c32083005.rmtg)
	e1:SetOperation(c32083005.rmop)
	c:RegisterEffect(e1)
	--immune trap
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c32083005.efilter)
	c:RegisterEffect(e2)
end
function c32083005.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c32083005.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:GetHandler():GetPreviousLocation()~=LOCATION_REMOVED then return end
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c32083005.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32083005.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c32083005.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c32083005.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c32083005.efilter(e,te)
	if e:GetHandler():GetPreviousLocation()~=LOCATION_REMOVED then return end
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end