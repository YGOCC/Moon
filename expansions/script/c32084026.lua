--Orichalcos Stellaverum
function c32084026.initial_effect(c)
	--Negate and Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084013,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c32084026.spcost)
	e1:SetCondition(c32084026.discon)
	e1:SetTarget(c32084026.distg)
	e1:SetOperation(c32084026.disop)
	c:RegisterEffect(e1)
--Immune
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(32084026,1))
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(c32084026.dop)
    c:RegisterEffect(e2)
end
function c32084026.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c32084026.discon(e,tp,eg,ep,ev,re,r,rp)
return rp~=tp and re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c32084026.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
	end
end
function c32084026.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32084026.dop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7D54))
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetValue(c32084026.efilter)
	Duel.RegisterEffect(e1,tp)
end
function c32084026.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end