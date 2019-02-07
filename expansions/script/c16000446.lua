--Paintress EX Dark Witch Matissa
function c16000446.initial_effect(c)
	 --link summon
   aux.AddLinkProcedure(c,nil,2,2,c16000446.lcheck)
	c:EnableReviveLimit()
	  --duel status
 --   local e1=Effect.CreateEffect(c)
 --   e1:SetType(EFFECT_TYPE_FIELD)
 --   e1:SetRange(LOCATION_MZONE)
 ---   e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
 --   e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
 --   e1:SetCode(EFFECT_DUAL_STATUS)
   -- c:RegisterEffect(e1)
		  --indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c16000446.tgtg)
	e3:SetValue(c16000446.indval)
	c:RegisterEffect(e3)
				--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c16000446.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4) 
	--race
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_REMOVED+LOCATION_HAND,0)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_DUAL))
	e5:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e5) 
	 --triple nsum
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(16000446,0))
	e6:SetCategory(CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c16000446.nscost)
	e6:SetTarget(c16000446.nstg)
	e6:SetOperation(c16000446.nsop)
	c:RegisterEffect(e6)
end
--filters
function c16000446.cfilter(c)
	return c:IsFaceup() and not c:IsType(TYPE_EFFECT) and c:IsAbleToRemoveAsCost()
end
function c16000446.sumfilter(c)
	return c:IsType(TYPE_NORMAL+TYPE_DUAL) and c:IsSummonable(true,nil)
end
function c16000446.sumfilterchk(c)
	return c:IsSummonable(true,nil)
end
--
function c16000446.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xc50)
end
function c16000446.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c16000446.tgtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)
end
--triple nsum
function c16000446.nscost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.IsExistingMatchingCard(c16000446.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.PayLPCost(tp,1000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16000446.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c16000446.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16000446.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c16000446.nsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND,0,nil,TYPE_NORMAL+TYPE_DUAL)
	local sg=g:Filter(c16000446.sumfilterchk,nil)
	sg:KeepAlive()
	local check=true
	local maxct=0
	while check do
		if maxct>0 then
			if not Duel.SelectYesNo(tp,aux.Stringid(16000446,1)) then
				check=false
				break
			end
		end
		local cg=sg:Clone()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=cg:Select(tp,1,1,nil)
		local tcg=tc:GetFirst()
		sg:Sub(tc)
		Duel.Summon(tp,tcg,true,nil)
		maxct=maxct+1
		if maxct>=3 then
			
			check=false
			break
		end
		for i in aux.Next(cg) do
			if i:IsLocation(LOCATION_HAND) and not i:IsSummonable(true,nil) then
				sg:RemoveCard(i)
			end
		end
		if sg:GetCount()<=0 then
			check=false
			break
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16000446.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c16000446.splimit(e,c)
	return not c:IsSetCard(0xc50) and c:IsLocation(LOCATION_EXTRA)
end

