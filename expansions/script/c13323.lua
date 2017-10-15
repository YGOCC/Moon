--Voidol Open Mic
function c13323.initial_effect(c)
	--Shuffle+Add
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13323+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c13323.target)
	e1:SetOperation(c13323.activate)
	c:RegisterEffect(e1)
	--synchro effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c13323.sccon)
	e2:SetCost(c13323.sccost)
	e2:SetTarget(c13323.sctg)
	e2:SetOperation(c13323.scop)
	c:RegisterEffect(e2)
end
function c13323.tgfilter(c,tp)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToExtra() and c:IsSetCard(0x5DD) and c:IsType(TYPE_PENDULUM)
			and Duel.IsExistingMatchingCard(c13323.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c13323.thfilter(c,code)
	return not c:IsCode(code) and c:IsAbleToHand() and c:IsSetCard(0x5DD) and c:IsType(TYPE_PENDULUM)
end
function c13323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToExtra() and chkc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD) and c13323.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c13323.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c13323.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c13323.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c13323.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c13323.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetTurnPlayer()~=tp
		and (ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2)
end
function c13323.mfilter(c)
	return c:IsSetCard(0x5DD) and c:IsType(TYPE_MONSTER)
end
function c13323.mfilter2(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c13323.cfilter(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c13323.mfilter,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c)
end
function c13323.spfilter(c,mg)
	return mg:IsExists(c13323.cfilter,1,nil,c)
end
function c13323.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c13323.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c13323.mfilter,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c13323.mfilter2,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c13323.spfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c13323.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c13323.mfilter,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c13323.mfilter2,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c13323.spfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c13323.cfilter,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end


