--Sharpshooter, Bullseye
function c60000620.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x604),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60000620.splimit)
	c:RegisterEffect(e1)
    --Activate
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,60000620+EFFECT_COUNT_CODE_OATH)
    e2:SetCost(c60000620.cost)
    e2:SetTarget(c60000620.target)
    e2:SetOperation(c60000620.activate)
    c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c60000620.indes)
	c:RegisterEffect(e3)
	--Leech
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60000620,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1)
	e4:SetTarget(c60000620.ltarget)
	e4:SetOperation(c.loperation)
	c:RegisterEffect(e4)
    --pendulum
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(60000620,1))
    e6:SetCategory(CATEGORY_DESTROY)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetCode(EVENT_DESTROYED)
    e6:SetCondition(c60000620.condition)
    e6:SetTarget(c60000620.pentarget)
    e6:SetOperation(c60000620.operation)
    c:RegisterEffect(e6)
end
function c60000620.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x604) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c60000620.filter(c)
    return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeckAsCost() and c:IsSetCard(0x604)
end
function c60000620.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        e:SetLabel(100)
        return Duel.IsExistingMatchingCard(c60000620.filter,tp,LOCATION_EXTRA,0,1,nil)
    end
end
function c60000620.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local res=e:GetLabel()==100
        e:SetLabel(0)
        return res
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c60000620.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    Duel.SendtoDeck(g,nil,2,REASON_COST)
    local d=g:GetFirst():GetLevel()*500
    Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(d)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,d)
end
function c60000620.activate(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c60000620.indes(e,c)
	return c:GetAttack()>=2500
end
function c60000620.filter2(c)
	return c:GetAttack()>=2500
end
function c60000620.ltarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c60000620.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000620.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c60000620.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function c60000620.loperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5:SetValue(tc:GetAttack()-500)
		tc:RegisterEffect(e5)
	end
end
function c60000620.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c60000620.desfilter(c)
    return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60000620.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c60000620.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60000620.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end