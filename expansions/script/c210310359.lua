--A Cloud's Rain Bow
function c210310359.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c210310359.cost)
	e1:SetTarget(c210310359.target)
	e1:SetOperation(c210310359.activate)
	c:RegisterEffect(e1)
	--GYdraw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210310359,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCost(c210310359.cost1)
	e2:SetTarget(c210310359.tg)
	e2:SetOperation(c210310359.op)
	c:RegisterEffect(e2)
end
function c210310359.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	g:GetFirst():AddCounter(0x1019,1)
end
function c210310359.filter(c)
	return c:IsFaceup()
end
function c210310359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210310359.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c210310359.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local attribute=0
	while tc do
		attribute=bit.bor(attribute,tc:GetAttribute())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local arc=Duel.AnnounceAttribute(tp,1,attribute)
	e:SetLabel(arc)
	local dg=g:Filter(Card.IsAttribute,nil,arc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c210310359.filter2(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c210310359.activate(e,tp,eg,ep,ev,re,r,rp)
	local arc=e:GetLabel()
	local g=Duel.GetMatchingGroup(c210310359.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,arc)
	local tc=g:GetFirst()
	while tc do
		--attribute to WATER
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(ATTRIBUTE_WATER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
--GYdraw
function c210310359.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function c210310359.filter3(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c210310359.filterz(c)
	return c:GetCounter(0)~=0
end
function c210310359.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c210310359.filterz,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(c210310359.filter3,tp,1,LOCATION_MZONE,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c210310359.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

