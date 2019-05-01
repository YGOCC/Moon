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
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetCode(EFFECT_RANDOM_TARGET)
	e0:SetTargetRange(1,0)
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