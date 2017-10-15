--Sharpshooter, Dual Shot
function c60000617.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --chain attack
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60000617,2))
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EVENT_BATTLED)
    e1:SetCountLimit(1)
    e1:SetCondition(c60000617.atcon)
    e1:SetOperation(c60000617.atop)
    e1:SetCost(c60000617.atcos)
    c:RegisterEffect(e1)
    --double attack
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c60000617.atcon2)
    e2:SetTarget(c60000617.attar)
    e2:SetOperation(c60000617.atop2)
    c:RegisterEffect(e2)
end
function c60000617.atcon(e,tp,eg,ep,ev,re,r,rp)
    local c=Duel.GetAttacker()
    local bc=c:GetBattleTarget()
    return bc and c:IsControler(tp) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(5) and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable() and c:IsStatus(STATUS_OPPO_BATTLE) 
end
function c60000617.atop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChainAttack()
end
function c60000617.atcos(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetAttacker()
    local atk=tc:GetAttack()/2
    if chk==0 then return Duel.CheckLPCost(tp,atk) end
    if not tc:IsRelateToBattle() then return end
    if atk<0 then atk=0 end
    Duel.PayLPCost(tp,math.floor(atk))
end
function c60000617.atcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c60000617.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x604)
end
function c60000617.attar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c60000617.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60000617.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c60000617.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c60000617.atop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end