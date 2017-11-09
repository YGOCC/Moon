--Bushido Jaguar
function c1020043.initial_effect(c)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1020043.tgval)
	c:RegisterEffect(e1)
	--NS/Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(39695323,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,1020043)
	e2:SetTarget(c1020043.thtg)
	e2:SetOperation(c1020043.thop)
	c:RegisterEffect(e2)
	--Banish/Special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,1020043)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c1020043.regop)
	c:RegisterEffect(e3)
end
function c1020043.tgval(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsControler(1-e:GetHandlerPlayer()) and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
		and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c1020043.filter(c)
	return c:IsSetCard(0x4B0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c1020043.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1020043.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1020043.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1020043.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c1020043.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c1020043.descon)
	e1:SetOperation(c1020043.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c1020043.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsSetCard(0x4B0) and d and d:IsControler(1-tp) and d:IsDefensePos()
end
function c1020043.desop(e,tp,eg,ep,ev,re,r,rp)
	if d:IsRelateToBattle() then
		Duel.Hint(HINT_CARD,0,1020043)
		Duel.Destroy(d,REASON_EFFECT)
	end
end
