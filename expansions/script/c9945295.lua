--Elegant Miku, of Virtue
function c9945295.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(9945295)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9945294)
	e1:SetCondition(c9945295.spcon)
	e1:SetOperation(c9945295.spop)
	c:RegisterEffect(e1)
	--Add
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945295,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9945295)
	e2:SetTarget(c9945295.thtg)
	e2:SetOperation(c9945295.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--ToHand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9945295,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,9945296)
	e5:SetCondition(c9945295.thcon2)
	e5:SetTarget(c9945295.thtg2)
	e5:SetOperation(c9945295.thop2)
	c:RegisterEffect(e5)
end
function c9945295.spfilter1(c)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(c9945295.spfilter2,tp,LOCATION_GRAVE,0,1,c,c)
end
function c9945295.spfilter2(c)
	return c:IsSetCard(0x2050) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9945295.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9945295.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c9945295.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c9945295.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9945295.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1,true)
end
function c9945295.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c9945295.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c9945295.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9945295.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c9945295.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9945295.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
		if tg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local tc=tg:Select(tp,1,1,nil)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c9945295.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c9945295.thfilter2(c)
	return c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c9945295.spfilter3(c,e,tp)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9945295.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9945295.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9945295.thfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9945295.thfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9945295.thop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsControler(tp) and tc:IsLocation(LOCATION_HAND) then
			local tg=Duel.GetMatchingGroup(c9945295.spfilter3,tp,LOCATION_DECK,0,nil,e,tp)
			if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(9945295,2)) then
			Duel.BreakEffect()
			Duel.SendtoDeck(tc,2,nil,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=tg:Select(tp,1,1,nil)
			Duel.SpecialSummon(rg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end