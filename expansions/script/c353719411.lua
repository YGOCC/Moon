function c353719411.initial_effect(c)
	c:SetUniqueOnField(1,0,353719411)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c353719411.cost)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(17626381,0))
    e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_SUMMON_NEGATED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c353719411.drtg)
	e1:SetCondition(c353719411.condition1)
	e1:SetOperation(c353719411.drop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_NEGATED)
	c:RegisterEffect(e4)
	local e3=e1:Clone()
	e3:SetCode(EVENT_CUSTOM+353719411)
	c:RegisterEffect(e3)
	if not c353719411.global_check then
		c353719411.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(c353719411.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c353719411.spfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function c353719411.cost(e,tp,eg,ep,ev,re,r,rp,chk) 
  	if chk==0 then return true end 
  	if Duel.IsExistingMatchingCard(c353719411.spfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79400597,0)) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c353719411.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
end
function c353719411.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c353719411.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c353719411.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
