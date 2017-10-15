--The Goghi's Breakthrough
function c160004532.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c160004532.cost)
	e1:SetTarget(c160004532.target)
	e1:SetOperation(c160004532.activate)
	c:RegisterEffect(e1)
end
function c160004532.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c160004532.costfilter(c)
	return c:IsSetCard(0xc50) and (c:GetSequence()==6 or c:GetSequence()==7) and c:IsDestructable()
end
function c160004532.cost(e,tp,eg,ep,ev,re,r,rp,chk)

		local rg=Duel.GetMatchingGroup(c160004532.costfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	if chk==0 then return   rg:GetClassCount(Card.GetCode)>=2 end
	local g=Group.CreateGroup()
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc=rg:Select(tp,1,1,nil):GetFirst()
		rg:Remove(Card.IsCode,nil,tc:GetCode())
			g:AddCard(tc)
			end
	Duel.Destroy(g,nil,REASON_COST)
end
function c160004532.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c160004532.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c160004532.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c160004532.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c160004532.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	end
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c160004532.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end

function c160004532.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xc50)
end