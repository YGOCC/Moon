--Pandemoniumgraph Magician
local card = c90239650
function card.initial_effect(c)
	aux.AddOrigPandemoniumType(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(90239650,1))
	e1:SetRange(LOCATION_SZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(card.condition)
	e1:SetTarget(card.qtg)
	e1:SetOperation(card.qop)
	c:RegisterEffect(e1)
	aux.EnablePandemoniumAttribute(c,e1)
	--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90239650,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetLabelObject(e1)
	e3:SetTarget(card.postg)
	e3:SetOperation(card.posop)
	c:RegisterEffect(e3)
	--This card cannot be Pandemonium Summoned from your Extra Deck while you have a "Pandemoniumgraph" card in your Pandemonium Zone.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(card.splimit)
	c:RegisterEffect(e2)
	--Once per turn, if you do not have another card in your Pandemonium Zone: You can place this face-up card in your Monster Zone into your Spell/Trap Zone, and if you do, that Zone is treated as a Pandemonium Zone.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return not Duel.IsExistingMatchingCard(aux.PaCheckFilter,tp,LOCATION_SZONE,0,1,nil)
	end)
	e4:SetTarget(card.paztg)
	e4:SetOperation(card.pazop)
	c:RegisterEffect(e4)
end
function card.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp and e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function card.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		aux.PandSSet(c,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp)
	end
end

function card.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function card.qtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) and c:GetFlagEffect(90239650)==0 end
	c:RegisterFlagEffect(90239650,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.SetTargetCard(tg)
end
function card.qop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function card.splimit(e,se,sp,st)
	return not Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xcf80) and c:IsFaceup() end,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,nil)
		or bit.band(st,SUMMON_TYPE_SPECIAL+726)~=SUMMON_TYPE_SPECIAL+726
end
function card.paztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function card.pazop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
