--Aufbewahrungsraum der magischen Waffen
function c10100088.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10100088+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c10100088.activate)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x326))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--activate cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(c10100088.actarget)
	e4:SetCost(c10100088.costchk)
	e4:SetOperation(c10100088.costop)
	c:RegisterEffect(e4)
	--immune effect
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(c10100088.etarget)
	e5:SetValue(c10100088.efilter)
	c:RegisterEffect(e5)
end
function c10100088.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c10100088.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10100088,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c10100088.thfilter(c)
	return c:IsSetCard(0x326) and not c:IsCode(10100088)
end
function c10100088.actarget(e,te,tp)
	return te:GetHandler():IsType(TYPE_SPELL)
end
function c10100088.costchk(e,te_or_c,tp)
	return Duel.CheckLPCost(tp,300)
end
function c10100088.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,10100088)
	Duel.PayLPCost(tp,300)
end
function c10100088.etarget(e,c)
	return c:IsSetCard(0x326) and c:IsType(TYPE_EQUIP)
end
function c10100088.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end