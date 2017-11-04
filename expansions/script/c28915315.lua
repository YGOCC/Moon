--Strength
--Design and Code by Kindrindra--
local ref=_G['c'..28915315]
function ref.initial_effect(c)
	--Search
	
	--Field wipe
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(aux.exccon)
	e4:SetCost(ref.descost)
	e4:SetTarget(ref.destg)
	e4:SetOperation(ref.desop)
	c:RegisterEffect(e4)
end


function ref.descfilter(c)
	return c:IsSetCard(0x72D) and c:IsAbleToDeckAsCost()
end
function ref.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(ref.descfilter,tp,LOCATION_GRAVE,0,3,c)
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,ref.descfilter,tp,LOCATION_GRAVE,0,3,3,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end