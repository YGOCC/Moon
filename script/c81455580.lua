--Flare Cosmo'n
function c81455580.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81455580,0))
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c81455580.tg)
	e1:SetOperation(c81455580.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c81455580.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xCF11)
end
function c81455580.schfilter(c)
	return c:IsSetCard(0xCF11) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c81455580.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81455580.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c81455580.ctfilter,tp,LOCATION_MZONE,0,c)
		local sel=0
		if ct>0 and Duel.IsExistingMatchingCard(c81455580.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then sel=sel+1 end
		if Duel.IsExistingMatchingCard(c81455580.schfilter,tp,LOCATION_DECK,0,1,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81455580,0))
		sel=Duel.SelectOption(tp,aux.Stringid(81455580,1),aux.Stringid(81455580,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(81455580,1))
	else
		Duel.SelectOption(tp,aux.Stringid(81455580,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		local g=Duel.GetMatchingGroup(c81455580.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function c81455580.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==1 then
		local ct=Duel.GetMatchingGroupCount(c81455580.ctfilter,tp,LOCATION_MZONE,0,c)
		local g=Duel.GetMatchingGroup(c81455580.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if ct>0 and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=g:Select(tp,1,ct,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c81455580.schfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
