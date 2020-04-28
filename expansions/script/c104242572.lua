--Moon's Dream: You're Gone!
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
 	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.destg)
	e1:SetOperation(cid.desop)
	c:RegisterEffect(e1)
end
function cid.fragment(c)
	return c:IsCode(104242585) and c:IsFaceup()
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	local b1=1
	local b2=Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,1,nil)
	local b3=Duel.IsExistingMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,2,nil)
	local op=0
	if b1 or b2 or b3 then
			local m={}
			local n={}
			local ct=1
			if b1 then m[ct]=aux.Stringid(id,0) n[ct]=1 ct=ct+1 end
			if b2 then m[ct]=aux.Stringid(id,1) n[ct]=2 ct=ct+1 end
			if b3 then m[ct]=aux.Stringid(id,2) n[ct]=3 ct=ct+1 end
			local sp=Duel.SelectOption(tp,table.unpack(m))
			op=n[sp+1]
	end
	e:SetLabel(op)
	if op==1 then
		Duel.BreakEffect()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	elseif op==2 then
	Duel.BreakEffect()
	local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and tc:IsRelateToEffect(e) and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
			if frag and tc:IsRelateToEffect(e) and not Duel.RemoveCards then 
			Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
elseif op==3 then
		Duel.BreakEffect()
	local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and tc:IsRelateToEffect(e) and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		end
	local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and Duel.RemoveCards then
		Duel.RemoveCards(frag,nil,REASON_EFFECT+REASON_RULE)
		end
	local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and tc:IsRelateToEffect(e) and not Duel.RemoveCards then 
		Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
		end
	local frag=Duel.GetFirstMatchingCard(cid.fragment,tp,LOCATION_REMOVED,0,nil,e,tp)
		if frag and not Duel.RemoveCards then
		Duel.Exile(frag,REASON_EFFECT+REASON_RULE)
		end
end
local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
		local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
end
end
