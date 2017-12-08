--Paintress Amersterdima
function c160009999.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c160009999.splimit)
	e2:SetCondition(c160009999.splimcon)
	c:RegisterEffect(e2)
	--actlimit
--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160009999,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,160009999)
	e4:SetCondition(c160009999.thcon)
	e4:SetCost(c160009999.cost)
	e4:SetTarget(c160009999.target)
	e4:SetOperation(c160009999.operation)
	c:RegisterEffect(e4)
end
function c160009999.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc50) or c:IsType(TYPE_NORMAL) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c160009999.splimcon(e)
	return not e:GetHandler():IsForbidden()
end

function c160009999.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return Duel.IsExistingMatchingCard(c160007854.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c160007854.costfilter,tp,LOCATION_SZONE,0,nil)
	Duel.Release(g,REASON_COST)
end

function c160007854.costfilter(c)
	return  c:IsSetCard(0xc50) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

function c160009999.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0xc50)
end

function c160009999.filter(c,e,tp)
	return (c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c160009999.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c160009999.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c160009999.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c160009999.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c160009999.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(aux.indoval)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
