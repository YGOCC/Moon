--Corno di Luce del Paradiso
--Script by XGlitchy30
function c37200277.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c37200277.condition)
	e1:SetCost(c37200277.cost)
	e1:SetTarget(c37200277.target)
	e1:SetOperation(c37200277.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37200277,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c37200277.sccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c37200277.sctg)
	e4:SetOperation(c37200277.scop)
	c:RegisterEffect(e4)
end
--filters
function c37200277.filter(c)
	return c:IsReleasable() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c37200277.chlimit(e,ep,tp)
	return tp==ep
end
function c37200277.scfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) and c:GetLevel()<=4 and c:IsAbleToHand()
end
--Activate
function c37200277.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and rp~=tp
end
function c37200277.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and g:FilterCount(c37200277.filter,nil)==g:GetCount() end
	Duel.Release(g,REASON_COST)
	local op=Duel.GetOperatedGroup()
	e:SetLabel(op:GetCount())
end
function c37200277.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=5-e:GetLabel()
	e:SetLabel(ct)
	if chk==0 then 
		if ct>=0 then
			return Duel.IsPlayerCanDraw(1-tp,ct)
		else
			return Duel.IsPlayerCanDraw(tp,1)
		end
	end
	local g=eg:Filter(Card.IsAbleToRemove,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c37200277.chlimit)
	end
end
function c37200277.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsAbleToRemove,nil)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	if e:GetLabel()>=0 then
		Duel.Draw(1-tp,e:GetLabel(),REASON_EFFECT)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--search
function c37200277.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c37200277.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c37200277.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c37200277.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c37200277.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end