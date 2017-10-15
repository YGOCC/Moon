--Digimon Gesomon
function c47000146.initial_effect(c)
--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c47000146.condition)
	e2:SetTarget(c47000146.target)
	e2:SetOperation(c47000146.activate)
	c:RegisterEffect(e2)
	--xyz limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c47000146.xyzlimit)
	c:RegisterEffect(e3)
--synchro limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetValue(c47000146.synlimit)
	c:RegisterEffect(e4)
	--special summon2
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(47000146,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,47000146)
	e6:SetCondition(c47000146.scon)
	e6:SetTarget(c47000146.settg2)
	e6:SetOperation(c47000146.setop2)
	c:RegisterEffect(e6)
end
function c47000146.cfilter(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function c47000146.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47000146.cfilter,tp,LOCATION_ONFIELD,0,1,nil,22702055) 
end
function c47000146.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47000146.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c47000146.xyzlimit(e,c)
	if not c then return false end
	return not c_IsSetCard(0x2FBA)
end
function c47000146.scon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_SZONE
end
function c47000146.filter3(c)
	return c:IsSetCard(0x2FBA) and c:IsType(TYPE_TRAP+TYPE_MONSTER) and not c:IsCode(47000146)
and c:IsSSetable()
end
function c47000146.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000146.filter3,tp,LOCATION_GRAVE,0,1,nil) end
end
function c47000146.setop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c47000146.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47000146.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2FBA)
end