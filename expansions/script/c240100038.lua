--created & coded by Lyris, art at https://data.desustorage.org/m/image/1447/59/1447591425399.jpg
--襲雷ストアイク
function c240100038.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCondition(c240100038.con)
	e0:SetTarget(c240100038.tg)
	e0:SetOperation(c240100038.op)
	c:RegisterEffect(e0)
end
function c240100038.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4)
end
function c240100038.con(e,tp,eg,ep,ev,r,re,rp)
	return Duel.IsExistingMatchingCard(c240100038.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c240100038.tg(e,tp,eg,ep,ev,r,re,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c240100038.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x7c4)
end
function c240100038.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local loc=LOCATION_REMOVED
	local tc=nil
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	tc=tg:GetFirst()
	while tc do
		if c240100038.filter(tc) then loc=LOCATION_GRAVE end
		if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT,loc)~=0 then ct=ct+1 end
		tc=tg:GetNext()
	end
	if ct==0 then return end
	local g1=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_ONFIELD,nil)
	local g0=nil
	if g1:GetCount()==0 then c240100038.desop(e,tp,ct,g1,g0) return end
	if g1:GetCount()>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g0=g1:Select(tp,ct,ct,nil)
		Duel.HintSelection(g0)
	else
		g0=g1
	end
	tc=g0:GetFirst()
	while tc do
		if c240100038.filter(tc) then loc=LOCATION_GRAVE end
		if Duel.Destroy(tc,REASON_EFFECT,loc)~=0 then ct=ct-1 end
		tc=g0:GetNext()
	end
	if ct==0 then return end
	c240100038.desop(e,tp,ct,g1,g0)
end
function c240100038.desop(e,tp,ct,g1,g0)
	local g4=nil
	local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_HAND,nil)
	if g2:GetCount()<ct then
		g4=Duel.GetDecktopGroup(1-tp,ct-g2:GetCount())
	end
	if g2:GetCount()==0 then
		g4=Duel.GetDecktopGroup(1-tp,ct)
	elseif g2:GetCount()==ct then
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT+REASON_DESTROY)
		return
	else
		for i=1,ct do
			local g3=g2:RandomSelect(tp,1):GetFirst()
			if Duel.Remove(g3,POS_FACEUP,REASON_EFFECT+REASON_DESTROY)~=0 then ct=ct-1 end
		end
	end
	if g4 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g4,POS_FACEUP,REASON_EFFECT)
	end
end
