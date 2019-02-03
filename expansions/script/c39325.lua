function c39325.initial_effect(c)
	aux.AddFusionProcCode2(c,39321,c39325.ffil,1,true,false)
	c:EnableReviveLimit()
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5128859,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,39325)
	e3:SetTarget(c39325.destg)
	e3:SetOperation(c39325.desop)
	c:RegisterEffect(e3)
end
function c39325.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_HAND)
end
function c39325.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local sg=g:RandomSelect(tp,1)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c39325.ffil(c)
	return c:GetCode()>39300 and c:GetCode()<39326 and not c:IsCode(39311,39312)
end