--Number C300: CREATION-Eyes Prime Dimensional Dragon
function c88880011.initial_effect(c)
  --xyz summon
  c:EnableReviveLimit()
  --(1)cannot special summon
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_SPSUMMON_CONDITION)
  e1:SetValue(c88880011.splimit)
  c:RegisterEffect(e1)
  --(2) This card cannot be destroyed in battle while it has material.
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e2:SetCondition(c88880011.indescon)
  e2:SetValue(1)
  c:RegisterEffect(e2)
  --(3) If this card battles, you can detach 1 material: destroy all cards in the pendulum scales and if you do, this card gains 300 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect.
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(88880011,0))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_BATTLE_CONFIRM)
  e3:SetCost(c88880011.atkcost)
  e3:SetTarget(c88880011.atktg)
  e3:SetOperation(c88880011.atkop)
  c:RegisterEffect(e3)
  --(4) When this card destroys a monster by battle: deal damage equal to the destroyed monsters ATK.
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(88880011,1))
  e4:SetCategory(CATEGORY_DAMAGE)
  e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e4:SetCode(EVENT_BATTLE_DESTROYING)
  e4:SetCondition(c88880011.damcon)
  e4:SetTarget(c88880011.damtg)
  e4:SetOperation(c88880011.damop)
  c:RegisterEffect(e4)
end
c88880011.xyz_number=300
--(1) This card can only be Xyz Summoned by the effect of a "Rank-Up-Magic" spell card or by the effect of a "CREATION" Pendulum monster.
function c88880011.splimit(e,se,sp,st)
	return (se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)) or (se:GetHandler():IsSetCard(0x889) and (se:GetHandler():IsType(TYPE_SPELL) or se:GetHandler():IsType(TYPE_MONSTER)) and se:GetHandler():IsType(TYPE_PENDULUM))
end
--(2) This card cannot be destroyed in battle while it has material.
function c88880011.indescon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayCount()>0
end
--(3) Once per turn, if this card battles, you can detach 1 material: destroy all cards in your Pendulum Zones and if you do, this card gains 250 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect, but at the end of the damage step half the gained ATK.
function c88880011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880011.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c88880011.atkop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,LOCATION_PZONE,nil)
  Duel.Destroy(sg,REASON_EFFECT)
  local c=e:GetHandler()
  local tc=sg:GetSum(Card.GetLevel)*250 or sg:GetSum(Card.GetRank)*250
  if c:IsRelateToEffect(e) and c:IsFaceup() then
	local atk=tc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk/2)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e2:SetValue(atk/2)
	c:RegisterEffect(e2)
  end
end
--(4) When this card destroys a monster by battle: deal damage equal to the destroyed monsters ATK.
function c88880011.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c88880011.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c88880011.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end