 --Created and coded by Rising Phoenix
function c100000887.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x210F),4,2)
	c:EnableReviveLimit()
	--remove field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1)
	e1:SetDescription(aux.Stringid(100000887,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100000887.cost)
	e1:SetTarget(c100000887.targetf)
	e1:SetOperation(c100000887.operationf)
	c:RegisterEffect(e1)
end
function c100000887.targetf(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(c100000887.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c100000887.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c100000887.filter3(c)
	return c:IsAbleToGrave()
end
function c100000887.operationf(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000887.filter3,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then end
		Duel.HintSelection(g)
	Duel.SendtoGrave(g,REASON_EFFECT)
end

function c100000887.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end