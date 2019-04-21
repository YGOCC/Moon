--Neo Paintress Goghi
function c500314819.initial_effect(c)
   aux.AddOrigEvoluteType(c)
	c:EnableReviveLimit()
 aux.AddEvoluteProc(c,nil,8,c500314819.filter1,c500314819.filter2)
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCondition(c500314819.chcon)
	e1:SetTarget(c500314819.chtg)
	e1:SetCost(c500314819.chcost)
	e1:SetOperation(c500314819.chop)
	c:RegisterEffect(e1)
	 --atk down
	 local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c500314819.atktg)
	e2:SetValue(c500314819.val)
	c:RegisterEffect(e2)
	 --handes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetOperation(aux.chainreg)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(500314819,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c500314819.hdcon)
	e5:SetCost(c500314819.hdcost)
	e5:SetTarget(c500314819.hdtg)
	e5:SetOperation(c500314819.hdop)
	c:RegisterEffect(e5)
end

function c500314819.filter1(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c500314819.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY) or c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c500314819.filter(c)
	return  not c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c500314819.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_MONSTER) 
end
function c500314819.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
		Duel.IsExistingMatchingCard(c500314819.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c500314819.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c500314819.repop)
end
function c500314819.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c500314819.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(1-tp,c500314819.filter,tp,0,LOCATION_DECK,1,1,nil)
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	if tc1 then Duel.ConfirmCards(1-tp,tc1) end
	if tc2 then Duel.ConfirmCards(tp,tc2) end
end
function c500314819.atktg(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c500314819.val(e,c)
	 return Duel.GetMatchingGroupCount(c500314819.ctfilter,e:GetHandler():GetControler(),LOCATION_REMOVED,0,nil)*-100
end
function c500314819.ctfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function c500314819.hdcon(e,tp,eg,ep,ev,re,r,rp)
   return rp==1-tp and Duel.GetCurrentPhase()~=PHASE_DRAW and Duel.GetCurrentPhase()~=PHASE_DAMAGE and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(1)>0
end
function c500314819.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
	e:GetHandler():RemoveEC(tp,3,REASON_COST)
end
function c500314819.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function c500314819.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c500314819.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,5,REASON_COST) end
	e:GetHandler():RemoveEC(tp,5,REASON_COST)
end