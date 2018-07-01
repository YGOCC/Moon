--Slifer's Hydra, Guardian of the Sanctuary
function c362136728.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(362136728,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,362136728)
	e1:SetCost(c362136728.thcost)
	e1:SetTarget(c362136728.thtg)
	e1:SetOperation(c362136728.thop)
	c:RegisterEffect(e1)
	--shuffle to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(362136728,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCountLimit(1,362136728)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c362136728.tdcon)
	e2:SetTarget(c362136728.tdtg)
	e2:SetOperation(c362136728.tdop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(362136728,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,362136728)
	e3:SetCondition(c362136728.descon)
	e3:SetCost(c362136728.descost)
	e3:SetTarget(c362136728.destg)
	e3:SetOperation(c362136728.desop)
	c:RegisterEffect(e3)
end
function c362136728.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c362136728.thfilter1(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x1d8b) and c:IsAbleToHand()
end
function c362136728.thfilter2(c)
	return ((c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1d8b)) or c:IsCode(10000020)) and c:IsAbleToGrave()
end
function c362136728.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c362136728.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c362136728.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c362136728.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		local g2=Duel.SelectMatchingCard(tp,c362136728.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g2,REASON_EFFECT)
	end
end
function c362136728.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RITUAL
end
function c362136728.tdfilter(c,atk)
	return c:IsFaceup() and c:IsDefenseAbove(atk+1)
end
function c362136728.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetAttack()
	if chk==0 then return Duel.IsExistingMatchingCard(c362136728.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),atk) end
	local g=Duel.GetMatchingGroup(c362136728.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),atk)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c362136728.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local atk=c:GetAttack()
	local g=Duel.GetMatchingGroup(c362136728.tdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),atk)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c362136728.descon(e,c,minc)
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function c362136728.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c362136728.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c362136728.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c362136728.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c362136728.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c362136728.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c362136728.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end