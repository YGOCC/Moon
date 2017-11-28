--Black Flag Sword
function c90000075.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE))
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c90000075.value1)
	c:RegisterEffect(e1)
	--DEF Up
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c90000075.condition3)
	e3:SetTarget(c90000075.target3)
	e3:SetOperation(c90000075.operation3)
	c:RegisterEffect(e3)
end
function c90000075.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c90000075.value1(e,c)
	return Duel.GetMatchingGroupCount(c90000075.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,c)*500
end
function c90000075.filter3(c,rc)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:GetReasonCard()==rc
end
function c90000075.condition3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c90000075.filter3,1,nil,e:GetHandler():GetEquipTarget())
end
function c90000075.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90000075.operation3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end