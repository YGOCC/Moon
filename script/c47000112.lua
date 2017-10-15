--Digimon Turuiemon
function c47000112.initial_effect(c)
--Attribute Dark
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
--Type Fiend
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47000112,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c47000112.spcon)
	e3:SetCountLimit(1,47000112)
	e3:SetTarget(c47000112.sptg)
	e3:SetOperation(c47000112.spop)
	c:RegisterEffect(e3)
--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c47000112.atcon)
	e4:SetValue(600)
	c:RegisterEffect(e4)
--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47000112,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c47000112.spcost2)
	e5:SetTarget(c47000112.sptg2)
	e5:SetOperation(c47000112.spop2)
	c:RegisterEffect(e5)
--xyz limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(c47000112.xyzlimit)
	c:RegisterEffect(e6)
--synchro limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetValue(c47000112.synlimit)
	c:RegisterEffect(e7)
end
function c47000112.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and (c:IsSetCard(0x3FB) or c:IsSetCard(0x6E7))
end
function c47000112.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c47000112.cfilter,1,nil,tp)
end
function c47000112.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47000112.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c47000112.atcon(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker()
end
function c47000112.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and Duel.CheckReleaseGroup(tp,nil,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectReleaseGroup(tp,nil,1,1,c)
	rg:AddCard(c)
	Duel.Release(rg,REASON_COST)
end
function c47000112.filter2(c,e,tp)
	return c:IsCode(47000113) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47000112.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c47000112.filter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c47000112.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47000112.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47000112.xyzlimit(e,c)
	if not c then return false end
	return not (c:IsSetCard(0x3FB) or c_IsSetCard(0x6E7)) 
end
function c47000112.synlimit(e,c)
	if not c then return false end
	return not (c:IsSetCard(0x3FB) or c_IsSetCard(0x6E7)) 
end
