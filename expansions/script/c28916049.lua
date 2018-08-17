--Mechadragooon Assault
local ref=_G['c'..28916049]
local id=28916049
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(ref.actcost)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	--Act from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--Equip from GY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(ref.eqcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(ref.eqtg)
	e3:SetOperation(ref.eqop)
	c:RegisterEffect(e3)
end

--Activate
function ref.actcfilter(c)
	return c:IsRace(RACE_MACHINE) and not c:IsPublic()
end
function ref.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not (e:GetHandler():IsLocation(LOCATION_HAND) and not Duel.IsExistingMatchingCard(ref.actcfilter,tp,LOCATION_HAND,0,1,nil)) end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,ref.actcfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end
function ref.tgfilter(c,tp,loc)
	return c:IsFaceup()	and Duel.IsExistingMatchingCard(ref.eqfilter,tp,loc,0,1,nil,c,tp)
end
function ref.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and (c:IsSetCard(1849) or c:IsCode(63851864))
		 and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and ref.tgfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(ref.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,LOCATION_DECK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,ref.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,LOCATION_DECK)
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,ref.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),tc)
		end
	end
end

--Equip from GY
function ref.eqcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc2)
end
function ref.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.eqcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.eqtgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.eqtgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(ref.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,LOCATION_GRAVE)
	end
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=Duel.SelectMatchingCard(tp,ref.eqtgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local tc=Duel.SelectMatchingCard(tp,ref.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,LOCATION_GRAVE):GetFirst()
		if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,ref.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc,tp)
			if g:GetCount()>0 then
				Duel.Equip(tp,g:GetFirst(),tc)
			end
		end
	end
end
