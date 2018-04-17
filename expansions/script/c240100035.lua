--created & coded by Lyris, art at http://www.uppicweb.com/x/i/it/136369.jpg
--襲雷の空
function c240100035.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetValue(c240100035.hdval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,240100035)
	e3:SetTarget(c240100035.tg)
	e3:SetOperation(c240100035.op)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c240100035.reptg)
	e4:SetValue(c240100035.repval)
	e4:SetOperation(c240100035.repop)
	c:RegisterEffect(e4)
end
function c240100035.hdval(e,re,dam,r,rp,rc)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0 then
		return dam/2
	else return dam end
end
function c240100035.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7c4)
end
function c240100035.filter2(c)
	return c:IsSetCard(0x7c4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c240100035.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c240100035.filter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(c240100035.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c240100035.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c240100035.filter1,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c240100035.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c240100035.repfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x7c4) and c:IsType(TYPE_MONSTER)
		and c:IsDestructable(e) and not c:IsReason(REASON_REPLACE)
end
function c240100035.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c240100035.repfilter,1,nil,e) end
	if Duel.IsExistingMatchingCard(aux.AND(c240100035.filter1,aux.FilterBoolFunction(Card.IsDestructable,e)),tp,LOCATION_DECK,0,1,nil) then
		return true
	else return false end
end
function c240100035.repval(e,c)
	return c240100035.repfilter(c,e)
end
function c240100035.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.AND(c240100035.filter1,aux.FilterBoolFunction(Card.IsDestructable,e)),tp,LOCATION_DECK,0,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
