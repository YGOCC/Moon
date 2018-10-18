--Quickshot (Extender Corona)
--Design and Code by Kinny
local ref=_G['c'..28916129]
local id=28916129
function ref.initial_effect(c)
	aux.EnableCorona(c,ref.matfilter,3,99,TYPE_TRAP,ref.refilter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(ref.acttg)
	e1:SetOperation(ref.actop)
	c:RegisterEffect(e1)
	
end
function ref.matfilter(e)
	return e:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsRace(RACE_PLANT)
end
function ref.refilter(ev)
	return Duel.CheckChainUniqueness()
end

--Activate
function ref.tfilter(c,att,e,tp)
	return c:IsSetCard(1854) and c:IsType(TYPE_FUSION) and (not c:IsAttribute(att)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function ref.filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_EXTRA)
		and Duel.IsExistingMatchingCard(ref.tfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function ref.chkfilter(c,att)
	return c:IsFaceup() and c:IsSetCard(1854) and c:IsAttribute(att)
end
function ref.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and ref.chkfilter(chkc,e:GetLabel()) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,ref.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetLabel(g:GetFirst():GetAttribute())
end
function ref.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local att=tc:GetAttribute()
	if not (Duel.GetLocationCountFromEx(tp,tp,c)>0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,ref.tfilter,tp,LOCATION_EXTRA,0,1,1,nil,att,e,tp)
	if sg:GetCount()>0 then
		sg:GetFirst():SetMaterial(Group.FromCards(tc))
		if Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)~=0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
end
