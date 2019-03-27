--Number 300: Galaxy-Eyes Photonic Tachyon Dragon
--Scripted by Loli Dragon of Creativity
function c88880010.initial_effect(c)
  --Xyz Materials
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),4,2)
  c:EnableReviveLimit()
  --(1) This card cannot be destroyed in battle while it has material.
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetCondition(c88880010.indescon)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --(2) Once per turn, if this card battles, you can detach 1 material: destroy all cards in your Pendulum Zones and if you do, this card gains 200 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect, but at the end of the damage step half the gained ATK.
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(88880010,0))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_CONFIRM)
  e2:SetCost(c88880010.atkcost)
  e2:SetTarget(c88880010.atktg)
  e2:SetOperation(c88880010.atkop)
  c:RegisterEffect(e2)
  --(3) When this card destroys a monster by battle: deal damage equal to half the destroyed monsters ATK.
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(88880010,1))
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetCondition(c88880010.damcon)
  e3:SetTarget(c88880010.damtg)
  e3:SetOperation(c88880010.damop)
  c:RegisterEffect(e3)
end
c88880010.xyz_number=300
--(1) This card cannot be destroyed in battle while it has material.
function c88880010.indescon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayCount()>0
end
--(2) Once per turn, if this card battles, you can detach 1 material: destroy all cards in your Pendulum Zones and if you do, this card gains 200 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect, but at the end of the damage step half the gained ATK.
function c88880010.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c88880010.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c88880010.atkop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil)
  Duel.Destroy(sg,REASON_EFFECT)
  local c=e:GetHandler()
  local tc=sg:GetSum(Card.GetLevel)*200 or sg:GetSum(Card.GetRank)*200
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
--(3)
function c88880010.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c88880010.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c88880010.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()/2
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
