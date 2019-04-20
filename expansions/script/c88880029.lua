--CREATION Planetary Mapper
function c88880029.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) If "Number U301: Neon CREATION-Eyes Prime Reality Dragon" is face up in the Extra deck: This cards Pendulum Scale becomes 14, but you can only Pendulum Summon monsters with that name.
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(c88880029.slcon)
	ep1:SetValue(14)
	c:RegisterEffect(ep1)
	local ep2=ep1:Clone()
	ep2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(ep2)
	local ep3=Effect.CreateEffect(c)
	ep3:SetType(EFFECT_TYPE_FIELD)
	ep3:SetRange(LOCATION_PZONE)
	ep3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	ep3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ep3:SetTargetRange(1,0)
	ep3:SetTarget(c88880029.splimit)
	c:RegisterEffect(ep3)
	--Monster Effects
	--(1) When you control no cards: Special Summon this card.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88880029.spcon)
	c:RegisterEffect(e1)
	--(2) If this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: Activate 1 "CREATION" Continuous spell from your deck and if you do, Special Summon, 1 "CREATION" monster from your deck, then, this cards level becomes 4.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880029,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88880029.specon)
	e2:SetTarget(c88880029.spetg)
	e2:SetOperation(c88880029.speop)
	c:RegisterEffect(e2)
end
--Pendulum Effects
--(p1) If "Number U301: Neon CREATION-Eyes Prime Reality Dragon" is face up in the Extra deck: This cards Pendulum Scale becomes 14, but you can only Pendulum Summon monsters with that name.
function c88880029.slfilter(c)
	return c:IsCode(88880056)
end
function c88880029.slcon(e)
	return Duel.IsExistingMatchingCard(c88880029.slfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,e:GetHandler())
end
function c88880029.filter(c)
	return c:IsCode(88880056)
end
function c88880029.splimit(e,c,tp,sumtp,sumpos)
	return not c88880029.filter(c)
end
--(1) When you control no cards: Special Summon this card.
function c88880029.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.GetFieldGroupCount(c:GetControler(),LOCATION_ONFIELD,0)==0
end
--(2) If this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: Activate 1 "CREATION" Continuous spell from your deck and if you do, Special Summon, 1 "CREATION" monster from your deck, then, this cards level becomes 4.
function c88880029.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880029.spefilter(c,e,tp)
	return c:IsSetCard(0x889) and (c:IsLocation(LOCATION_DECK) and c:IsType(TYPE_MONSTER))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c88880029.addfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c88880029.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880029.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88880029.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880029.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg then
		Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tg:GetActivateEffect()
		local tep=tg:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
	local gt=Duel.SelectMatchingCard(tp,c88880029.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if gt:GetCount()>0 then
		Duel.SpecialSummon(gt,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
end