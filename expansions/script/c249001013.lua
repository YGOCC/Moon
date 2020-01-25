--Alchemy-Mage Polymorph
--xpcall(function() require("expansions/script/bannedlist") end,function() require("script/bannedlist") end)
function c249001013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCountLimit(1,249001013)
	e1:SetCost(c249001013.cost)
	e1:SetOperation(c249001013.operation)
	c:RegisterEffect(e1)
	if not c249001013.globals then
		c249001013.globals=true
		c249001013.declared_table={}
		c249001013.declared_table[0]={}
		c249001013.declared_table[1]={}
		c249001013.ogformcodetable = {}
	end
end
function c249001013.costfilter(c)
	return c:IsSetCard(0x203) and c:IsAbleToRemoveAsCost()
end
function c249001013.costfilter2(c,e)
	return c:IsSetCard(0x203) and not c:IsPublic()
end
function c249001013.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (Duel.IsExistingMatchingCard(c249001013.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249001013.costfilter2,tp,LOCATION_HAND,0,1,c)) end
	local option
	if Duel.IsExistingMatchingCard(c249001013.costfilter2,tp,LOCATION_HAND,0,1,c)  then option=0 end
	if Duel.IsExistingMatchingCard(c249001013.costfilter,tp,LOCATION_GRAVE,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249001013.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(c249001013.costfilter2,tp,LOCATION_HAND,0,1,c) then
		option=Duel.SelectOption(tp,526,1102)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249001013.costfilter2,tp,LOCATION_HAND,0,1,1,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c249001013.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	if Duel.GetLP(tp) < 6000 then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	else
		Duel.PayLPCost(tp,3000)
	end
end
function c249001013.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local sumrestrictions
	local key
	local value
	local ac
	local token
	repeat
		sumrestrictions=false
		ac=Duel.AnnounceCardFilter(tp,TYPE_MONSTER,OPCODE_ISTYPE,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_PENDULUM,OPCODE_ISTYPE,OPCODE_NOT,OPCODE_AND)
		token=Duel.CreateToken(tp,ac)
		for key,value in pairs(global_card_effect_table[e:GetHandler()]) do
			if value:IsHasType(EFFECT_SPSUMMON_CONDITION) then sumrestrictions=true	 end
		end
	until not (c249001013.declared_table[tp][ac]~=true -- and banned_list_table[ac]~=true
	and token:IsSummonableCard() and not sumrestrictions)
	c249001013.declared_table[tp][ac]=true
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	if not c:IsLocation(LOCATION_HAND) then return end
	c249001013.ogformcodetable[c]=c:GetCode()
	c:RegisterFlagEffect(249001013,RESET_EVENT,0,1)
	c:SetEntityCode(ac,true)
	c:ReplaceEffect(ac,0,0)
	Duel.SetMetatable(c,_G["c"..ac])
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetReset(RESET_EVENT)
	e1:SetOperation(c249001013.revertop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e3)
end
function c249001013.revertop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:GetFlagEffect(249001013)~=0 and c249001013.ogformcodetable[c]) then return end
	local code=c249001013.ogformcodetable[c]
	c:ResetFlagEffect(249001013)
	c:SetEntityCode(code,true)
	c:ReplaceEffect(code,0,0)
	Duel.SetMetatable(c,_G["c"..code])
	for key,value in pairs(global_card_effect_table[c]) do
		if value:GetOperation()==c249001013.revertop then value:Reset()	 end
	end
end