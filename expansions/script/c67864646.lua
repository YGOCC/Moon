--VECTOR MECH General Z3-R0
--Scripted by Keddy, fixed by Zerry
function c67864646.initial_effect(c)
	--spsummon from hand
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c67864646.hspcon)
	e1:SetOperation(c67864646.hspop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864646,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,67864646)
	e2:SetCondition(c67864646.descon)
	e2:SetTarget(c67864646.destg)
	e2:SetOperation(c67864646.desop)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(678646456,2)) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,68964646)
	e4:SetCondition(c67864646.spcon)
	e4:SetTarget(c67864646.sptg)
	e4:SetOperation(c67864646.spop)
	c:RegisterEffect(e4)
end
function c67864646.hspfilter(c,ft,tp)
	return c:IsSetCard(0x2a6)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
end
function c67864646.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.CheckReleaseGroup(tp,c67864646.hspfilter,1,nil,ft,tp)
end
function c67864646.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.SelectReleaseGroup(tp,c67864646.hspfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c67864646.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xa2a6)
end
function c67864646.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c67864646.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c67864646.spcon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c67864646.spfilter(c,e,tp)
  return ((c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(6)) or c:IsSetCard(0x2a6)) and not c:IsCode(67864646) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864646.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c67864646.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c67864646.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67864646.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c67864645.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>=2 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local e4=Effect.CreateEffect(e:GetHandler())
				e4:SetType(EFFECT_TYPE_FIELD)
				e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
				e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e4:SetReset(RESET_PHASE+PHASE_END)
				e4:SetTargetRange(1,0)
				e4:SetTarget(c67864646.splimit)
				Duel.RegisterEffect(e4,tp)
	end
end
function c67864646.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x2a6) or (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)))
end	
	
end