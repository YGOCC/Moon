--Heterochromic Neo Tuner
function c249000437.initial_effect(c)
	--Synchro monster, 1 tuner + n or more monsters
	function aux.AddSynchroProcedure(c,f1,f2,ct)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f1 then
			mt.tuner_filter=function(mc) return mc and f1(mc) end
		else
			mt.tuner_filter=function(mc) return true end
		end
		if f2 then
			mt.nontuner_filter=function(mc) return mc and f2(mc) end
		else
			mt.nontuner_filter=function(mc) return true end
		end
		mt.minntct=ct
		mt.maxntct=99
		mt.sync=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.SynCondition(f1,f2,ct,99))
		e1:SetTarget(Auxiliary.SynTarget(f1,f2,ct,99))
		e1:SetOperation(Auxiliary.SynOperation(f1,f2,ct,99))
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
	--Synchro monster, 1 tuner + 1 monster
	function Auxiliary.AddSynchroProcedure2(c,f1,f2)
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		if f1 then
			mt.tuner_filter=function(mc) return mc and f1(mc) end
		else
			mt.tuner_filter=function(mc) return true end
		end
		if f2 then
			mt.nontuner_filter=function(mc) return mc and f2(mc) end
		else
			mt.nontuner_filter=function(mc) return true end
		end
		mt.minntct=1
		mt.maxntct=1
		mt.sync=true
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_EXTRA)
		e1:SetCondition(Auxiliary.SynCondition(f1,f2,1,1))
		e1:SetTarget(Auxiliary.SynTarget(f1,f2,1,1))
		e1:SetOperation(Auxiliary.SynOperation(f1,f2,1,1))
		e1:SetValue(SUMMON_TYPE_SYNCHRO)
		c:RegisterEffect(e1)
	end
	
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89326990,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,249000437)
	e1:SetCondition(aux.exccon)
	e1:SetCost(c249000437.cost)
	e1:SetTarget(c249000437.target)
	e1:SetOperation(c249000437.operation)
	c:RegisterEffect(e1)
	--synchro limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)
end
function c249000437.costfilter(c)
	return c:IsSetCard(0x1BE) and c:IsDiscardable() and not c:IsCode(249000437)
end
function c249000437.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000437.costfilter,tp,LOCATION_HAND,0,1,nil) end
	if Duel.GetLP(tp) < 2000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,2000)
	end
	Duel.DiscardHand(tp,c249000437.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c249000437.matfilter(c,lv,syncard,mclv)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:GetSynchroLevel(syncard)==lv-mclv and c:IsNotTuner() and c:IsAbleToRemove() 
		and mt.nontuner_filter and mt.nontuner_filter(c)
end
function c249000437.filter(c,e,tp,mc)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local mclv=mc:GetSynchroLevel(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false)
		and Duel.IsExistingMatchingCard(c249000437.matfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetLevel(),c,mclv) 
		and mt.sync and mt.minntct and mt.minntct==1 and mt.tuner_filter and mt.tuner_filter(mc)
end
function c249000437.tgfilter(c)
	return c:IsNotTuner() and c:IsAbleToRemove()
end
function c249000437.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsAbleToRemove() 
	--	and Duel.IsExistingMatchingCard(c249000437.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
		and Duel.IsExistingMatchingCard(c249000437.tgfilter,tp,LOCATION_GRAVE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000437.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ac=Duel.AnnounceCard(tp)
	local tc=Duel.CreateToken(tp,ac)
	while not c249000437.filter(tc,e,tp,c)
	do
		ac=Duel.AnnounceCard(tp)
		tc=Duel.CreateToken(tp,ac)
		if tc:IsType(TYPE_TRAP) then return end
	end
--	local g=Duel.GetMatchingGroup(c249000437.filter,tp,LOCATION_EXTRA,0,nil,e,tp,c)
--		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--		local tc=g:Select(tp,1,1,nil):GetFirst()
	local code=tc:GetOriginalCode()
	local mt=_G["c" .. code]
	local mclv=c:GetSynchroLevel(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local mat=Duel.SelectMatchingCard(tp,c249000437.matfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc:GetLevel(),tc,mclv)
	mat:AddCard(c)
	tc:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
	Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
	tc:CompleteProcedure()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	tc:RegisterEffect(e2,true)
end
