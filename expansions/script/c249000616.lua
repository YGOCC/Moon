--Overlay-Evolve Summoner Mage
function c249000616.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--xyz level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c249000616.xyztg)
	e2:SetOperation(c249000616.xyzop)
	c:RegisterEffect(e2)
	--synchro
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCondition(c249000616.condition)
	e3:SetCost(c249000616.cost)
	e3:SetTarget(c249000616.target)
	e3:SetOperation(c249000616.operation)
	c:RegisterEffect(e3)	
	--scale
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LSCALE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c249000616.slcon)
	e4:SetValue(6)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e5)
end
function c249000616.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c249000616.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c249000616.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000616.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c249000616.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c249000616.xyzop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(c249000616.xyzlv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c249000616.xyzlv(e,c,rc)
	return c:GetRank()
end
function c249000616.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c249000616.tfilter(c,lv,rc,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(rc) and c:IsLevelBelow(10) and (c:GetLevel()==lv or c:GetLevel()==lv-1)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c249000616.filter(c,e,tp)
	return c:IsFaceup() and c:GetLevel()>0
		and Duel.IsExistingMatchingCard(c249000616.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetLevel()*2,c:GetRace(),e,tp)
end
function c249000616.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c249000616.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000616.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000616.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if (not tc:IsRelateToEffect(e)) or tc:IsFacedown() then return end
	local lv=tc:GetLevel()*2
	local rc=tc:GetRace()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c249000616.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,lv,rc,e,tp)
	if sg:GetCount()>0 then
		Duel.BreakEffect()
		local sc=sg:GetFirst()
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e1,true)
		end
	end
end
function c249000616.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c249000616.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
end
function c249000616.slfilter(c)
	return c:IsSetCard(0x1D8)
end
function c249000616.slcon(e)
	return not Duel.IsExistingMatchingCard(c249000616.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end