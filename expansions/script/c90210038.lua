--儀式の供物
function c90210038.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--ATK UP
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90210038,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c90210038.cost)
	e1:SetTarget(c90210038.target)
	e1:SetOperation(c90210038.operation)
	c:RegisterEffect(e1)
end
function c90210038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c90210038.filter1(c)
	return c:IsSetCard(0x12C) or c:IsSetCard(0x12D) and c:GetCode()~=90210023 and c:GetCode()~=90210037 and c:IsAbleToHand()
end
function c90210038.filter2(c)
	return c:IsSetCard(0x12F) and c:IsAbleToHand()
end
function c90210038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90210038.filter1,tp,LOCATION_DECK,0,1,nil) or
	Duel.IsExistingMatchingCard(c90210038.filter2,tp,LOCATION_DECK,0,1,nil) end
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(c90210038.filter1,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(90210038,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.IsExistingMatchingCard(c90210038.filter2,tp,LOCATION_DECK,0,1,nil) then
		ops[off]=aux.Stringid(90210038,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	e:SetLabel(opval[op])
end
function c90210038.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,c90210038.filter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local g=Duel.SelectMatchingCard(tp,c90210038.filter2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
