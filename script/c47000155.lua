--Digimon Aquan WaruSeadramon
function c47000155.initial_effect(c)
c:SetUniqueOnField(1,1,47000155)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
-- special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c47000155.spcon)
	e2:SetOperation(c47000155.spop)
	c:RegisterEffect(e2)
--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c47000155.pitg)
	c:RegisterEffect(e4)
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47000155,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCountLimit(1)
	e5:SetCondition(c47000155.setcon)
	e5:SetTarget(c47000155.settg)
	e5:SetOperation(c47000155.setop)
	c:RegisterEffect(e5)
--xyz limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(c47000155.xyzlimit)
	c:RegisterEffect(e6)
--synchro limit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e7:SetValue(c47000155.synlimit)
	c:RegisterEffect(e7)
end
function c47000155.costfilter(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)) and c:IsAbleToGraveAsCost() and not c:IsCode(47000155)  
end
function c47000155.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47000155.costfilter,tp,LOCATION_ONFIELD,0,1,c)
end
function c47000155.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c47000155.costfilter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c47000155.pitg(e,c)
	return c:IsSetCard(0x2FBA) or c:IsRace(RACE_SEASERPENT)
end
function c47000155.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c47000155.trapfilter(c)
	return c:IsSetCard(0x2FBA) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c47000155.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c47000155.trapfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47000155.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c47000155.trapfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c47000155.xyzlimit(e,c)
	if not c then return false end
	return not c_IsSetCard(0x2FBA)
end
function c47000155.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0x2FBA)
end
