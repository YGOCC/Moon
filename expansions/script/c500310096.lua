--Unfinished Power Potrait
function c500310096.initial_effect(c)
	c:EnableCounterPermit(0x1075)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c500310096.cost)
	e1:SetTarget(c500310096.target1)
	e1:SetOperation(c500310096.activate1)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(500310096,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
   -- e2:SetCondition(c500310096.condition2)
	e2:SetCost(c500310096.cost2)
	e2:SetTarget(c500310096.target2)
	e2:SetOperation(c500310096.activate2)
	c:RegisterEffect(e2)
		--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetCondition(c500310096.ctcon2)
	e3:SetOperation(c500310096.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	 local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function c500310096.cfilter(c)
	return  c:IsFaceup() and c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsAbleToRemoveAsCost()
end
function c500310096.filter(c)
	return c:IsType(TYPE_NORMAL) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function c500310096.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	if tn~=tp or (ph~=PHASE_MAIN1 and ph~=PHASE_MAIN2) then return false end
	if not Duel.IsExistingMatchingCard(c500310096.cfilter,tp,LOCATION_EXTRA,0,1,nil) and not Duel.CheckLPCost(tp,500) then return false end
	if Duel.IsExistingMatchingCard(c500310096.filter,tp,LOCATION_HAND,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(500310096,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c500310096.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	 Duel.PayLPCost(tp,500)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	   
		e:SetLabel(1)
	end
end
function c500310096.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetLabel()~=1 then return end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c500310096.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()~=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c500310096.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil) 
			or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
			Duel.Summon(tp,tc,true,nil)
		else Duel.MSet(tp,tc,true,nil) end
	end
end
function c500310096.condition2(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c500310096.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500310096.cfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.CheckLPCost(tp,500) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500310096.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)

	Duel.PayLPCost(tp,500)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c500310096.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500310096.cfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.CheckLPCost(tp,500) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c500310096.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)

	Duel.PayLPCost(tp,500)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c500310096.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not e:GetHandler():IsStatus(STATUS_CHAINING) then
			local ct=Duel.GetMatchingGroupCount(c500310096.filter,tp,LOCATION_HAND,0,nil)
			e:SetLabel(ct)
			return ct>0
		else return e:GetLabel()>0 end
	end
	e:SetLabel(e:GetLabel()-1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c500310096.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c500310096.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end
function c500310096.cfilter2(c)
	return  c:IsSetCard(0xc50) or not c:IsType(TYPE_EFFECT) 
end
function c500310096.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500310096.cfilter2,1,nil)
end
function c500310096.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	for i=1,7 do
		tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and bit.band(tc:GetType(),0x21)==0x21 and not tc:IsSetCard(0xc50) then
			tc:AddCounter(0x1075,1)
		end
	end
	for i=1,7 do
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,i-1)
		if tc and tc:IsCanAddCounter(0x1075,1) and bit.band(tc:GetType(),0x21)==0x21 and not tc:IsSetCard(0xc50) then
		   if  tc:AddCounter(0x1075,1) ~=0 then
		local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c500310096.distg)
		e1:SetLabel(tc:GetOriginalCode())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c500310096.discon)
		e2:SetOperation(c500310096.disop)
		e2:SetLabel(tc:GetOriginalCode())
		--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e2,tp)
		end
	end
end
end

function c500310096.disfilter(c)
	return c:IsFaceup() and c:GetCounter(0x1075)>0  and not c:IsSetCard(0xc50) and not c:IsType(TYPE_EVOLUTE)
end

function c500310096.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code and (c:IsFaceup() and c:GetCounter(0x1075)>0  and not c:IsSetCard(0xc50) and not c:IsType(TYPE_EVOLUTE))
end
function c500310096.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_MONSTER) and (code1==code or code2==code) and  c500310096.disfilter(re:GetHandler())
end
function c500310096.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
