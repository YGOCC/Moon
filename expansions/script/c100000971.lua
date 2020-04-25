 --Created and coded by Rising Phoenix
function c100000971.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100000971,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e1:SetTarget(c100000971.thtg)
	e1:SetOperation(c100000971.thop)
	c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100000971,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c100000971.target)
	e2:SetOperation(c100000971.operation)
	c:RegisterEffect(e2)	
		--swap
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetDescription(aux.Stringid(100000971,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetCountLimit(1)
	e3:SetCondition(c100000971.conditionsw)
	e3:SetTarget(c100000971.targetsw)
	e3:SetOperation(c100000971.activatesw)	
	c:RegisterEffect(e3)
		--shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100000971,2))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c100000971.targetsh)
	e4:SetOperation(c100000971.operationsh)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(100000971,3))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(c100000971.sptghand)
	e5:SetOperation(c100000971.spophand)
	c:RegisterEffect(e5)
		--damage amp
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetCondition(c100000971.dcon)
	e6:SetOperation(c100000971.dop)
	c:RegisterEffect(e6)
end
function c100000971.dcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsDefensePos() and eg:GetFirst():IsRace(RACE_ROCK)
end
function c100000971.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
function c100000971.filterhand(c)
	return c:IsSetCard(0x5c) and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ROCK) and c:IsAbleToHand()
end
function c100000971.sptghand(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100000971.filterhand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c100000971.spophand(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100000971.filterhand,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100000971.targetsh(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_MZONE,0,2,nil) end
end
function c100000971.operationsh(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	Duel.ShuffleSetCard(g)
end
function c100000971.conditionsw(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c100000971.filterty(c)
	return c:IsRace(RACE_ROCK) and c:IsFaceup()
end
function c100000971.targetsw(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100000971.filterty(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000971.filterty,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c100000971.filterty,tp,LOCATION_MZONE,0,1,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c100000971.activatesw(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
function c100000971.filter3(c)
	return  c:IsCode(55737443) and c:IsAbleToHand()
end
function c100000971.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and c100000971.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000971.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100000971.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c100000971.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c100000971.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(100000971)==0 end
	c:RegisterFlagEffect(100000971,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c100000971.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
