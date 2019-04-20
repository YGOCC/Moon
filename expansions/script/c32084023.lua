--Orichalcos Bone Towers
function c32084023.initial_effect(c)
	c:EnableCounterPermit(0x94b)
	c:SetCounterLimit(0x94b,6)
		--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c32084023.target)
	e1:SetOperation(c32084023.activate)
	c:RegisterEffect(e1)
		--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c32084023.ctcon)
	e2:SetOperation(c32084023.ctop)
	c:RegisterEffect(e2)
		--Empty Hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32084023,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(c32084023.dcon)
	e3:SetTarget(c32084023.targe)
	e3:SetOperation(c32084023.activat)
	c:RegisterEffect(e3)
		--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(32084023,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCondition(c32084023.dco)
	e4:SetCountLimit(1)
	e4:SetTarget(c32084023.tar)
	e4:SetOperation(c32084023.oper)
	c:RegisterEffect(e4)
		--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(32084023,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetCondition(c32084023.dc)
	e5:SetCost(c32084023.cost)
	e5:SetCountLimit(1)
	e5:SetTarget(c32084023.ta)
	e5:SetOperation(c32084023.op)
	c:RegisterEffect(e5)
end
function c32084023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x94b)
end
function c32084023.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x94b,2)
		Duel.RaiseEvent(c,32084023,e,REASON_EFFECT,tp,tp,0x94b)
	end
end
function c32084023.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c32084023.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:AddCounter(0x94b,2)
	Duel.RaiseSingleEvent(c,32084023,e,0,0,tp,0)
end
function c32084023.dcon(e)
	return e:GetHandler():GetCounter(0x94b)>=2
end
function c32084023.targe(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)*200
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c32084023.activat(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		local dam=og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*200
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
function c32084023.dco(e)
	return e:GetHandler():GetCounter(0x94b)>=4
end
function c32084023.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c32084023.oper(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c32084023.dc(e)
	return e:GetHandler():GetCounter(0x94b)>=6
end
function c32084023.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_MONSTER)
end
function c32084023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c32084023.ta(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK) and c32084023.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c32084023.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c32084023.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c32084023.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end