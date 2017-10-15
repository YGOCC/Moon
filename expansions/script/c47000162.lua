--Digimon Dark Master MetalSeadramon
function c47000162.initial_effect(c)
c:SetUniqueOnField(1,1,47000162)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x2FBA),1)
	c:EnableReviveLimit()
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c47000162.atkval2)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c47000162.atkop)
	c:RegisterEffect(e2)
	--Multiple Attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetValue(c47000162.atkval)
	c:RegisterEffect(e3)
--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000162,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,31477026)
	e4:SetCost(c47000162.spcost)
	e4:SetTarget(c47000162.sptg)
	e4:SetOperation(c47000162.spop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c47000162.descon)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--xyz limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(c47000162.xyzlimit)
	c:RegisterEffect(e6)
--synchro limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetValue(c47000162.synlimit)
	c:RegisterEffect(e7)
end
function c47000162.atkfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c47000162.atkval2(e,c)
	return Duel.GetMatchingGroupCount(c47000162.atkfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*200
end
function c47000162.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c47000162.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e5,tp)
end
function c47000162.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c47000162.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c47000162.atkval(e,c)
	return Duel.GetMatchingGroupCount(c47000162.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)-1
end
function c47000162.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x2FBA) or c:IsRace(RACE_SEASERPENT)) and not c:IsCode(47000162)
end
function c47000162.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47000162.cfilter,3,nil) end
	local g=Duel.SelectReleaseGroup(tp,c47000162.cfilter,3,1,nil)
	Duel.Release(g,REASON_COST)
end
function c47000162.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47000162.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c47000162.umifilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c47000162.descon(e)
	return Duel.IsExistingMatchingCard(c47000162.umifilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c47000162.xyzlimit(e,c)
	if not c then return false end
	return not c_IsSetCard(0x2FBA)
end
function c47000162.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2FBA)
end