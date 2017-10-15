--Lunar Phase: Moon Burst the Forgotten Child
function c4242568.initial_effect(c)
	 --pendulum summon
 aux.EnablePendulumAttribute(c)
		--search if deal damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242568,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCountLimit(1,4242568)
	e1:SetCondition(c4242568.condition)
	e1:SetTarget(c4242568.target)
	e1:SetOperation(c4242568.operation)
	c:RegisterEffect(e1)
	
	
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242568,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c4242568.descon1)
	e4:SetTarget(c4242568.destg1)
	e4:SetOperation(c4242568.desop1)
	c:RegisterEffect(e4)
	 	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c4242568.atkcon)
	e5:SetCost(c4242568.cost2)
	e5:SetOperation(c4242568.atkop)
	c:RegisterEffect(e5)
end
function c4242568.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if bc:IsControler(1-tp) then bc=tc end
	e:SetLabelObject(bc)
	return bc:IsFaceup() and bc:IsSetCard(0x666)
end
function c4242568.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c4242568.atkop(e,tp,eg,ep,ev,re,r,rp)
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

--search tiny pony
function c4242568.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242568.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242568.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242568.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242568.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242568.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

--search if deal damage
function c4242568.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c4242568.filter2(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(4) and not c:IsLevelBelow(3)
end
function c4242568.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 end
end
function c4242568.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
    Duel.ConfirmDecktop(tp,1)
    local g=Duel.GetDecktopGroup(tp,1)
    local tc=g:GetFirst()
    if tc:IsSetCard(0x666) then
    	Duel.SendtoHand(tc,nil,REASON_EFFECT)
    	Duel.ConfirmCards(1-tp,tc)
    else
    	Duel.SendtoGrave(tc,REASON_EFFECT)
    end
end

	
	
	
	
	
	
	
	
	
	