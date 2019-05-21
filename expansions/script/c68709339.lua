--HDD RR
--scripted by concordia
function c68709339.initial_effect(c)
 	--link summon
    aux.AddLinkProcedure(c,c68709339.lfilter,2,2)
    c:EnableReviveLimit()
    --atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c68709339.atktg)
	e2:SetOperation(c68709339.atkop)
	e2:SetValue(c68709339.atkval)
	c:RegisterEffect(e2)
	--chain attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(68709339,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1)
	e3:SetCondition(c68709339.atcon)
	e3:SetOperation(c68709339.atop)
	c:RegisterEffect(e3)
end
function c68709339.lfilter(c)
    return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xf08) or c:IsSetCard(0xf09))
end
function c68709339.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)>0 end
end
function c68709339.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local val=g:GetClassCount(Card.GetCode)*200
	if c:IsFaceup() and c:IsRelateToEffect(e) and val>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		c:RegisterEffect(e1)
	end
end
function c68709339.filter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0xf08) or c:IsSetCard(0xf09))
end
function c68709339.atkval(e,c)
	return Duel.GetMatchingGroupCount(c68709339.filter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end
function c68709339.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and c:GetFlagEffect(72989439)==0
		and c:IsChainAttackable()
end
function c68709339.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end