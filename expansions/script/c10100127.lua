--Eythor, Verwalter der magischen Waffen
function c10100127.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x326),4,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c10100127.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c10100127.destg)
	e3:SetValue(c10100127.value)
	e3:SetOperation(c10100127.desop)
	c:RegisterEffect(e3)
	--effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10100127,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,10100127)
	e4:SetTarget(c10100127.tg)
	e4:SetOperation(c10100127.op)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	local e7=e4:Clone()
	e7:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e7)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(10100127,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c10100127.cost)
	e5:SetTarget(c10100127.target)
	e5:SetOperation(c10100127.operation)
	c:RegisterEffect(e5)
end
function c10100127.val(e,c)
	return Duel.GetMatchingGroupCount(c10100089.filter,c:GetControler(),LOCATION_SZONE,0,nil)*300
end
function c10100127.dfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_BATTLE) and c:IsType(TYPE_MONSTER) or c:IsReason(REASON_EFFECT) and c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c10100127.repfilter(c)
	return c:IsSetCard(0x326) and c:IsType(TYPE_EQUIP) and c:IsAbleToDeck()
end
function c10100127.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c10100127.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c10100127.repfilter,tp,LOCATION_SZONE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(10100127,0))
end
function c10100127.value(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)
end
function c10100127.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10100127.repfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c10100127.filter1(c)
	return c:IsCode(10100088) and c:IsAbleToHand()
end
function c10100127.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10100127.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c10100127.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10100127.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10100127.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10100127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10100127.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end