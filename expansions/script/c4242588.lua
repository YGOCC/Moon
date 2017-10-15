--Lunar Phase: Moon Burst Origins
function c4242588.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)

	--atk up
	--
       local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64207696,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetTarget(c4242588.atktg)
	e2:SetOperation(c4242588.atkop)
	c:RegisterEffect(e2)

		local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242588,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c4242588.descon1)
	e3:SetTarget(c4242588.destg1)
	e3:SetOperation(c4242588.desop1)
	c:RegisterEffect(e3)
	 	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c4242588.atkcon)
	e5:SetCost(c4242588.cost2)
	e5:SetOperation(c4242588.atkop1)
	c:RegisterEffect(e5)
end
function c4242588.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then bc=tc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and bc:IsSetCard(0x666)
end
function c4242588.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c4242588.atkop1(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
 e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		tc:RegisterEffect(e1)
	
	end
end

--damage down
function c4242588.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER)
end
function c4242588.condition(e)
	return Duel.IsExistingMatchingCard(c4242588.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4242588.val(e,re,val,r,rp,rc)
    if bit.band(r,REASON_BATTLE)~=0 then
		return val/2
    else
        return val
    end
end
--atk 200
function c4242588.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666) and c:IsFaceup()
end
function c4242588.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c4242588.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c4242588.atkop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c4242588.atkfilter,tp,LOCATION_MZONE,0,nil)
    local codect=Duel.GetMatchingGroup(c4242588.atkfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
    local atk=codect:GetClassCount(Card.GetCode)*100
    local c=e:GetHandler()
    local tc=sg:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,2)
        tc:RegisterEffect(e1)
        tc=sg:GetNext()
    end
end
function c4242588.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242588.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242588.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242588.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242588.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242588.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
