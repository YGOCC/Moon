local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
--created by Zolanark, coded by Lyris
--Arthro-Paladin War Cry
function cid.initial_effect(c)
	aux.AddRitualProcGreaterCode(c,118201805)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e0:SetCondition(cid.condition)
	e0:SetTarget(cid.target)
	e0:SetOperation(cid.operation)
	c:RegisterEffect(e0)
end
function cid.filter(c)
	return c:IsCode(118201805) and c:IsPosition(POS_FACEUP_ATTACK)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Remove(c,POS_FACEUP,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(500)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		tc:RegisterEffect(e1)
	end
end
