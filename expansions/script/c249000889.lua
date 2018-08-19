--Cosmic-Summoner's Path
function c249000889.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c249000889.condition)
	e1:SetTarget(c249000889.target)
	e1:SetOperation(c249000889.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c249000889.handcon)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5818294,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c249000889.negcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c249000889.negtg)
	e3:SetOperation(c249000889.negop)
	c:RegisterEffect(e3)
end
function c249000889.condition(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
end
function c249000889.filter(c,e,tp)
	return c:IsSetCard(0x1A8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000889.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000889.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetTargetCard(re:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c249000889.filter2(c)
	return c:IsSetCard(0x1A8) and c:IsType(TYPE_MONSTER)
end
function c249000889.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c249000889.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then return end
	if not Duel.IsExistingMatchingCard(c249000889.filter2,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
		if Duel.IsExistingMatchingCard(c249000889.filter2,tp,LOCATION_HAND,0,1,nil) then
			local g=Duel.SelectMatchingCard(tp,c249000889.filter2,tp,LOCATION_HAND,0,1,1,nil)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleHand(tp)
		else
			return
		end	
	end
	if Duel.NegateEffect(ev) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.SelectMatchingCard(tp,c249000889.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c249000889.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function c249000889.tfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x1A8)
end
function c249000889.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c249000889.tfilter,1,nil,tp) and Duel.IsChainDisablable(ev)
end
function c249000889.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c249000889.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end