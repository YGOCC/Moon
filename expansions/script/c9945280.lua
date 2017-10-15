--Gavreel, of Virtue
function c9945280.initial_effect(c)
	--ToDeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9945280,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,9945280)
	e1:SetTarget(c9945280.tgtg)
	e1:SetOperation(c9945280.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--ToGrave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9945280,1))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,9945280)
	e4:SetTarget(c9945280.sdtg)
	e4:SetOperation(c9945280.sdop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c9945280.tgfilter(c)
	return c:IsSetCard(0x204F) and c:IsAbleToDeck() and c:IsFaceup()
end
function c9945280.cfilter(c)
	return c:IsFaceup() and c:IsCode(9945225)
end
function c9945280.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945280.tgfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_REMOVED)
end
function c9945280.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9945280.tgfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,2,2,nil)
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)==2 and fc and c9945280.cfilter(fc)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9945280,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
end
function c9945280.sdfilter(c)
	return c:IsSetCard(0x204F) and c:IsAbleToGrave()
end
function c9945280.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945280.sdfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c9945280.sdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9945280.sdfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,2,2,nil)
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if Duel.SendtoGrave(sg,REASON_EFFECT)==2 and fc and c9945280.cfilter(fc)
		and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(9945280,2)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
end