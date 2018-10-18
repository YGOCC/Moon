--Starter
--Design and Code by Kinny
local ref=_G['c'..28916120]
local id=28916120
function ref.initial_effect(c)
	--Mill 2 copies
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(ref.grcost)
	e1:SetTarget(ref.grtg)
	e1:SetOperation(ref.grop)
	c:RegisterEffect(e1)
	--Act in Hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(ref.handcon)
	c:RegisterEffect(e2)
	--Reset
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(ref.settg)
	e3:SetOperation(ref.setop)
	c:RegisterEffect(e3)
end

--Mill 2 copies
function ref.filter2(c)
	return c:IsSetCard(1854) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function ref.grfilter(c)
	local tp=c:GetOwner()
	return c:IsSetCard(1854) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function ref.grcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.filter2,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function ref.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.grop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(ref.grfilter,tp,LOCATION_DECK,0,nil)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local hg=sg:Select(tp,1,1,nil)
	sg:RemoveCard(hg:GetFirst())
	sg=sg:Filter(Card.IsCode,nil,hg:GetFirst():GetCode())
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=sg:Select(tp,1,1,nil)
		hg:Merge(tg)
	end
	Duel.SendtoGrave(hg,REASON_EFFECT)
end

--Hand Act
function ref.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

--Reset
function ref.tdfilter(c,e)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(ref.tdfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,c,e,c:GetCode())
end
function ref.tdfilter2(c,e,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function ref.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and ref.tdfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(ref.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local c1=Duel.SelectMatchingCard(tp,ref.tdfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e):GetFirst()
	local c2=Duel.SelectMatchingCard(tp,ref.tdfilter2,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,c1,e,c1:GetCode()):GetFirst()
	local g=Group.FromCards(c1,c2)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function ref.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
