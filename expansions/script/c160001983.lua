--Painting the Power Portait
function c160001983.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160001983,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c160001983.cost)
	e1:SetTarget(c160001983.target)
	e1:SetOperation(c160001983.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(160001983,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,160001983)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c160001983.thtg)
	e2:SetOperation(c160001983.thop)
	c:RegisterEffect(e2)
end
function c160001983.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsAbleToRemoveAsCost()
end
function c160001983.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160001983.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c160001983.cfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,2,2,nil)
	e:SetLabelObject(g:Filter(Card.IsSetCard,nil,0xc50):GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c160001983.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c160001983.target(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsOnField() and c160001983.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c160001983.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c160001983.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c160001983.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetLabelObject()~=nil then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x17a0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetReset(RESET_EVENT+0x17a0000)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end

function c160001983.thfilter(c)
	return c:IsSetCard(0xc50)  and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c160001983.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK)
		and Duel.IsExistingMatchingCard(c160001983.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c160001983.thop(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c160001983.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		local rg=Group.CreateGroup()
		for i=1,3 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			if tc then
				rg:AddCard(tc)
				g:Remove(Card.IsCode,nil,tc:GetCode())
			end
		end
		Duel.ConfirmCards(1-tp,rg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=rg:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
