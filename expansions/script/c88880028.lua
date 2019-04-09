--CREATION Planetary Survivor
function c88880028.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) You cannot Pendulum Summon monsters, except "CREATION" monsters.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ep1:SetTargetRange(1,0)
	ep1:SetTarget(c88880028.splimit)
	c:RegisterEffect(ep1)
	--(p2) Once a turn, you can activate 1 "CREATION" Continuous spell directly from your deck. 
	local ep2=Effect.CreateEffect(c)
	ep2:SetDescription(aux.Stringid(88880028,1))
	ep2:SetCategory(CATEGORY_SEARCH)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetCountLimit(1)
	ep2:SetTarget(c88880028.thtg)
	ep2:SetOperation(c88880028.thop)
	c:RegisterEffect(ep2)
	--(p3) If you control a "Number 300" monster: you take no damage while this card is on the field.
	local ep3=Effect.CreateEffect(c)
	ep3:SetType(EFFECT_TYPE_FIELD)
	ep3:SetCode(EFFECT_CHANGE_DAMAGE)
	ep3:SetRange(LOCATION_PZONE)
	ep3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ep3:SetTargetRange(1,0)
	ep3:SetCondition(c88880028.damcon)
	ep3:SetValue(0)
	c:RegisterEffect(ep3)
	local ep4=ep3:Clone()
	ep4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(ep4)
	--Monster Effects
	--(1) If a card(s) you control would be destroyed: Special Summon this card, then end the current phase. 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c88880028.desreptg)
	e1:SetValue(c88880028.desrepval)
	e1:SetOperation(c88880028.desrepop)
	c:RegisterEffect(e1)
	--(2) If this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: Special Summon 1 "CREATION" monster from your deck and if you do, add 1 "CREATION" continuous spell from your Deck to your hand, then,  this cards level becomes 4.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880028,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88880028.specon)
	e2:SetTarget(c88880028.spetg)
	e2:SetOperation(c88880028.speop)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(p1)
function c88880028.filter(c)
	return c:IsSetCard(0x889)
end
function c88880028.splimit(e,c,tp,sumtp,sumpos)
	if not (bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM) then return end
	return not c88880028.filter(c)
end
--(p2) Once a turn, you can activate 1 "CREATION" Continuous spell directly from your deck. 
function c88880028.thfilter(c,tp)
	return c:IsSetCard(0x889) and c:GetType()==0x20002
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function c88880028.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880028.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880028.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(88880028,3))
	local g=Duel.SelectMatchingCard(tp,c88880028.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end
--(p3) If you control a "CREATION-Eyes" monster: you take no damage while this card is on the field.
function c88880028.cfilter(c)
	return c:IsSetCard(0x1889) and c:IsType(TYPE_MONSTER)
end
function c88880028.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c88880028.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

--Monster Effects
--(1) 
function c88880028.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c88880028.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetCode()
	if chk==0 then return eg:IsExists(c88880028.repfilter,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		return true
	else return false end
end
function c88880028.desrepval(e,c)
	return c88880028.repfilter(c,e:GetHandlerPlayer())
end
function c88880028.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,88880028)
	local tc=e:GetHandler()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end
--(2) If this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: Special Summon 1 "CREATION" monster from your deck and if you do, add 1 "CREATION" continuous spell from your Deck to your hand, then,  this cards level becomes 4.
function c88880028.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880028.spefilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x889) and c:IsLocation(LOCATION_DECK)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880028.addfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c88880028.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880028.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88880028.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880028.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local gt=Duel.SelectMatchingCard(tp,c88880028.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if gt:GetCount()>0 then
		Duel.SendtoHand(gt,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,gt)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
end