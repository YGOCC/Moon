--Team Bullet Train Aotobot - Midnight Express
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c115000005.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(115000005,0))
	Senya.AddAttackSE(c,aux.Stringid(115000005,1))
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75878039,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(c115000005.target)
	e1:SetOperation(c115000005.operation)
	c:RegisterEffect(e1)
end
function c115000005.filter(c)
	return c:IsSetCard(0x201) and c:IsAbleToHand() and not c:IsCode(115000005)
end
function c115000005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115000005.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115000005.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c115000005.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end