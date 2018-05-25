--Zextral Armageddon Sorcerer
function c39615023.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--P: You can only Pandemonium Summon "Zextra, The Pandemonium Dragon King". This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTarget(c39615023.splimit)
	c:RegisterEffect(e1)
	--P: Once per turn, when your opponent activates a card or effect that targets and/or would destroy a Pandemonium Monster(s) you control: You can shuffle 1 face-up Pandemonium Monster from your Extra Deck into the Deck; negate that card or effect, and destroy it.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetCost(c39615023.discost)
	e2:SetTarget(c39615023.distg)
	e2:SetOperation(c39615023.disop)
	c:RegisterEffect(e2)
	aux.EnablePandemoniumAttribute(c,e2)
	--M: If a card(s) you control is destroyed by battle or card effect: You can Special Summon this card from your hand, then you can Set 1 Pandemonium Monster directly from your Extra Deck in your Spell/Trap Zone. (HOPT1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,39615023)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCondition(c39615023.spcon)
	e3:SetTarget(c39615023.sptg)
	e3:SetOperation(c39615023.spop)
	c:RegisterEffect(e3)
	--M: You can banish this card you control, plus 4 Pandemonium Monsters from your hand, field, and/or GY with different names; Special Summon 1 "Zextra, The Pandemonium Dragon King" from your hand, Deck, or face-up in your Extra Deck. (HOPT2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,39615024)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCost(c39615023.cost)
	e4:SetTarget(c39615023.target)
	e4:SetOperation(c39615023.operation)
	c:RegisterEffect(e4)
end
function c39615023.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:GetCode()~=39605510 then return false end
	return bit.band(sumtype,SUMMON_TYPE_SPECIAL+726)==SUMMON_TYPE_SPECIAL+726
end
function c39615023.confilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM
end
function c39615023.dcfilter(c)
	return c:IsFaceup() and c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsAbleToDeckAsCost()
end
function c39615023.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c39615023.dcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c39615023.dcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c39615023.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if not re then
		ev=Duel.GetCurrentChain()-1
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		eg=re:GetHandler()
	end
	if chk==0 then
		if re:GetHandler():IsStatus(STATUS_DISABLED) or not Duel.IsChainNegatable(ev) then return false end
		if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
			if tg and tg:IsExists(c39615023.confilter,1,nil,tp) then return true end
		end
		if re:IsHasCategory(CATEGORY_NEGATE) and ev>1
			and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
		local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
		return ex and tg~=nil and tc+tg:FilterCount(c39615023.confilter,nil,tp)-tg:GetCount()>0
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c39615023.disop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not re then
		ev=math.max(Duel.GetCurrentChain()-1,1)
		re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		eg=re:GetHandler()
	end
	if not re:GetHandler():IsStatus(STATUS_DISABLED) and Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c39615023.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c39615023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c39615023.spcfilter,1,nil,tp)
end
function c39615023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c39615023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(aux.PaCheckFilter,tp,LOCATION_EXTRA,0,nil)
		if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SSET)
			and Duel.SelectYesNo(tp,1159) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sg=g:Select(tp,1,1,nil)
			aux.PandSSet(sg,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c39615023.cfilter(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c39615023.hnfilter(c,e,tp,g)
	local sg=Group.CreateGroup()
	return c:IsCode(39605510) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_EXTRA) or c:IsFaceup()) and (not g or g:IsExists(c39615023.check,1,c,tp,g,c,sg,0))
end
function c39615023.check(c,tp,mg,sg,sc,ct)
	sg:AddCard(c)
	ct=ct+1
	local res=c39615023.goal(tp,sg,sc,ct)
		or (ct<5 and mg:IsExists(c39615023.check,1,sg,tp,mg,sg,sc,ct))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c39615023.goal(tp,sg,sc,ct)
	return ct>=5 and sg:GetClassCount(Card.GetCode)>=5 and (sc:IsLocation(LOCATION_EXTRA)
		and Duel.GetLocationCountFromEx(tp,tp,sg)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>-sg:FilterCount(Card.IsLocation,nil,LOCATION_MZONE))
end
function c39615023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c39615023.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,c)
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c39615023.hnfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg) end
	local sc=Duel.SelectMatchingCard(tp,c39615023.hnfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst()
	local sg=Group.FromCards(c,sc)
	local ct=0
	while sg:GetCount()<5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=mg:FilterSelect(tp,c39615023.check,1,1,sg,tp,mg,sg,sc,ct)
		sg:Merge(g)
		mg:Remove(Card.IsCode,nil,g:GetFirst():GetCode())
		ct=ct+1
	end
	sg:RemoveCard(sc)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c39615023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA)
end
function c39615023.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c39615023.hnfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
