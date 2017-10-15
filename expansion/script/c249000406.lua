--Space the Star Maker
function c249000406.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c249000406.spcon)
	e2:SetOperation(c249000406.spop)
	c:RegisterEffect(e2)
	--s/t
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,249000406)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetTarget(c249000406.target)
	e3:SetOperation(c249000406.operation)
	c:RegisterEffect(e3)
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(612115,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(TIMING_BATTLE_END)
	e4:SetCountLimit(1,249000411)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c249000406.rmcon)
	e4:SetTarget(c249000406.rmtg)
	e4:SetOperation(c249000406.rmop)
	c:RegisterEffect(e4)
end
function c249000406.spfilter(c)
	return c:IsSetCard(0x1BA) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c249000406.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000406.spfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c249000406.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000406.spfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000406.eqfilter(tc,ec)
	return tc:IsFaceup() and ec:CheckEquipTarget(tc)
end
function c249000406.filter(c,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 and not c:IsType(TYPE_FIELD) then return false end
	return c:IsType(TYPE_SPELL) and ((c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(c249000406.eqfilter,tp,LOCATION_MZONE,0,1,nil,c))
	or c:IsType(TYPE_FIELD)
	or c:IsType(TYPE_CONTINUOUS))
end
function c249000406.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000406.filter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c249000406.rmfilter(c,tp)
	return c:IsAbleToRemove() and c:IsFaceup()
end
function c249000406.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c249000406.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		if tc:IsType(TYPE_EQUIP) then
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(48370501,1))
			local g=Duel.SelectMatchingCard(tp,c249000406.eqfilter,tp,LOCATION_MZONE,0,1,1,nil,tc)
			if g:GetCount()>0 then
				Duel.Equip(tp,tc,g:GetFirst())
			end
		elseif tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		else
			if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
	if Duel.IsExistingMatchingCard(c249000406.rmfilter,tp,0,LOCATION_SZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(16037007,1)) then
		local g=Duel.SelectMatchingCard(tp,c249000406.rmfilter,tp,0,LOCATION_SZONE,1,1,nil)
		Duel.Remove(g,0,REASON_EFFECT)
	end
end
function c249000406.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c249000406.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local lvrk=g:GetFirst():GetLevel()
	if lvrk < g:GetFirst():GetRank() then lvrk=g:GetFirst():GetRank() end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lvrk * 100)
end
function c249000406.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if Duel.Remove(tc,0,REASON_EFFECT)~=0 then
		local lvrk=tc:GetLevel()
		if lvrk < tc:GetRank() then lvrk=tc:GetRank() end
		Duel.Recover(tp,lvrk * 100,REASON_EFFECT)
	end
end