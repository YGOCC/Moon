--Stone Giant
function c11000646.initial_effect(c)
	--to defence
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11000646,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c11000646.potg)
	e2:SetOperation(c11000646.poop)
	c:RegisterEffect(e2)
end
function c11000646.filter2(c)
	return c:IsSetCard(0x209) and c:IsAbleToHand()
end
function c11000646.potg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000646.filter,tp,LOCATION_DECK,0,1,nil)
	and e:GetHandler():IsAttackPos() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11000646.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPosition(POS_FACEUP_ATTACK) and c:IsRelateToEffect(e) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
		local mg=Duel.GetMatchingGroup(c11000646.filter2,tp,LOCATION_DECK,0,nil)
		if mg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)		
		end
	end
end
