--Pandemoniumgraph Valkyrie
function c90277800.initial_effect(c)
   --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90277800,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c90277800.condition)
	e1:SetTarget(c90277800.target)
	e1:SetOperation(c90277800.operation)
	c:RegisterEffect(e1)
	if not c90277800.global_check then
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetLabel(326)
		ge2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
		ge2:SetOperation(c90277800.chk)
		Duel.RegisterEffect(ge2,0)
	end
end
c90277800.pandemonium=true
c90277800.pandemonium_lscale=8 
c90277800.pandemonium_rscale=1 
function c90277800.chk(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,e:GetLabel())
	Duel.CreateToken(1-tp,e:GetLabel())
end
function c90277800.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c90277800.filter(c)
	return c:IsSetCard(0xCF80) and c:IsAbleToHand()
end
function c90277800.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90277800.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c90277800.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c90277800.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end