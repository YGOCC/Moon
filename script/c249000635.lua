--Space Time Breakdown
function c249000635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000635.con)
	e1:SetOperation(c249000635.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c249000635.condition)
	e2:SetCost(c249000635.cost)
	e2:SetTarget(c249000635.target)
	e2:SetOperation(c249000635.operation)
	c:RegisterEffect(e2)
end
function c249000635.filter(c)
	return c:GetCode()==249000634 and c:IsFaceup()
end
function c249000635.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000635.filter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c249000635.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.SelectOption(tp,22,24,aux.Stringid(249000635,1))
	local code=nil
	if op==0 then
		code=EFFECT_SKIP_M1
	elseif op==1 then
		code=EFFECT_SKIP_BP
	elseif op==2 then	 
		code=EFFECT_SKIP_M2
	end	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(code)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c249000635.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000635.costfilter(c)
	return c:IsSetCard(0x1B7) and c:IsAbleToRemoveAsCost()
end
function c249000635.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c249000635.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c249000635.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000635.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function c249000635.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000635.xyzfilter,tp,LOCATION_EXTRA,0,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000635.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000635.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	local option
	if g:GetCount() > 0  then option=0 end
	if g2:GetCount() > 0  then option=1 end
	if g:GetCount()>0 
	and g2:GetCount()>0 then
		option=Duel.SelectOption(tp,1063,1073)
	end
	if option==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end