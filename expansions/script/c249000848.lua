--Pendulumization Revival Art
function c249000848.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c249000848.condition)
	e1:SetTarget(c249000848.target)
	e1:SetOperation(c249000848.activate)
	c:RegisterEffect(e1)
end
function c249000848.confilter(c)
	return c:IsSetCard(0x1F8) and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_PZONE)) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function c249000848.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c249000848.ctfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>2
end
function c249000848.filter(c,e,tp)
	return (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_PENDULUM)
end
function c249000848.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c249000848.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000848.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000848.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000848.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
	if not tc:IsType(TYPE_PENDULUM) then
		Card.SetCardData(tc,CARDDATA_TYPE,tc:GetType()+TYPE_PENDULUM)
		Card.SetCardData(tc,CARDDATA_LSCALE,2)
 		Card.SetCardData(tc,CARDDATA_RSCALE,2)
 	end
 		if tc:IsType(TYPE_XYZ) then
 			local code=sc:GetOriginalCode()
			local scobject=_G["c" .. code]
			scobject.pendulum_level=sc:GetOriginalRank()
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_TOHAND)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCondition(c249000848.condition2)
			e1:SetTarget(c249000848.target2)
			e1:SetOperation(c249000848.operation2)
			tc:RegisterEffect(e1)
		end  
		aux.EnablePendulumAttribute(tc,false)
	end
end
function c249000848.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c249000848.tgfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c249000848.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c249000848.tgfilter2),tp,LOCATION_GRAVE,0,1,nil) end
end
function c249000848.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c249000848.tgfilter2),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg=g:Select(tp,1,1,nil)
		Duel.Overlay(e:GetHandler(),mg)
	end
end