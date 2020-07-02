--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetTarget(cid.thtg)
	e1:SetOperation(cid.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id+100)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCondition(cid.condition)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
end
function cid.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd78)
end
function cid.lvcheck(g)
	return g:FilterCount(Card.IsLevel,nil,4)==1
end
function cid.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		aux.GCheckAdditional=cid.lvcheck
		local res=Duel.GetMatchingGroup(aux.AND(Card.IsLevelAbove,cid.thfilter,Card.IsAbleToHand),tp,LOCATION_DECK,0,nil,4):CheckSubGroup(aux.TRUE,2,2)
		aux.GCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,LOCATION_DECK)
end
function cid.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.AND(Card.IsLevelAbove,cid.thfilter),tp,LOCATION_DECK,0,nil,4)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) or #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	aux.GCheckAdditional=cid.lvcheck
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,2,2)
	aux.GCheckAdditional=nil
	Duel.ConfirmCards(1-tp,sg)
	local tc=sg:Select(1-tp,1,1,nil):GetFirst()
	if tc and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		sg:RemoveCard(tc)
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and re and re:GetHandler():IsSetCard(0xd78)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.AND(cid.thfilter,Card.IsAbleToHand),tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.AND(cid.thfilter,Card.IsAbleToHand),tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
