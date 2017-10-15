--Paintress Matissa
function c16000536.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
		--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c16000536.atktg)
	e2:SetValue(c16000536.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
		--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,16000536)
	e4:SetCondition(c16000536.thcon)
	e4:SetCost(c16000536.thcost)
	e4:SetTarget(c16000536.thtg)
	e4:SetOperation(c16000536.thop)
	c:RegisterEffect(e4)
end
function c16000536.atktg(e,c)
	return not c:IsType(TYPE_EFFECT)
end
function c16000536.val(e,c)
	return Duel.GetMatchingGroupCount(c16000536.ctfilter,c:GetControler(),0,LOCATION_MZONE,nil)*200
end
function c16000536.ctfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c16000536.costfilter(c)
	return c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c16000536.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000536.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c16000536.costfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Destroy(g,REASON_COST)
end

function c16000536.thcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xc50)
end
function c16000536.filter(c)
	return  c:IsSetCard(0xc52)  and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c16000536.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16000536.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16000536.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end