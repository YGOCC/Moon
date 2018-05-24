--Mysterious Space Dragon
function c53313925.initial_effect(c)
	c:EnableReviveLimit()
	--Materials: 2+ level 8 monsters
	aux.AddXyzProcedure(c,nil,8,2,nil,nil,99)
	--When this card is Summoned: Destroy all non-Pandemonium monsters on the field.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c53313925.destg)
	e1:SetOperation(c53313925.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--When an effect is activated (Quick Effect): You can detach 1 Xyz Material from this card; negate the activation and banish it, then you can add 1 "Rank-Up Magic" card from your Deck or GY to your Hand.
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) end)
	e3:SetCost(c53313925.cost)
	e3:SetTarget(c53313925.target)
	e3:SetOperation(c53313925.activate)
	c:RegisterEffect(e3)
end
function c53313925.dfilter(c)
	return c:GetType()&TYPE_PANDEMONIUM~=TYPE_PANDEMONIUM or c:IsLocation(LOCATION_SZONE)
end
function c53313925.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c53313925.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c53313925.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53313925.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c53313925.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c53313925.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c53313925.filter(c)
	return c:IsSetCard(0x95) and c:IsAbleToHand()
end
function c53313925.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re)
		and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 and rc:IsLocation(LOCATION_REMOVED) then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c53313925.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,1109) then
			local tc=g:Select(tp,1,1,nil)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
