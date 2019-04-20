--CREATION Planetary Disintegrator
function c88880025.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) All "CREATION" Continuous spells you control cannot be targeted or destroyed and they cannot have their effects negated by opponents card effects.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ep1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(LOCATION_SZONE,0)
	ep1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL+TYPE_CONTINUOUS))
	ep1:SetValue(aux.indoval)
	c:RegisterEffect(ep1)
	local ep2=ep1:Clone()
	ep2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	ep2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ep2:SetValue(aux.tgoval)
	c:RegisterEffect(ep2)
	local ep3=ep1:Clone()
	ep3:SetCode(EFFECT_CANNOT_DISEFFECT)
	ep3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ep3:SetValue(aux.tgoval)
	c:RegisterEffect(ep3)
	--(p2) You can add 1 "CREATION" continuous spell from your deck to your hand, but cards of that name cannot be activated until the end of the turn. THis effect of "CREATION Planetary Disintegrator" can only be used once a turn.
	--Monster Effects
	local ep4=Effect.CreateEffect(c)
	ep4:SetCategory(CATEGORY_TOHAND)
	ep4:SetType(EFFECT_TYPE_IGNITION)
	ep4:SetRange(LOCATION_PZONE)
	ep4:SetTarget(c88880025.addtg)
	ep4:SetOperation(c88880025.addop)
	ep4:SetCountLimit(1,88880025)
	c:RegisterEffect(ep4)
	--(1) If you control no monsters: you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88880025.sprcon)
	c:RegisterEffect(e1)
	--(2) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: destroy one card in your hand; Special Summon, 1 "CREATION" monster from your hand or face-up in your Extra Deck, then, this cards level becomes 4 and if you do, add 1 "CREATION" continuous spell from your deck to your hand.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880025,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88880025.specon)
	e2:SetCost(c88880025.specos)
	e2:SetTarget(c88880025.spetg)
	e2:SetOperation(c88880025.speop)
	c:RegisterEffect(e2)
end
--Pendulum Effect
--(p1)
--(p2)
function c88880025.addfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c88880025.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880025.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880025.addop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88880025.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local code=g:GetFirst():GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c88880025.aclimit)
	e1:SetLabel(code)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c88880025.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end
--Monster Effect
--(1)
function c88880025.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
--(2) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: destroy one card in your hand; Special Summon, 1 "CREATION" monster from your hand or face-up in your Extra Deck, then, this cards level becomes 4 and if you do, add 1 "CREATION" continuous spell from your deck to your hand.
function c88880025.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880025.spefilter(c,e,tp)
	return c:IsSetCard(0x889) and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER)) and not (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c88880025.cfilter(c)
	return c:IsDiscardable()
end
function c88880025.specos(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880025.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c88880025.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c88880025.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if chk==0 then return loc~=0 and Duel.IsExistingMatchingCard(c88880025.spefilter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c88880025.speop(e,tp,eg,ep,ev,re,r,rp)
	local loc=0
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c88880025.spefilter),tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
	if c:GetLevel()==4 then
		local gt=Duel.SelectMatchingCard(tp,c88880025.addfilter,tp,LOCATION_DECK,0,1,1,nil)
		if gt:GetCount()>0 then
			Duel.SendtoHand(gt,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,gt)
		end
	end
end