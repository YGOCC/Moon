function c90210007.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Effect indestructable
--	local e2=Effect.CreateEffect(c)
--	e2:SetType(EFFECT_TYPE_FIELD)
--	e2:SetRange(LOCATION_FZONE)
--	e2:SetTargetRange(c900000007.filtertarget,nil)
--	e2:SetValue(aux.tgval)
--	c:RegisterEffect(e2)
	--Effect Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90210007,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c90210007.drcon)
	e3:SetCost(c90210007.drcost)
	e3:SetTarget(c90210007.drtg)
	e3:SetOperation(c90210007.drop)
	c:RegisterEffect(e3)
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,nil)
	e4:SetTarget(c90210007.tg)
	e4:SetValue(c90210007.atkval)
	c:RegisterEffect(e4)
end
function c90210007.atkfilter(c)
	return c:IsSetCard(0x12C) and c:IsType(TYPE_MONSTER)
	 or c:IsSetCard(0x12D) and c:IsType(TYPE_MONSTER)
	 or c:IsSetCard(0x130) and c:IsType(TYPE_MONSTER)
end
function c90210007.atkval(e,c)
	return Duel.GetMatchingGroupCount(c90210007.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c90210007.tg(e,c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130)
end
function c90210007.filtertarget(e,c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130)
end
function c90210007.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c90210007.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210007.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c90210007.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c90210007.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c90210007.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c90210007.target(e,c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) or c:IsSetCard(0x130)
end
function c90210007.filter(c)
	return c:IsSetCard(0x12C) and c:IsAbleToDeckAsCost() or c:IsSetCard(0x12D) and c:IsAbleToDeckAsCost()
	or c:IsSetCard(0x130) and c:IsAbleToDeckAsCost()
end