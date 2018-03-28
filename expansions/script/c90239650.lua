--Pandemoniumgraph Magician
local card = c90239650
function card.initial_effect(c)
--special summon
	aux.AddOrigPandemoniumType(c)
	aux.EnablePandemoniumAttribute(c,e1)
local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetDescription(aux.Stringid(90239650,1))
	e1:SetRange(LOCATION_SZONE+LOCATION_PZONE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(card.condition)
	e1:SetTarget(card.qtg)
	e1:SetOperation(card.qop)
	c:RegisterEffect(e1)
		--turn set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90239650,2))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE+LOCATION_PZONE)
	e3:SetTarget(card.postg)
	e3:SetOperation(card.posop)
	c:RegisterEffect(e3)
end
function card.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function card.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

function card.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function card.qtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
end
function card.qop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
