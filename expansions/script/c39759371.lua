--Aereomobile Bombardiere
--Script by XGlitchy30
function c39759371.initial_effect(c)
	--Deck Master
	aux.AddOrigDeckmasterType(c)
	aux.EnableDeckmaster(c,nil,nil,c39759371.mscon,nil,c39759371.penaltycon,c39759371.penalty)
	--Ability: Bombdrop
	local ab=Effect.CreateEffect(c)
	ab:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ab:SetCategory(CATEGORY_DESTROY)
	ab:SetType(EFFECT_TYPE_IGNITION)
	ab:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ab:SetRange(LOCATION_SZONE)
	ab:SetCountLimit(1,39759371)
	ab:SetCondition(aux.CheckDMActivatedState)
	ab:SetCost(c39759371.drycost)
	ab:SetTarget(c39759371.drytg)
	ab:SetOperation(c39759371.dryop)
	c:RegisterEffect(ab)
	--Register Destruction
	if not c39759371.global_check then
		c39759371.global_check=true
		c39759371[0]=0
		c39759371[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(aux.CheckDMActivatedState)
		ge1:SetOperation(c39759371.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--filters
function c39759371.filter2(c,re,rp,tf,ceg,cep,cev,cre,cr,crp,ct)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) and (ct==0 or (ct>0 and Duel.IsExistingTarget(c39759371.filter2,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,nil,re,rp,tf,ceg,cep,cev,cre,cr,crp,ct-1)))
end
function c39759371.randomcheck(c,rgd)
	return c:GetFlagEffect(39759371)~=0 and c:GetFlagEffectLabel(39759371)==rgd
end
function c39759371.costfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())) and c:IsAbleToGraveAsCost()
end
function c39759371.dryfilter(c)
	return true
end
--Register Destruction
function c39759371.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=0
	local p2=0
	while tc do
		if tc:GetReasonPlayer()==0 then 
			p1=p1+1 
		else 
			p2=p2+1 
		end
		tc=eg:GetNext()
	end
	if p1>0 then 
		c39759371[0]=c39759371[0]+p1
		if e:GetHandler():IsControler(tp) then
			e:GetHandler():SetTurnCounter(c39759371[e:GetHandler():GetControler()])
		end
	end
	if p2>0 then 
		c39759371[1]=c39759371[1]+p2
		if e:GetHandler():IsControler(1-tp) then
			e:GetHandler():SetTurnCounter(c39759371[e:GetHandler():GetControler()])
		end
	end
end
--Deck Master Functions
function c39759371.DMCost(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EVENT_CHAIN_ACTIVATING)
	e0:SetCondition(c39759371.tgcon)
	e0:SetOperation(c39759371.tgop)
	Duel.RegisterEffect(e0,tp)
end
function c39759371.mscon(e,c)
	return c39759371[c:GetControler()]>=5 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c39759371.penaltycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil)
end
function c39759371.penalty(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_GRAVE,1,nil) then return end
	if Duel.SelectYesNo(1-tp,aux.Stringid(39759371,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(Card.IsAbleToHand),tp,0,LOCATION_GRAVE,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end
--random target selection (WARNING: Some cards that choose multiple targets might cause buggy interactions)
function c39759371.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or re:IsHasType(EFFECT_TYPE_CONTINUOUS) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	if g:GetCount()==1 then
		local tc=g:GetFirst()
		e:SetLabelObject(tc)
		e:SetLabel(0)
		return tc
	else
		e:SetLabelObject(g)
		e:SetLabel(g:GetCount()-1)
		return true
	end
end
function c39759371.tgop(e,tp,eg,ep,ev,re,r,rp)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,39759371)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	local ce,cp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tf=re:GetTarget()
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ct)
	local ctt=0
	if e:GetLabel()>0 then ctt=e:GetLabel() end
	if not Duel.IsExistingTarget(c39759371.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,1,nil,ce,cp,tf,ceg,cep,cev,cre,cr,crp,ctt) then 
		Debug.Message('It is currently impossible to randomize the targets of '..tostring(re:GetHandler()))
		return 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.GetMatchingGroup(c39759371.filter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,nil,ce,cp,tf,ceg,cep,cev,cre,cr,crp,ctt)
	g:KeepAlive()
	local ct=1
	for i in aux.Next(g) do
		i:RegisterFlagEffect(39759371,RESET_EVENT+EVENT_CUSTOM+39759371,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE,1)
		i:SetFlagEffectLabel(39759371,ct)
		ct=ct+1
	end
	local labfix=1
	local tc={}
	if e:GetLabel()<=0 then
		local check=true
		while check do
			local rgd=math.random(1,g:GetCount())
			if g:IsExists(c39759371.randomcheck,1,nil,rgd) then
				local gm=g:Filter(c39759371.randomcheck,nil,rgd)
				tc[0]=gm:GetFirst()
				g:RemoveCard(tc[0])
				check=false
			end
		end
		local val=ct+bit.lshift(ev+1,16)
		if label then
			Duel.SetFlagEffectLabel(0,39759371,val)
		else
			Duel.RegisterFlagEffect(0,39759371,RESET_CHAIN,0,1,val)
		end
		if tc[0]~=e:GetLabelObject() then
			local gtc=Group.CreateGroup()
			gtc:AddCard(tc[0])
			Duel.ChangeTargetCard(ev,gtc)
		end
	else
		for times=0,ctt,1 do
			local check=true
			while check do
				local rgd=math.random(1,g:GetCount())
				if g:IsExists(c39759371.randomcheck,1,nil,rgd) then
					local gm=g:Filter(c39759371.randomcheck,nil,rgd)
					tc[times]=gm:GetFirst()
					g:RemoveCard(tc[times])
					check=false
					if ce:GetLabelObject() and ce:GetLabelObject()~=tc[times] and labfix>0 then
						ce:SetLabelObject(tc[times])
					end
					labfix=math.random(0,1)
				end
			end
		end
		local gtg=Group.CreateGroup()
		for chk=0,ctt,1 do
			gtg:AddCard(tc[chk])
		end
		local val=ct+bit.lshift(ev+1,16)
		if label then
			Duel.SetFlagEffectLabel(0,39759371,val)
		else
			Duel.RegisterFlagEffect(0,39759371,RESET_CHAIN,0,1,val)
		end
		Duel.ChangeTargetCard(ev,gtg)
	end
end
--Ability: Bombdrop
function c39759371.drycost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c39759371.drytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then
		if e:GetLabel()==100 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c39759371.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		else 
			return false 
		end
	end
	local rt=Duel.GetTargetCount(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct=0
	local min=1
	while ct<rt do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,c39759371.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,min,1,nil,tp)
		if #sg==0 then break end
		Duel.SendtoGrave(sg:GetFirst(),REASON_COST)
		ct=ct+1
		min=0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c39759371.dryfilter,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c39759371.dryop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g2=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g2,REASON_EFFECT)
end