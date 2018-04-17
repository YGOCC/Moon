--Pendulumization Summoner
function c249000849.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(c249000849.condition)
	e1:SetCost(c249000849.cost)
	e1:SetTarget(c249000849.target)
	e1:SetOperation(c249000849.operation)
	c:RegisterEffect(e1)
end
function c249000849.confilter(c)
	return c:IsSetCard(0x1F8) and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_PZONE)) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000849.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000849.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end
function c249000849.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c249000849.tfilter(c,rc,att,e,tp,lvrk)
	return c:IsRace(rc) and c:IsAttribute(att) and
	((c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and ((c:GetLevel() == lvrk) or (c:GetLevel() == lvrk+1)))
	or (c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and ((c:GetRank() == lvrk) or (c:GetRank() == lvrk+1))))
end
function c249000849.filter(c,e,tp)
	local lvrk
	if c:GetLevel() > c:GetRank() then lvrk = c:GetLevel() else lvrk = c:GetRank() end
	return lvrk > 2 and c:IsFaceup()
	and Duel.IsExistingMatchingCard(c249000849.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetOriginalRace(),c:GetOriginalAttribute(),e,tp,lvrk)
	and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c249000849.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler() 
	if chk==0 then return Duel.IsExistingTarget(c249000849.filter,tp,LOCATION_MZONE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c249000849.filter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
end
function c249000849.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local rc=tc:GetRace()
	local att=tc:GetOriginalAttribute()
	local lvrk
	if tc:GetLevel() > tc:GetRank() then lvrk = tc:GetLevel() else lvrk = tc:GetRank() end
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c249000849.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,rc,att,e,tp,lvrk):GetFirst()
	if not sc then return end
	if sc:IsType(TYPE_XYZ) then
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		local tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
		Duel.Overlay(sc,tc2)
		end
		tc2=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
		if tc2 then
			Duel.Overlay(sc,tc2)
		end
		sc:CompleteProcedure()
	else
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()	
	end
	if not sc:IsType(TYPE_PENDULUM) then
		Card.SetCardData(sc,CARDDATA_TYPE,sc:GetType()+TYPE_PENDULUM)
		Card.SetCardData(sc,CARDDATA_LSCALE,2)
 		Card.SetCardData(sc,CARDDATA_RSCALE,2)
 	end
 	if sc:IsType(TYPE_XYZ) then
 		local code=sc:GetOriginalCode()
		local scobject=_G["c" .. code]
		scobject.pendulum_level=sc:GetOriginalRank()
		local e1=Effect.CreateEffect(sc)
		e1:SetCategory(CATEGORY_TOHAND)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCondition(c249000849.condition2)
		e1:SetTarget(c249000849.target2)
		e1:SetOperation(c249000849.operation2)
		sc:RegisterEffect(e1)
	end  
	aux.EnablePendulumAttribute(sc,false)
end
function c249000849.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c249000849.tgfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c249000849.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c249000849.tgfilter2),tp,LOCATION_GRAVE,0,1,nil) end
end
function c249000849.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c249000849.tgfilter2),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=g:Select(tp,1,1,nil)
		Duel.Overlay(e:GetHandler(),mg)
	end
end