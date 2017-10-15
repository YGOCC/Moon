--Digimon MegaSeadramon
function c47000153.initial_effect(c)
c:SetUniqueOnField(1,1,47000153)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x2FBA),1)
	c:EnableReviveLimit()
	--Extra attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(47000153,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCountLimit(1)
	e1:SetCondition(c47000153.atcon)
	e1:SetOperation(c47000153.atop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c47000153.atkcon)
	e2:SetOperation(c47000153.atkop)
	c:RegisterEffect(e2)
--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(47000153,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,31477025)
	e4:SetCost(c47000153.spcost)
	e4:SetTarget(c47000153.sptg)
	e4:SetOperation(c47000153.spop)
	c:RegisterEffect(e4)
--xyz limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(c47000153.xyzlimit)
	c:RegisterEffect(e6)
--synchro limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetValue(c47000153.synlimit)
	c:RegisterEffect(e7)
end
function c47000153.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsChainAttackable()
end
function c47000153.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
end
function c47000153.spellfilter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c47000153.atkcon(e)
	return Duel.IsExistingMatchingCard(c47000153.spellfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c47000153.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c47000153.acrestrict)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c47000153.acrestrict(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c47000153.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x2FBA) or c:IsRace(RACE_SEASERPENT)) and not c:IsCode(47000153)
end
function c47000153.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c47000153.cfilter,2,nil) end
	local g=Duel.SelectReleaseGroup(tp,c47000153.cfilter,2,1,nil)
	Duel.Release(g,REASON_COST)
end
function c47000153.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47000153.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c47000153.xyzlimit(e,c)
	if not c then return false end
	return not c_IsSetCard(0x2FBA)
end
function c47000153.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2FBA)
end
