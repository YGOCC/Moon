--Zodiakieri Constellation
function c9945550.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,9945550+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c9945550.target)
	e2:SetOperation(c9945550.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
	--Set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9945550,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c9945550.settg)
	e4:SetCountLimit(1,9945551)
	e4:SetOperation(c9945550.setop)
	c:RegisterEffect(e4)
end
function c9945550.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not (c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY))
end

function c9945550.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		ng:AddCard(tc)
		if tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,ng:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c9945550.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if Duel.NegateActivation(i) and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end


function c9945550.setfilter(c)
	return c:IsSetCard(0x12D7) and not c:IsCode(9945550) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9945550.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9945550.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9945550.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c9945550.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
