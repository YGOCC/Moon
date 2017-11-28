--Black Flag Flying Ship
function c90000079.initial_effect(c)
	c:SetUniqueOnField(1,0,90000079)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c90000079.operation1)
	c:RegisterEffect(e1)
	--Battle Damage 0
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_ZOMBIE))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Destroy Replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c90000079.target3)
	c:RegisterEffect(e3)
end
function c90000079.filter1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c90000079.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c90000079.filter1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(90000079,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c90000079.filter3(c,tp,e)
	return c:IsControler(tp) and c:IsLocation(LOCATION_SZONE) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c90000079.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and eg:IsExists(c90000079.filter3,1,nil,tp,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(90000079,1)) then
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		return true
	else
		return false
	end
end