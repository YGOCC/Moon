--Digimon Aquan Ice Arrow
function c47000152.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000152,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetTarget(c47000152.target)
	e1:SetOperation(c47000152.activate)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetCondition(c47000152.actcon)
	c:RegisterEffect(e2)
end
function c47000152.filter(c)
	return c:IsSetCard(0x2FBA) and c:IsType(TYPE_MONSTER) and c:IsSSetable(true)
end
function c47000152.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c47000152.desfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence()<5
end
function c47000152.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c47000152.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then
		if not Duel.IsExistingMatchingCard(c47000152.filter,tp,LOCATION_DECK,0,1,nil) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:GetHandler():IsLocation(LOCATION_HAND) then ft=ft-1 end
		if ft<0 then return false
		elseif ft>0 then
			return Duel.IsExistingTarget(c47000152.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
		else
			return Duel.IsExistingTarget(c47000152.desfilter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		end
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	if ft>0 then
		g=Duel.SelectTarget(tp,c47000152.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	else
		g=Duel.SelectTarget(tp,c47000152.desfilter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47000152.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c47000152.filter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c47000152.filter2(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(4) and c:IsRace(RACE_SEASERPENT)
end
function c47000152.actcon(e)
	return Duel.IsExistingMatchingCard(c47000152.filter2,tp,LOCATION_MZONE,0,1,nil)
end
