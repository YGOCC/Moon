--Lich Knight Frampt
function c9984726.initial_effect(c)
	--spsummon + cannot be material
	aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9984726,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCost(c9984726.cost)
	e1:SetTarget(c9984726.target)
	e1:SetOperation(c9984726.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e2)
end
function c9984726.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9984726)==0 end
	Duel.RegisterFlagEffect(tp,9984726,RESET_PHASE+PHASE_END,0,1)
end
function c9984726.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9984726.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end