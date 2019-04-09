--CREATION Planetary Explorer
function c88880026.initial_effect(c)
	--Pendulum Effects
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--(p1) Once a turn, while you control a "CREATION" Xyz monster(s): you can discard 1 card; Send 1 "Rank-Up-Magic" card from your deck to the GY and if you do, apply that cards effect(s).
	local ep1=Effect.CreateEffect(c)
	ep1:SetCategory(CATEGORY_TOGRAVE)
	ep1:SetType(EFFECT_TYPE_IGNITION)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(c88880026.rumcon)
	ep1:SetCost(c88880026.rumcost)
	ep1:SetTarget(c88880026.rumtg)
	ep1:SetOperation(c88880026.rumop)
	c:RegisterEffect(ep1)
	--Monster Effect
	--(1) If your opponent controls no card(s) you can Special Summon this card (from your hand).
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c88880026.sprcon)
	c:RegisterEffect(e1)
	--(2) When this card is Special summoned by the effect of a "CREATION" card, Pandemonium Summoned with a "CREATION" Pandemonium monster, or Pendulum summoned while you have a "CREATION" Pendulum Monster(s) in the Pendulum Zone: Special Summon 1 level 4 or lower "CREATION" monster from your deck, then, this cards level becomes 4.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88880026,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c88880026.specon)
	e2:SetTarget(c88880026.spetg)
	e2:SetOperation(c88880026.speop)
	c:RegisterEffect(e2)
	--(3) You can discard 1 "CREATION" card: Add 1 "CREATION" continues Spell from your deck to your hand.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c88880026.addtg)
	e3:SetCost(c88880026.addcost)
	e3:SetOperation(c88880026.addop)
	c:RegisterEffect(e3)
end
--Pendulum Effects
--(p1) Once a turn, while you control a "CREATION" Xyz monster(s): you can discard 1 card; Send 1 "Rank-Up-Magic" card from your deck to the GY and if you do, apply that cards effect(s).
function c88880026.rumfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x889) and c:IsType(TYPE_XYZ)
end
function c88880026.rumcon(e)
	local c=e:GetHandler()
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c88880026.rumfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c88880026.rumfilter2(c)
	return c:IsDiscardable()
end
function c88880026.rumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880026.rumfilter2,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c88880026.rumfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c88880026.rumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c88880026.rumfilter3,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c88880026.rumfilter3,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c88880026.rumfilter3(c)
	return c:IsSetCard(0x95) and c:IsAbleToGrave()
end
function c88880026.rumop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoGrave(te:GetHandler(),nil,2,REASON_EFFECT)
end
--Monster Effects
--(1) 
function c88880026.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)==0
end
--(2)
function c88880026.specon(e,tp,eg,ep,ev,re,r,rp,se,sp,st)
	return re:GetHandler():IsSetCard(0x889) or (e:GetHandler():IsSummonType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x889)) or (e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+726) and se and se:GetHandler():IsSetCode(0x889))
end
function c88880026.spefilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x889)
end
function c88880026.spetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c88880026.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c88880026.speop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c88880026.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	c:RegisterEffect(e1)
end
--(3)
function c88880026.addfilter(c)
	return c:IsSetCard(0x889) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function c88880026.cfilter(c)
	return c:IsSetCard(0x889) and c:IsDiscardable()
end
function c88880026.addcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880026.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c88880026.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c88880026.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88880026.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c88880026.addop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c88880026.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end