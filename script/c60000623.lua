--Sharpshooter, Six Shooter
function c60000623.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,0x8),aux.NonTuner(Card.IsSetCard,0x604),1)
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
	e1:SetTarget(c60000623.splimit)
	c:RegisterEffect(e1)
	--5 or higher syn tripple attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(2)
	e2:SetTarget(c60000623.efilter)
	c:RegisterEffect(e2)
	--immune lvl 6 or higher
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c60000623.efilter2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(60000623,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c60000623.condition)
	e4:SetTarget(c60000623.target)
	e4:SetOperation(c60000623.operation)
	c:RegisterEffect(e4)
	--pendulum
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(60000623,1))
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetCondition(c60000623.pencon)
    e5:SetTarget(c60000623.pentarget)
    e5:SetOperation(c60000623.penop)
    c:RegisterEffect(e5)
end
function c60000623.splimit(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x604) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c60000623.efilter(e,c)
	return c:IsSetCard(0x604) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(5)
end
function c60000623.efilter2(e,te)
if te:IsActiveType(TYPE_MONSTER) and te:IsActivated() then
    local ec=te:GetOwner()
    return ec:GetLevel()>=6
else
    return false
end
end
function c60000623.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and rc:IsLevelAbove(6) and loc==LOCATION_MZONE and Duel.IsChainNegatable(ev)
end
function c60000623.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c60000623.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then 
	local e4=Effect.CreateEffect(e:GetHandler())
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_UPDATE_ATTACK)
        e4:SetValue(-rc:GetLevel()*100)
        e4:SetReset(RESET_EVENT+0x1fe0000)
        rc:RegisterEffect(e4)
	end
end
function c60000623.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c60000623.desfilter(c)
    return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c60000623.pentarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c60000623.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c60000623.penop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
        Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
