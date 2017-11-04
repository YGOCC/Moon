--Lyric Buster EX
local ref=_G['c'..18917009]
function ref.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(ref.atktg)
	e1:SetOperation(ref.atkop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(ref.thcost)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end

function ref.tgfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(ref.grfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function ref.grfilter(c,att)
	return c:IsAttribute(att) and c:GetAttack()>0
		and c:IsAbleToGrave()
end
function ref.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and ref.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.SelectTarget(tp,ref.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,ref.grfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT) then
		local atk=g:GetFirst():GetAttack()
		local atkg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local atkc=atkg:GetFirst()
		while atkc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-atk)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			atkc:RegisterEffect(e1)
			atkc=atkg:GetNext()
		end
	end
end

function ref.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
end
function ref.thfilter(c)
	return (c:IsCode(18917005) or c:IsCode(18917008))
		and c:IsAbleToHand()
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
