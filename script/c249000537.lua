--Synchro-Converter Cosmic Sage
function c249000537.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--tuner summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,249000538)
	e2:SetTarget(c249000537.ptg)
	e2:SetOperation(c249000537.pop)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,249000537)
	e4:SetCondition(c249000537.condition)
	e4:SetCost(c249000537.cost)
	e4:SetOperation(c249000537.operation)
	c:RegisterEffect(e4)
end
function c249000537.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_TUNER) and c:IsLevelBelow(4)
end
function c249000537.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000537.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c249000537.pop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsExistingMatchingCard(c249000537.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c249000537.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
	end
end
function c249000537.confilter(c,e)
	return c:IsSetCard(0x1CA) and not c:IsCode(e:GetHandler():GetCode())  and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVEYARD))
end
function c249000537.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c249000537.confilter,tp,LOCATION_EXTRA+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,e)
end
function c249000537.costfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()
end
function c249000537.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000537.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000537.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c249000537.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c249000537.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local lv=e:GetLabelObject():GetLevel()
	local att=e:GetLabelObject():GetAttribute()
	local race=e:GetLabelObject():GetRace()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	ac=Duel.AnnounceCard(tp)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_SYNCHRO) and sc:GetLevel() and  math.abs(lv - sc:GetLevel()) <= 2 and sc:IsRace(race)
	and sc:IsAttribute(att) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and sc:GetCode()~=e:GetLabelObject():GetCode())
	do
		ac=Duel.AnnounceCard(tp)
		sc=Duel.CreateToken(tp,ac)
		if sc:IsType(TYPE_TRAP) then return end
	end
	if sc then
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
