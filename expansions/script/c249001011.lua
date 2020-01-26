--Alchemy-Mage's Sage Stone
xpcall(function() require("expansions/script/bannedlist") end,function() require("script/bannedlist") end)
function c249001011.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,249001011)
	e1:SetCost(c249001011.cost)
	e1:SetOperation(c249001011.activate)
	c:RegisterEffect(e1)
	--add from deck to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e2:SetCountLimit(1,249001011)
	e2:SetCondition(c249001011.condition)
	e2:SetTarget(c249001011.target2)
	e2:SetOperation(c249001011.operation)
	c:RegisterEffect(e2)
	if not c249001011.globals then
		c249001011.globals=true
		c249001011.declared_table={}
		c249001011.declared_table[0]={}
		c249001011.declared_table[1]={}
		c249001011.ogformcodetable = {}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c249001011.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c249001011.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsCode(57116033) then
			if tc:GetPreviousControler()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,249001011,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,249001011,RESET_PHASE+PHASE_END,0,1) end
end
function c249001011.costfilter(c)
	return c:IsSetCard(0x203) and c:IsAbleToRemoveAsCost()
end
function c249001011.costfilter2(c,e)
	return c:IsSetCard(0x203) and not c:IsPublic()
end
function c249001011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249001011.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249001011.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249001011.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249001011.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249001011.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249001011.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249001011.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249001011.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	if Duel.GetLP(tp) < 4000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,2000)
	end
end
function c249001011.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.AnnounceCard(tp,TYPE_SPELL)
	local token=Duel.CreateToken(tp,ac)
	while not (c249001011.declared_table[tp][ac]~=true and banned_list_table[ac]~=true
		and (bit.band(token:GetActivateEffect():GetCategory(),CATEGORY_SPECIAL_SUMMON)~=0) or (bit.band(token:GetActivateEffect():GetCategory(),CATEGORY_DESTROY)~=0))
	do
		ac=Duel.AnnounceCard(tp,TYPE_SPELL)
		token=Duel.CreateToken(tp,ac)
	end
	c249001011.declared_table[tp][ac]=true
	c:CancelToGrave()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	if not c:IsLocation(LOCATION_HAND) then return end
	c249001011.ogformcodetable[c]=c:GetCode()
	c:RegisterFlagEffect(249001011,RESET_EVENT,0,1)
	c:SetEntityCode(ac,true)
	c:ReplaceEffect(ac,0,0)
	Duel.SetMetatable(c,_G["c"..ac])
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_EVENT)
	e1:SetOperation(c249001011.revertop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
end
function c249001011.revertop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("Line 116")
	local c=e:GetHandler()
	if not (c:GetFlagEffect(249001011)~=0 and c249001011.ogformcodetable[c]) then return end
	local code=c249001011.ogformcodetable[c]
	c:ResetFlagEffect(249001011)
	c:SetEntityCode(code,true)
	c:ReplaceEffect(code,0,0)
	Duel.SetMetatable(c,_G["c"..code])
	for key,value in pairs(global_card_effect_table[c]) do
		if value:GetOperation()==c249001011.revertop then value:Reset()	 end
	end
end
function c249001011.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,249001011)~=0
end
function c249001011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c249001011.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsLocation(LOCATION_DECK) then return end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
end