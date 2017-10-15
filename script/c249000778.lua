--Change Ration
function c249000778.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249000778)
	e1:SetCondition(c249000778.condition)
	e1:SetCost(c249000778.cost)
	e1:SetTarget(c249000778.target)
	e1:SetOperation(c249000778.activate)
	c:RegisterEffect(e1)
end
function c249000778.confilter(c)
	return c:IsSetCard(0x155) and c:IsType(TYPE_MONSTER)
end
function c249000778.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000778.confilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c249000778.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(249000778,tp,ACTIVITY_SPSUMMON)==0 end
end
function c249000778.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c249000778.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	local c=e:GetHandler()
	local dg=Duel.GetOperatedGroup()
	Duel.ConfirmCards(1-tp,dg)
	local tc=dg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_SSET)
		c:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_SUMMON)
		c:RegisterEffect(e4)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		c:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_MSET)
		c:RegisterEffect(e5)		
		tc=dg:GetNext()
	end
end
