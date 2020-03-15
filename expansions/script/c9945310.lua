--Graceful Hiriya, of Virtue
function c9945310.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(9945310)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9945310)
	e1:SetCondition(c9945310.spcon)
	e1:SetOperation(c9945310.spop)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945310,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCondition(c9945310.rmcon)
	e2:SetTarget(c9945310.rmtg)
	e2:SetOperation(c9945310.rmop)
	c:RegisterEffect(e2)
	--Banished to Target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9945310,1))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9945310.condition)
	e3:SetTarget(c9945310.target)
	e3:SetOperation(c9945310.operation)
	c:RegisterEffect(e3)
end
function c9945310.spfilter1(c)
	return c:IsSetCard(0x204F) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(c9945310.spfilter2,tp,LOCATION_GRAVE,0,1,c,c)
end
function c9945310.spfilter2(c)
	return c:IsSetCard(0x2050) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9945310.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9945310.spfilter1,tp,LOCATION_GRAVE,0,1,nil)
end
function c9945310.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c9945310.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c9945310.spfilter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),g1:GetFirst())
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
function c9945310.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c9945310.rmfilter(c)
	return c:IsSetCard(0x204F) and c:IsAbleToRemove()
end
function c9945310.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9945310.rmfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9945310.rmfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c9945310.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c9945310.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c9945310.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsSetCard(0x204F)
end
function c9945310.negfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
function c9945310.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9945310.filter,1,nil)
end
function c9945310.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c9945310.negfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c9945310.negfilter,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,9945310)<2 end
    local ct=eg:FilterCount(c9945310.filter,nil)
    if ct>2 then ct=2 end
    if 2-Duel.GetFlagEffect(tp,9945310)<ct then ct=2-Duel.GetFlagEffect(tp,9945310) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectTarget(tp,c9945310.negfilter,tp,0,LOCATION_ONFIELD,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
    local reg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):GetCount()
    for i=1,reg do
        Duel.RegisterFlagEffect(tp,9945310,RESET_PHASE+PHASE_END,0,1)
    end
end
function c9945310.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e3)
			end
		end
		tc=g:GetNext()
	end
end
