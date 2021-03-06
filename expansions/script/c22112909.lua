--created by Geass, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cid.ffilter,2,63,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cid.sucop)
	c:RegisterEffect(e3)
end
function cid.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x88a) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function cid.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x88a)*300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetCondition(function() return c:GetMaterialCount()>1 end)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e3=e4:Clone()
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(function() return c:GetMaterialCount()>2 end)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(cid.actcon)
	c:RegisterEffect(e1)
end
function cid.actcon(e)
	local c=e:GetHandler()
	return c:GetMaterialCount()>3 and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
