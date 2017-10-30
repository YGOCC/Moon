--M
function c101600101.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600101,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c101600101.target1)
	e1:SetOperation(c101600101.activate1)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101600101,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101600101.target2)
	e2:SetOperation(c101600101.activate2)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--Search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101600101,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c101600101.thcost)
	e3:SetTarget(c101600101.thtg)
	e3:SetOperation(c101600101.thop)
	c:RegisterEffect(e3)
end
function c101600101.filter1(c,e,tp,code)
	local lv=c:GetLevel()
	if code then return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) else
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsSetCard(0xcd01)
		and Duel.IsExistingMatchingCard(c101600101.filter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
	end
end
function c101600101.filter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c101600101.filter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and c:IsSetCard(0xcd01)
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,1)
end
function c101600101.filter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and c:IsSetCard(0xcd01)
end
function c101600101.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,101600102)<1 and Duel.GetFlagEffect(tp,101600101)<1
		and Duel.IsExistingMatchingCard(c101600101.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c101600101.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		e:SetLabel(tc:GetCode())
		e:SetLabelObject(tc)
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c101600101.filter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c101600101.filter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,1)
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,101600100,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101600101.activate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if not tc then return end
	if (tc and not tc:IsLocation(LOCATION_EXTRA)) and Duel.IsExistingMatchingCard(c101600101.sfilter1,tp,LOCATION_EXTRA,0,1,tc,e,tp,e:GetLabel()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c101600101.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	end
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
end
function c101600101.sfilter1(c,e,tp,code)
	local lv=c:GetLevel()
	if code then return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) else
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and c:IsSetCard(0xcd01)
		and Duel.IsExistingMatchingCard(c101600101.sfilter2,tp,LOCATION_REMOVED,0,1,nil,tp,lv)
	end
end
function c101600101.sfilter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(c101600101.sfilter3,tp,LOCATION_REMOVED,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToDeck() and c:IsSetCard(0xcd01)
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,1)
end
function c101600101.sfilter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove() and c:IsSetCard(0xcd01)
end
function c101600101.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,101600100)<1 and Duel.GetFlagEffect(tp,101600103)<1
		and Duel.IsExistingMatchingCard(c101600101.sfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,c101600101.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		e:SetLabel(tc:GetCode())
		e:SetLabelObject(tc)
		local lv=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,c101600101.sfilter2,tp,LOCATION_REMOVED,0,1,1,nil,tp,lv)
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(c101600101.sfilter3,tp,LOCATION_REMOVED,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,1)
		g2:Merge(g3)
		Duel.SetTargetCard(g2)
	end
	Duel.RegisterFlagEffect(tp,101600101,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101600101.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount() then return end
	local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	if ct<=0 then return end
	if not tc then return end
	if (tc and not tc:IsLocation(LOCATION_EXTRA)) and Duel.IsExistingMatchingCard(c101600101.sfilter1,tp,LOCATION_EXTRA,0,1,tc,e,tp,e:GetLabel()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,c101600101.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel())
	end
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
end
function c101600101.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c101600101.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and c:IsSetCard(0xcd01) and not c:IsCode(101600101)
end
function c101600101.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101600101.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetFlagEffect(tp,101600100)<1 and Duel.GetFlagEffect(tp,101600101)<1 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.RegisterFlagEffect(tp,101600102,RESET_PHASE+PHASE_END,0,1)
end
function c101600101.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101600101.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
