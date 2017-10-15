--Pikachu
function c32387003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c32387003.discon)
	e1:SetCost(c32387003.cost)
	e1:SetTarget(c32387003.distg)
	e1:SetOperation(c32387003.disop)
	c:RegisterEffect(e1)
		--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(32387003,0))
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCost(c32387003.cost)
	e2:SetOperation(c32387003.operation)
	c:RegisterEffect(e2)
		--evolve
		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32387003,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c32387003.spcon)
	e3:SetCost(c32387003.spcost)
	e3:SetTarget(c32387003.sptg)
	e3:SetOperation(c32387003.spop)
	c:RegisterEffect(e3)
end
function c32387003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,32387003)==0 end
	Duel.RegisterFlagEffect(tp,32387003,RESET_PHASE+PHASE_END,0,1)
end
function c32387003.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg:IsContains(c) then return false end
	if (not Duel.IsChainNegatable(ev)) or loc==LOCATION_DECK then return false end
	return true
end
function c32387003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c32387003.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end
function c32387003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
c32387003.lvupcount=1
c32387003.lvup={32387004}
function c32387003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and not e:GetHandler():IsStatus(STATUS_SUMMON_TURN)
end
function c32387003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c32387003.spfilter(c,e,tp)
	return c:IsCode(32387004) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c32387003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c32387003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c32387003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32387003.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end