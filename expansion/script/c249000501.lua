--Turquoise-Mage
function c249000501.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(30312361,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,249000501)
	e1:SetCost(c249000501.cost)
	e1:SetOperation(c249000501.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0xFF)
	e2:SetOperation(c249000501.regop)	
	c:RegisterEffect(e2)
end
c249000501.copied_effect_table={}
function c249000501.costfilter(c)
	return c:IsSetCard(0x1C5) and c:IsAbleToDeckAsCost()
end
function c249000501.costfilter2(c,e)
	return c:IsSetCard(0x1C5) and not c:IsPublic() and c~=e:GetHandler()
end
function c249000501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(c249000501.costfilter,tp,LOCATION_GRAVE,0,1,nil)
	or Duel.IsExistingMatchingCard(c249000501.costfilter2,tp,LOCATION_HAND,0,1,nil,e)) end
	local option
	if Duel.IsExistingMatchingCard(c249000501.costfilter2,tp,LOCATION_HAND,0,1,nil,e)  then option=0 end
	if Duel.IsExistingMatchingCard(c249000501.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then option=1 end
	if Duel.IsExistingMatchingCard(c249000501.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	and Duel.IsExistingMatchingCard(c249000501.costfilter2,tp,LOCATION_HAND,0,1,nil,e) then
		option=Duel.SelectOption(tp,526,1307)
	end
	if option==0 then
		g=Duel.SelectMatchingCard(tp,c249000501.costfilter2,tp,LOCATION_HAND,0,1,1,nil,e)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
	if option==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c249000501.costfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end
end
function c249000501.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.AnnounceCard(tp)
	local valid=false
	local te=nil
	local option=0
	local i=0
	while not valid do
		if ac==249000501 then return end
		if not (c249000501.copied_effect_table[ac]==nil or c249000501.copied_effect_table[ac]=={}) then
			local optionarg={}
			i=1
			while c249000501.copied_effect_table[ac][i] do
				local desc=c249000501.copied_effect_table[ac][i]:GetDescription()
				if desc then
					optionarg[i]=desc
				else
					optionarg[i]=0
				end
				i=i+1
		end
			if i > 2 then
				option=Duel.SelectOption(tp,table.unpack(optionarg))+1
			else
				option=1
			end
			te=c249000501.copied_effect_table[ac][option]
			if te then
				local tg=te:GetTarget()
				if (tg and tg(e,tp,eg,ep,ev,re,r,rp,0)) or not tg then
					valid=true
				else
					ac=Duel.AnnounceCard(tp)
				end
			else
				ac=Duel.AnnounceCard(tp)
			end
		else
			ac=Duel.AnnounceCard(tp)
		end
	end	
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	local tg=te:GetTarget()
	local op=te:GetOperation()
	c:CreateEffectRelation(te)
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ect
	if g then
		etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then 
		op(e,tp,eg,ep,ev,re,r,rp)
	end
	c:ReleaseEffectRelation(te)
	if g then
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
	table.remove(c249000501.copied_effect_table[ac],option)
end
function c249000501.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler():GetCode()
	if rc==249000501 then return end
	if c249000501.copied_effect_table[rc]==nil then
		c249000501.copied_effect_table[rc]={re}
		return
	end
	local i=1
	while c249000501.copied_effect_table[rc][i] do
		if c249000501.copied_effect_table[rc][i]==re then return end
		i=i+1
	end
	c249000501.copied_effect_table[rc]={table.unpack(c249000501.copied_effect_table[rc]),re}
end