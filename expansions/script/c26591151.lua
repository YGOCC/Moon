--Drago Caduto della Xenofiamma
--Script by XGlitchy30
function c26591151.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c26591151.matfilter,7,2,nil,nil,99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c26591151.efilter)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26591151,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCost(c26591151.cost)
	e2:SetTarget(c26591151.sctg)
	e2:SetOperation(c26591151.scop)
	c:RegisterEffect(e2)
	--destroy
	local e2x=Effect.CreateEffect(c)
	e2x:SetDescription(aux.Stringid(26591151,1))
	e2x:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e2x:SetType(EFFECT_TYPE_IGNITION)
	e2x:SetRange(LOCATION_MZONE)
	e2x:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2x:SetCost(c26591151.cost)
	e2x:SetTarget(c26591151.drytg)
	e2x:SetOperation(c26591151.dryop)
	c:RegisterEffect(e2x)
	--banish event
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1)
	e3:SetCost(c26591151.thcost)
	e3:SetTarget(c26591151.thtg)
	e3:SetOperation(c26591151.thop)
	c:RegisterEffect(e3)
end
--filters
function c26591151.matfilter(c)
	return c:IsSetCard(0x23b9)
end
function c26591151.scfilter(c)
	return c:IsSetCard(0x23b9) and c:IsAbleToHand()
end
function c26591151.cfilter(c)
	return c:IsSetCard(0x23b9) and c:IsAbleToRemove()
end
function c26591151.thfilter(c)
	return c:IsSetCard(0x23b9) and c:GetLevel()>=5 and c:IsAbleToHand()
end
--immune
function c26591151.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and not te:GetOwner():IsSetCard(0x23b9)
end
--search
function c26591151.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c26591151.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26591151.scfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c26591151.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26591151.scfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--destroy
function c26591151.drytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26591151.cfilter,tp,LOCATION_GRAVE,0,2,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c26591151.dryop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,c26591151.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	if Duel.Remove(cg,POS_FACEUP,REASON_COST)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
--banish event
function c26591151.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,3) end
	Duel.DiscardDeck(tp,3,REASON_COST)
end
function c26591151.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26591151.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26591151.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26591151.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end