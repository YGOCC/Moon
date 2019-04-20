--Orichalcos Apparatus
function c32084013.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084013,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c32084013.discon)
	e1:SetTarget(c32084013.distg)
	e1:SetOperation(c32084013.disop)
	c:RegisterEffect(e1)
end
function c32084013.spfilter(c,e,tp)
	return c:IsCode(32084013) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32084013.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():IsAttackPos() and ep~=tp
end
function c32084013.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if ep==tp then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c32084013.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	if Duel.NegateActivation(ev) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c32084013.spfilter),tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(32084013,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
end