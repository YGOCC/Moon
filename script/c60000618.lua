--Sharpshooter, Long Shot
function c60000618.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--5 and lower attack directly
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c60000618.efilter)
	c:RegisterEffect(e1)
	--damage reduce
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(c60000618.rdcon)
    e2:SetOperation(c60000618.rdop)
    c:RegisterEffect(e2)
    --effect damage
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetCountLimit(1)
    e3:SetOperation(c60000618.operation)
    e3:SetCost(c60000618.cost)
    e3:SetTarget(c60000618.target)
    c:RegisterEffect(e3)
end
--atk boost code
function c60000618.efilter(e,c)
	return c:IsSetCard(0x604) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(5)
end
function c60000618.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and Duel.GetAttackTarget()==nil and c:GetEffectCount(EFFECT_DIRECT_ATTACK)<2 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
function c60000618.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c60000618.filter(c)
    return c:IsSetCard(0x604) and c:IsFaceup() and c:IsLevelBelow(3)
end
function c60000618.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60000618.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    local d=Duel.GetMatchingGroupCount(c60000618.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*500
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function c60000618.operation(e,tp,eg,ep,ev,re,r,rp)
    local d=Duel.GetMatchingGroupCount(c60000618.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*500
    Duel.Damage(1-tp,d,REASON_EFFECT)
end
function c60000618.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end