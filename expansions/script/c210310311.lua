--Life in the Cloudians
local card = c210310311
function card.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(card.ctcon)
	e2:SetTarget(card.cttg)
	e2:SetOperation(card.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
		local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
		--Counter 2
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetRange(LOCATION_SZONE)
    e5:SetCode(EVENT_REMOVE_COUNTER+0x1019)
	e5:SetTarget(card.cttg1)
    e5:SetOperation(card.ctop1)
    c:RegisterEffect(e5)
end
function card.filter(c)
	return not c:IsReason(REASON_RULE)
end
function card.ctfilter(c,tp)
	return c:IsFaceup()
end
function card.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(card.ctfilter,1,nil,tp)
end
function card.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ec=eg:FilterCount(card.ctfilter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,ec,0,0x1019)
end
function card.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(card.ctfilter,nil,tp)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1019,1)
		tc=g:GetNext()
	end
end
--Counter 2
function card.cttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function card.ctop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(4005,0))
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tc:AddCounter(0x1019,1)
	end
	