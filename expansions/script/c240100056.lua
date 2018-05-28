--Cyberdarkness Operator
function c240100056.initial_effect(c)
	aux.AddOrigPandemoniumType(c,true,true)
	aux.EnablePendulumAttribute(c,false)
	--While face-up on the field, this card is NOT treated as a Spell/Trap Card.
	local gt,pt=Card.GetType,Card.GetPreviousTypeOnField
	Card.GetType=function(tc)
		if tc:IsHasEffect(240100056) then return gt(tc)&~(TYPE_SPELL+TYPE_TRAP) end
		return gt(tc)
	end
	Card.GetPreviousTypeOnField=function(tc)
		if tc:IsHasEffect(240100056) then return pt(tc)&~(TYPE_SPELL+TYPE_TRAP) end
		return pt(tc)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(240100056)
	e1:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_PZONE+LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return c==e:GetHandler() end)
	c:RegisterEffect(e1)
	--When this card is activated: You can discard 1 Dragon monster; add 1 "Cyberdark" Effect Monster from your Deck to your hand, then, immediately after this effect resolves, you can Normal Summon that monster.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON)
	e2:SetCost(c240100056.cost)
	e2:SetTarget(c240100056.target)
	e2:SetOperation(c240100056.activate)
	c:RegisterEffect(e2)
	aux.EnablePandemoniumAttribute(c,e2,TYPE_NORMAL)
	--If your Equip Card(s) that was originally a monster would leave the field, that card(s) becomes a Continuous Spell instead with this effect. (below)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_PZONE+LOCATION_SZONE)
	e3:SetTarget(c240100056.reptg)
	e3:SetValue(c240100056.repval)
	c:RegisterEffect(e3)
	--toggle pendulum/pandemonium
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c240100056.actchk)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==e:GetHandler() end)
	e5:SetOperation(function(e) e:GetHandler():ResetFlagEffect(726) end)
	c:RegisterEffect(e5)
end
function c240100056.actchk(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>0
end
function c240100056.cfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsDiscardable()
end
function c240100056.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100056.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsRace,1,1,REASON_COST+REASON_DISCARD,nil,RACE_DRAGON)
end
function c240100056.thfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x4093) and c:IsAbleToHand()
end
function c240100056.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100056.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100056.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c240100056.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local og=Duel.GetOperatedGroup():Filter(Card.IsSummonable,nil,true,nil)
		if og:GetCount()>0 and Duel.SelectYesNo(tp,1) then
			Duel.BreakEffect()
			local sg=og:GetFirst()
			Duel.Summon(tp,sg,true,nil)
		end
	end
end
function c240100056.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and (c:IsType(TYPE_EQUIP) or (c:GetFlagEffect(240100056)~=0 and c:GetFlagEffectLabel(240100056)~=0))
		and c:GetOriginalType()&TYPE_MONSTER==TYPE_MONSTER
end
function c240100056.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsStatus(STATUS_DESTROY_CONFIRMED)
		and (c:IsLocation(LOCATION_PZONE) or aux.PandActCheck(e))
		and eg:IsExists(c240100056.repfilter,1,nil,tp) end
	local g=eg:Filter(c240100056.repfilter,nil,tp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or eg:GetCount()>1 then Duel.HintSelection(g) end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		--Your "Cyberdark" Effect Monsters cannot be destroyed by your opponent's card effects, also your opponent cannot target them with card effects.
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c240100056.indestg)
		e2:SetValue(aux.indoval)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetValue(aux.tgoval)
		tc:RegisterEffect(e3)
		--All your "Cyberdark" Effect Monsters gain ATK equal to this card's original (printed) ATK.
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetRange(LOCATION_SZONE)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_DECK)
		e4:SetTarget(c240100056.atktg)
		e4:SetValue(tc:GetTextAttack())
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e4)
		local ct=tc:GetFlagEffectLabel(240100056)
		if not ct then tc:RegisterFlagEffect(240100056,RESET_CHAIN,0,1,1)
		else tc:SetFlagEffectLabel(240100056,ct-1) end
	end
	return true
end
function c240100056.repval(e,c)
	return c240100056.repfilter(c,e:GetHandlerPlayer())
end
function c240100056.indestg(e,c)
	return c:IsSetCard(0x4093) and c:IsType(TYPE_EFFECT)
end
function c240100056.atktg(e,c)
	return c:IsSetCard(0x4093) and c:IsType(TYPE_EFFECT) and e:GetHandler():GetEquipTarget()~=c
end
