--Chimera Capricorn
function c11000521.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c11000521.atk)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11000521.atk)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	--add
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(11000521,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c11000521.cost)
	e4:SetTarget(c11000521.target)
	e4:SetOperation(c11000521.operation)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(11000521,ACTIVITY_SPSUMMON,c11000521.counterfilter)
end
function c11000521.atk(e,c)
	return c:IsSetCard(0x11FD) or c:IsSetCard(0x1F3)
end
function c11000521.counterfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)~=SUMMON_TYPE_PENDULUM
end
function c11000521.cfilter(c)
	return c:IsSetCard(0x1FD) and c:IsDiscardable()
end
function c11000521.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000521.cfilter,tp,LOCATION_HAND,0,1,nil)
	and Duel.GetCustomActivityCount(11000521,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c11000521.splimit)
	Duel.RegisterEffect(e1,tp)
	Duel.DiscardHand(tp,c11000521.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c11000521.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c11000521.filter(c)
	return c:IsSetCard(0x11FD) and c:IsAbleToHand()
end
function c11000521.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11000521.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11000521.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11000521.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end