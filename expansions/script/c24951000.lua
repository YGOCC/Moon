-- Field of Magenic Flow
function c24951000.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(24951000,0))
	-- e2:SetCategory()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CHAINING) 
	e2:SetCountLimit(1,400000)
	e2:SetCondition(c24951000.modcon)
	e2:SetCost(c24951000.modcost)
	e2:SetOperation(c24951000.modop)
	c:RegisterEffect(e2)
	if not c24951000.global_check then
		c24951000.global_check=true
		c24951000[0]=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_REMOVE)
		ge1:SetCondition(c24951000.othercon)
		ge1:SetOperation(c24951000.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_GRAVE)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(ge3,0)
	end
end

function c24951000.modcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c24951000[0] 
		and re:GetHandler():IsSetCard(0x5F453A) 
		and Duel.IsExistingMatchingCard(c24951000.sendfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) then
		c24951000[1]=re:GetHandler()
		return true
	else
		return false
	end
end
function c24951000.othercon(e,tp,eg,ep,ev,re,r,rp)
 	local tc=eg:GetFirst()
 	local costgroup=Group.CreateGroup()
 	while tc do
 		local te=tc:GetReasonEffect()
		if tc:IsReason(REASON_COST) 
			-- and (tc:GetLocation()==LOCATION_DECK or tc:GetLocation()==LOCATION_REMOVED or tc:GetLocation()==LOCATION_GRAVE)
 			and not tc:IsReason(REASON_REDIRECT) 
			and te:GetHandler():IsSetCard(0x5F453A)
			and tc:IsSetCard(0x5F453A)
			-- and te:IsActivated() 
 			then
			costgroup:AddCard(tc)
		end
		tc=eg:GetNext()
	end
	if  costgroup:GetCount()==1 then -- Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c24951000[0] and
		c24951000[2]=costgroup:GetFirst()
		return true
	else
		return false
	end
end

function c24951000.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 then
		c24951000[0]=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
	end
end
function c24951000.sendfilter(c)
	return c:IsSetCard(0x5F453A) and c:IsAbleToDeckAsCost()
end
function c24951000.modcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c24951000.sendfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c24951000.sendfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoDeck(g,nil,REASON_COST,1)
	c24951000[3]=g:GetFirst()
end
function c24951000.modop(e,tp,eg,ep,ev,re,r,rp)
	-- if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c24951000.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		c24951000[4]=g:GetFirst()
	end
	if c24951000[4]:GetCode() ~= c24951000[3]:GetCode() and
		c24951000[4]:GetCode() ~= c24951000[2]:GetCode() and
		c24951000[4]:GetCode() ~= c24951000[1]:GetCode() and
		Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c24951000.filter(c)
	return c:IsSetCard(0x5F453A) and c:IsAbleToHand()
end