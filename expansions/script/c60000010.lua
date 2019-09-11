-- Healer Blade Vess

function c60000010.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000010,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,600000101)
	e1:SetTarget(c60000010.target)
	e1:SetOperation(c60000010.operation)
	c:RegisterEffect(e1)
	--LP gain
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60000010,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c60000010.atcon)
	e2:SetOperation(c60000010.atop)
	c:RegisterEffect(e2)
end

function c60000010.filter(c)
	return c:IsLevelBelow(3) and c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c60000010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000010.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c60000010.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60000010.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c60000010.atcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	local bc=ec:GetBattleTarget()
	e:SetLabel(bc:GetBaseAttack())
	return ec:IsControler(tp) and ec:IsAttribute(ATTRIBUTE_LIGHT) and ec:IsRace(RACE_FAIRY) and bc and bc:IsType(TYPE_MONSTER) 
		and ec:IsStatus(STATUS_OPPO_BATTLE)
end
function c60000010.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end