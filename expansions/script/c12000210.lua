--Realm of the Dimension Dragons
function c12000210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12000210+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12000210.target)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12000210,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c12000210.drcost)
	e2:SetTarget(c12000210.drtg)
	e2:SetOperation(c12000210.drop)
	c:RegisterEffect(e2)
end
function c12000210.thfilter(c)
	return c:IsSetCard(0x855) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12000210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12000210.thfilter(chkc) end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c12000210.thfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(12000210,0)) then
		e:SetCategory(CATEGORY_TOHAND)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c12000210.activate)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,c12000210.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c12000210.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c12000210.cfilter(c)
	return (c:IsSetCard(0x855) and c:IsDiscardable() and c:IsLocation(LOCATION_HAND))
		or Duel.IsExistingMatchingCard(c12000210.dfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c12000210.dfilter(c)
	return c:IsSetCard(0x855) and c:IsFaceup() and c:IsAbleToGraveAsCost()
		and not c:IsCode(12000210)
end
function c12000210.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12000210.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local sg=Duel.SelectMatchingCard(tp,c12000210.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	if sg:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
	else
		Duel.SendtoGrave(sg,REASON_COST)
	end
end
function c12000210.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12000210.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end