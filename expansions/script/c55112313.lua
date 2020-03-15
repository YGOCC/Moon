--created by Meedogh, coded by Meedogh & Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(cid.eqatkcon)
	e4:SetValue(cid.eqval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e6:SetCondition(cid.rdcon)
	e6:SetOperation(cid.rdop)
	c:RegisterEffect(e6)
end
function cid.eqatkcon(e) 
	local ec=e:GetHandler():GetEquipTarget()
	return ec and ec:IsRace(RACE_DRAGON) and ec:IsType(TYPE_BIGBANG) 
end
function cid.eqval(e,c) 
	return e:GetHandler():GetEquipTarget():GetEquipGroup():FilterCount(cid.atkfilter,nil)*500 
end
function cid.atkfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function cid.filter(c,e,tp)
	return (c:IsCode(52471658) or c:IsCode(54900205) or c:IsCode(40444917)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c=e:GetHandler()
	local op=0
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	if not c:IsAttackAbove(500) then op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
		else op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)) end
		e:SetLabel(op)
		local prev=c:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		if e:GetLabel()==0 then
			e1:SetValue(500)
		else e1:SetValue(-500) end
		c:RegisterEffect(e1)
		if math.abs(prev-c:GetAttack())==500 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetTarget(cid.splimit)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cid.splimit(e,c)
	return not c:IsType(TYPE_BIGBANG) and c:IsLocation(LOCATION_EXTRA)
end
function cid.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ep~=tp and ec and (Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec)
end
function cid.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
