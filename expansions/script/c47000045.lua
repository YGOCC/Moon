--Digimon Starmon
function c47000045.initial_effect(c)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000045,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c47000045.cost)
	e1:SetTarget(c47000045.target)
	e1:SetOperation(c47000045.operation)
	e1:SetCountLimit(1,47000045+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
end
function c47000045.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c47000045.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3E4) 
end
function c47000045.con(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c47000045.ntfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c47000045.filter(c)
	return c:IsSetCard(0x3E4) and not c:IsCode(47000045) and c:GetLevel()==4 and c:IsAbleToHand()
end
function c47000045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47000045.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47000045.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c47000045.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tg:GetCount()>0  then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

