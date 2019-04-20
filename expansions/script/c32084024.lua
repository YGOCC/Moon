--Orichalcos Automaton
function c32084024.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32084024,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c32084024.target)
	e1:SetOperation(c32084024.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
		--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32084024,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCost(c32084024.discost)
	e4:SetTarget(c32084024.thtg)
	e4:SetOperation(c32084024.thop)
	c:RegisterEffect(e4)
	--attack 1st turn
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(32084024,1))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC_G)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c32084024.sccon)
	e6:SetOperation(c32084024.seecost)
	e6:SetValue(SUMMON_TYPE_SPECIAL+1)
	c:RegisterEffect(e6)
end
function c32084024.sccon(e,c)
	if c==nil then return true end
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and Duel.GetTurnCount()==1
end
function c32084024.seecost(e,tp,eg,ep,ev,re,r,rp,c)
	if not Duel.SelectYesNo(tp,aux.Stringid(32084024,1)) then return end
	if Duel.GetTurnCount()==1 then
		Duel.MoveTurnCount()
	end
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	return
end
function c32084024.filter(c,e,tp)
	return c:IsCode(32084024) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32084024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32084024.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c32084024.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32084024.filter,tp,LOCATION_DECK,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c32084024.sfilter(c)
	return c:IsSetCard(0x7D54) or c:IsCode(48179391)
end
function c32084024.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c32084024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32084024.sfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32084024.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32084024.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end