--Card Oracle
function c249000740.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1ED),3,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c249000740.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c249000740.sprcon)
	e2:SetOperation(c249000740.sprop)
	c:RegisterEffect(e2)
	--discard deck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c249000740.target)
	e3:SetOperation(c249000740.operation)
	c:RegisterEffect(e3)
	--special summon from gy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c249000740.spcon2)
	e4:SetOperation(c249000740.spop2)
	c:RegisterEffect(e4)
end
function c249000740.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c249000740.spfilter(c)
	return c:IsFusionSetCard(0x1ED) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c249000740.spfilter1(c,tp,g)
	return g:IsExists(c249000740.spfilter2,2,c,tp,c)
end
function c249000740.spfilter2(c,tp,mc)
	return Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c249000740.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c249000740.spfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c249000740.spfilter1,1,nil,tp,g)
end
function c249000740.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c249000740.spfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=g:FilterSelect(tp,c249000740.spfilter1,1,1,nil,tp,g)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=g:FilterSelect(tp,c249000740.spfilter2,2,2,mc,tp,mc)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,nil,2,REASON_COST)
end
function c249000740.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function c249000740.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local sg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if sg:GetCount()==0 then return end
	local tc=sg:GetFirst() 
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(95)
			e1:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_FREE_CHAIN)
			e1:SetReset(RESET_EVENT)
			e1:SetHintTiming(0,TIMING_MAIN_END)
			e1:SetCountLimit(1,2490007401)
			e1:SetCondition(c249000740.atkcon)
			e1:SetCost(c249000740.atkcost)
			e1:SetTarget(c249000740.atktg)
			e1:SetOperation(c249000740.atkop)
			Duel.RegisterEffect(e1,tp)
		else
			if not (tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_SPELL+TYPE_QUICKPLAY or tc:GetType()==TYPE_TRAP) then return end
			local te=tc:GetActivateEffect()
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(95)
			if tc:GetType()==TYPE_SPELL then
				e2:SetType(EFFECT_TYPE_IGNITION)
			else
				e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD)
				e2:SetCode(te:GetCode())
			end
			if tc:IsType(TYPE_SPELL) then
				e2:SetCountLimit(1,2490007402)
			else
				e2:SetCountLimit(1,2490007403)
			end
			e2:SetCategory(te:GetCategory())
			e2:SetProperty(te:GetProperty())
			e2:SetReset(RESET_EVENT)
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetCondition(c249000740.accon)
			e2:SetCost(c249000740.accost)
			e2:SetTarget(c249000740.actg)
			e2:SetOperation(c249000740.acop)
			Duel.RegisterEffect(e2,tp)
		end
		tc=sg:GetNext()
	end
	
end
function c249000740.cfilter(c)
	return c:IsSetCard(0x1ED) or c:GetCode()==249000740
end
function c249000740.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000740.cfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c249000740.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:Reset()
	Duel.Hint(HINT_CARD,0,249000740)
end
function c249000740.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c249000740.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c:GetOriginalLevel()*100)
		tc:RegisterEffect(e1)
	end
end
function c249000740.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local te=c:GetActivateEffect()
	local condition=te:GetCondition()
	if not Duel.IsExistingMatchingCard(c249000740.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return (not condition or condition(te,tp,eg,ep,ev,re,r,rp))
end
function c249000740.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	local te=c:GetActivateEffect()
	local costf=te:GetCost()
	if chk==0 and costf then return costf(e,tp,eg,ep,ev,re,r,rp,0) end
	if chk==0 and not costf then return true end
	e:Reset()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	if costf then costf(e,tp,eg,ep,ev,re,r,rp,chk) end 
end
function c249000740.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetOwner()
	local te=c:GetActivateEffect()
	local target=te:GetTarget()
	local tpe=c:GetType()
	if chk==0 then return (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then 
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end				
end
function c249000740.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local te=c:GetActivateEffect()
	local op=te:GetOperation()
	local tpe=c:GetType()
	if op then
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end
		end
	end
end
function c249000740.spfilter3(c,att)
	return c:IsAttribute(att) and c:IsAbleToGraveAsCost()
end
function c249000740.spcon2(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000740.spfilter3,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c249000740.spfilter3,tp,LOCATION_HAND,0,1,nil,ATTRIBUTE_DARK)
end
function c249000740.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c249000740.spfilter3,tp,LOCATION_HAND,0,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c249000740.spfilter3,tp,LOCATION_HAND,0,1,1,nil,ATTRIBUTE_DARK)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end