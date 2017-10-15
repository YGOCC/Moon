--Sin & Virtue, Bounded
function c9945240.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9945240.target2)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9945240,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,9945240)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c9945240.cost)
	e2:SetTarget(c9945240.target)
	e2:SetOperation(c9945240.operation)
	c:RegisterEffect(e2)
end
function c9945240.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c9945240.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return true end
	if c9945240.target(e,tp,eg,ep,ev,re,r,rp,0,chkc) and Duel.GetFlagEffect(tp,9945240)==0 and Duel.SelectYesNo(tp,94) then
		e:SetOperation(c9945240.operation)
		c9945240.target(e,tp,eg,ep,ev,re,r,rp,1,chkc)
		Duel.RegisterFlagEffect(tp,9945240,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9945240,2))
	else
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c9945240.filter(c)
	return (c:IsSetCard(0x204F) or c:IsSetCard(0x2050)) and c:IsAbleToRemove()
		and (c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsStatus(STATUS_ACTIVATED)) or (c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
		or (c:IsFaceup() and c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_REMOVED))
end
function c9945240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9945240)==0 end
	Duel.RegisterFlagEffect(tp,9945240,RESET_PHASE+PHASE_END,0,1)
end
function c9945240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c9945240.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),ft) end
end
function c9945240.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9945240.filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),ft)
	if g:GetCount()>0 then
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)
	local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c9945240.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9945240.retop(e,tp,eg,ep,ev,re,r,rp)
local tc=e:GetLabelObject()
	if tc and Duel.GetTurnPlayer()==tp and tc:IsAbleToHand() and tc:IsPreviousLocation(LOCATION_HAND) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		elseif tc and Duel.GetTurnPlayer()==tp and tc:IsPreviousLocation(LOCATION_ONFIELD) and Duel.SelectYesNo(tp,aux.Stringid(9945240,1)) then
		Duel.ReturnToField(tc)
		elseif tc:IsAbleToHand() and Duel.GetTurnPlayer()==tp and tc:IsPreviousLocation(LOCATION_ONFIELD) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end