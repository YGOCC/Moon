--Number 300: Galaxy-Eyes Photonic Tachyon Dragon
--Scripted by Loli Dragon of Creativity
local card = c88881010
local m=88881010
local cm=_G["c"..m]
cm.dfc_front_side=m-1000
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function card.initial_effect(c)
  --Xyz Materials
  aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x889),4,2)
  c:EnableReviveLimit()
  --(1) This card cannot be destroyed in battle while it has material.
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
  e1:SetCondition(card.indescon)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  --(2) Once per turn, if this card battles, you can detach 1 material: destroy all cards in your Pendulum Zones and if you do, this card gains 200 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect, but at the end of the damage step half the gained ATK.
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(88881010,0))
  e2:SetCategory(CATEGORY_DESTROY)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_CONFIRM)
  e2:SetCost(card.atkcost)
  e2:SetTarget(card.atktg)
  e2:SetOperation(card.atkop)
  c:RegisterEffect(e2)
  local exx=Effect.CreateEffect(c)
  exx:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
  exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  exx:SetCode(EVENT_DAMAGE_STEP_END)
  exx:SetRange(LOCATION_MZONE)
  exx:SetCondition(card.artcon)
  exx:SetOperation(card.artop)
  c:RegisterEffect(exx)
  --(3) When this card destroys a monster by battle: deal damage equal to half the destroyed monsters ATK.
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(88881010,1))
  e3:SetCategory(CATEGORY_DAMAGE)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e3:SetCode(EVENT_BATTLE_DESTROYING)
  e3:SetCondition(card.damcon)
  e3:SetTarget(card.damtg)
  e3:SetOperation(card.damop)
  c:RegisterEffect(e3)
end
card.xyz_number=300
--(1) This card cannot be destroyed in battle while it has material.
function card.indescon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetOverlayCount()>0
end
--(2) Once per turn, if this card battles, you can detach 1 material: destroy all cards in your Pendulum Zones and if you do, this card gains 200 ATK equal to the combined Levels/Ranks of all cards destroyed by this effect, but at the end of the damage step half the gained ATK.
function card.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function card.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_PZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function card.atkop(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_PZONE,0,nil)
  Duel.Destroy(sg,REASON_EFFECT)
  local c=e:GetHandler()
  local tc=sg:GetSum(Card.GetLevel)*100 or sg:GetSum(Card.GetRank)*100
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
	local exx=Effect.CreateEffect(c)
	exx:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	exx:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	exx:SetCode(EVENT_ADJUST+EVENT_DAMAGE_STEP_END)
	exx:SetRange(LOCATION_MZONE)
	exx:SetCondition(card.artcon)
	exx:SetOperation(card.artop)
	c:RegisterEffect(exx)
  end
end
function card.artcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetOriginalCode()==m or c:GetOriginalCode()==cm.dfc_front_side)
end
function card.artop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Senya.TransformDFCCard(c)
end
--(3)
function card.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function card.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function card.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()/2
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
