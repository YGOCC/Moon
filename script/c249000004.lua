--Xyz-Hunter
function c249000004.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41077745,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c249000004.datcon)
	e1:SetCost(c249000004.datcost)
	e1:SetOperation(c249000004.datop)
	c:RegisterEffect(e1)
	--bury xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c249000004.tgcondition)
	e2:SetTarget(c249000004.tgtarget)
	e2:SetOperation(c249000004.tgoperation)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,249000004)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c249000004.cost)
	e3:SetOperation(c249000004.operation)
	c:RegisterEffect(e3)
end
function c249000004.datcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c249000004.cfilter1(c)
	return not c:IsPublic() and c:IsType(TYPE_SPELL)
end
function c249000004.datcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000004.cfilter1,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetMatchingGroup(c249000004.cfilter1,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local sg=g:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleHand(tp)
end
function c249000004.datop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c249000004.tgcondition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c249000004.tgtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c249000004.tgoperation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_EXTRA,nil,TYPE_XYZ)
	Duel.ConfirmCards(tp,tg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=tg:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c249000004.cfilter2(c)
	return c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c249000004.cfilter3(c)
	return c:IsSetCard(0x73) and c:IsAbleToRemoveAsCost() and not c:IsCode(249000004)
end
function c249000004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000004.cfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(c249000004.cfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c249000004.cfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	e:SetLabel(g1:GetFirst():GetRank())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c249000004.cfilter3,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c249000004.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local rk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	ac=Duel.AnnounceCard(tp)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_XYZ) and sc:GetRank() == rk and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false))
	do
		ac=Duel.AnnounceCard(tp)
		sc=Duel.CreateToken(tp,ac)
		if sc:IsType(TYPE_TRAP) then return end
	end
	Duel.Remove(sc,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoDeck(sc,nil,0,REASON_RULE)
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(sc,tc2)
		end
		tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(sc,tc2)
		end
		sc:CompleteProcedure()
	end
end