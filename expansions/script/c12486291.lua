--[]
--[]
function c12486291.initial_effect(c)
	--Activate ()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12486291.target)
	e1:SetOperation(c12486291.activate)
	c:RegisterEffect(e1)
	--To Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12486291,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12486291)
	e2:SetCondition(c12486291.thcon)
	e2:SetTarget(c12486291.tdtg)
	e2:SetOperation(c12486291.tdop)
	c:RegisterEffect(e2)
end
c12486291.fit_monster={36541136}
function c12486291.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPIRIT) 
end
function c12486291.filter(c,e,tp,m1,m2,ft)
	if not c12486291.ritual_filter(c)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return ft>-1 and mg:IsExists(c12486291.mfilterf,1,nil,tp,mg,c)
	end
end
function c12486291.mfilterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c12486291.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_SPIRIT) and c:IsAbleToDeck()
end
function c12486291.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c12486291.mfilter,tp,LOCATION_GRAVE,0,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c12486291.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg1,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12486291.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=Duel.GetMatchingGroup(c12486291.mfilter,tp,LOCATION_GRAVE,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12486291.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg1,mg2,ft)
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c12486291.mfilterf,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		local mat2=mat:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsType,nil,TYPE_SPIRIT)
		mat:Sub(mat2)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
--[]
function c12486291.cfilter(c)
	return c:IsFaceup() and c:IsCode(36541136)
end
function c12486291.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12486291.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12486291.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12486291.sumfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c12486291.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		local tc=Duel.GetOperatedGroup():GetFirst()
		local og=Duel.GetMatchingGroup(c12486291.sumfilter,tp,LOCATION_HAND,0,nil)
		if tc:IsType(TYPE_SPIRIT) and og:GetCount()>0-- Duel.GetMatchingGroup(c12486291.sumfilter,tp,LOCATION_HAND,0,nil) --tc:IsSummonable(true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(12486291,0)) then
		--	Duel.Summon(tp,tc,true,nil)
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,og)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=og:Select(tp,1,1,nil):GetFirst()
			Duel.ShuffleHand(tp)
			Duel.Summon(tp,sg,true,nil)
		end
	end
end

		
		
--		local og=Duel.GetMatchingGroup(c12486291.sumfilter,tp,LOCATION_HAND,0,nil)
--		if og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(39336818,0)) then
--			Duel.BreakEffect()
--			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
--			local sg=og:Select(tp,1,1,nil):GetFirst()
--			Duel.ShuffleHand(tp)
--			Duel.Summon(tp,sg,true,nil)
--		end
--	end
--end

		
--[]
--function c12486291.thfilter2(c)
--	return c:IsFaceup() and c:IsSetCard(0x125) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
--end
--function c12486291.cfilter2(c)
--	return c:IsFaceup() and c:IsCode(36541136)
--end
--function c12486291.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
--	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12486291.thfilter2(chkc,e,tp) end
--	if Duel.IsExistingTarget(c12486291.thfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
--	local ct=(2)
--	if not Duel.IsExistingMatchingCard(c12486291.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then ct=1 end
--	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
--	local g=Duel.SelectTarget(tp,c12486291.thfilter2,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp)
--	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
--end
--function c12486291.thop(e,tp,eg,ep,ev,re,r,rp)
--	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
--	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
--	if sg:GetCount()>0 then
--		Duel.SendtoHand(sg,nil,REASON_EFFECT)
--	end
--end