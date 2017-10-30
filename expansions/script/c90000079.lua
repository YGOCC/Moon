--Black Flag Sword
function c90000079.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE))
	--ATK/DEF Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c90000079.value1)
	c:RegisterEffect(e1)
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c90000079.condition2)
	e2:SetTarget(c90000079.target2)
	e2:SetOperation(c90000079.operation2)
	c:RegisterEffect(e2)
end
function c90000079.filter1(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c90000079.value1(e,c)
	return Duel.GetMatchingGroupCount(c90000079.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*300
end
function c90000079.filter2(c,rc)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:GetReasonCard()==rc
end
function c90000079.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c90000079.filter2,1,nil,e:GetHandler():GetEquipTarget())
end
function c90000079.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90000079.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end