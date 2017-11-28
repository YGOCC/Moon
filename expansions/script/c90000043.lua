--Royal Raid Lieutenant
function c90000043.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,2)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c90000043.condition1)
	e1:SetTarget(c90000043.target1)
	e1:SetOperation(c90000043.operation1)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c90000043.condition2)
	e2:SetTarget(c90000043.target2)
	e2:SetOperation(c90000043.operation2)
	c:RegisterEffect(e2)
	--Spell Card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetCondition(c90000043.condition3)
	c:RegisterEffect(e3)
	--Trap Card
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	--Effect Count
	local e5=e3:Clone()
	e5:SetCode(90000043)
	c:RegisterEffect(e5)
	--Activate In Hand
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetCost(c90000043.cost6)
	e6:SetTarget(c90000043.target6)
	e6:SetOperation(c90000043.operation6)
	c:RegisterEffect(e6)
end
function c90000043.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c90000043.filter1_1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c90000043.filter1_2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetRank())
end
function c90000043.filter1_2(c,e,tp,rk)
	return c:GetRank()==rk+2 and c:IsSetCard(0x1c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c90000043.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c90000043.filter1_1,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c90000043.filter1_1,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90000043.operation1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c90000043.filter1_2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetRank())
		local sc=g:GetFirst()
		if sc then
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
			if c:IsRelateToEffect(e) then
				local mg=c:GetOverlayGroup()
				if mg:GetCount()>0 then
					Duel.SendtoGrave(mg,REASON_RULE)
				end
				Duel.Overlay(sc,Group.FromCards(c))
			end
		end
	end
end
function c90000043.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c90000043.filter2(c,e,tp,rk)
	return c:GetRank()==rk+2 and c:IsSetCard(0x1c) and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c90000043.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c90000043.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler():GetRank()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90000043.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90000043.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c:GetRank())
	local sc=g:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c90000043.tg1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c90000043.tg1(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c90000043.condition3(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and e:GetHandler():GetOverlayCount()~=0
end
function c90000043.cost6(e,te_or_c,tp)
	return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function c90000043.target6(e,te,tp)
	local tc=te:GetHandler()
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer() and tc:IsLocation(LOCATION_HAND) and tc:GetEffectCount(90000043)>0
		and ((tc:GetEffectCount(EFFECT_QP_ACT_IN_NTPHAND)<=tc:GetEffectCount(90000043) and tc:IsType(TYPE_QUICKPLAY))
			or (tc:GetEffectCount(EFFECT_TRAP_ACT_IN_HAND)<=tc:GetEffectCount(90000043) and tc:IsType(TYPE_TRAP)))
end
function c90000043.operation6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,90000043)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end