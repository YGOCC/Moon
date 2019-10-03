--VECTOR Mech Emperor MS8-Z1
--Scripted by Keddy, updated by Zerry
function c67864648.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c67864648.hspcon)
	e1:SetOperation(c67864648.hspop)
	c:RegisterEffect(e1)
	--mill
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67864648,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,67864648)
	e2:SetCondition(c67864648.tgcon)
	e2:SetTarget(c67864648.tgtg)
	e2:SetOperation(c67864648.tgop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67864648,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,67964648)
	e3:SetCondition(c67864648.spcon)
	e3:SetTarget(c67864648.sptg)
	e3:SetOperation(c67864648.spop)
	c:RegisterEffect(e3)
end
function c67864648.rfilter(c,tp)
	return c:IsSetCard(0x2a6) and (c:IsControler(tp) or c:IsFaceup())
end
function c67864648.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c67864648.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c67864648.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c67864648.mzfilter,ct,nil,tp))
end
function c67864648.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c67864648.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,2,2,nil)
	elseif ft==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c67864648.mzfilter,1,1,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,1,1,g:GetFirst())
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c67864648.mzfilter,2,2,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end
function c67864648.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xa2a6)
end
function c67864648.tgfilter(c)
	return c:IsRace(RACE_MACHINE) or c:IsSetCard(0x2a6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c67864648.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67864648.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c67864648.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c67864648.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c67864648.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsFacedown()
end
function c67864648.spfilter(c,e,tp)
  return ((c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(6)) or c:IsSetCard(0x2a6)) and not c:IsCode(67864648) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67864648.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c67864648.spfilter,tp,LOCATION_GRAVE,0,2,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c67864648.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c67864648.spfilter,tp,LOCATION_GRAVE,0,2,2,e:GetHandler(),e,tp)
	if g:GetCount()>=2 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e5=Effect.CreateEffect(e:GetHandler())
				e5:SetType(EFFECT_TYPE_FIELD)
				e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)	
				e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e5:SetReset(RESET_PHASE+PHASE_END)
				e5:SetTargetRange(1,0)
				e5:SetTarget(c67864646.splimit)
				Duel.RegisterEffect(e5,tp)
	end
end
function c67864648.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0x2a6) or (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)))
end	