--Moon's Dream: Escape!
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
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
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
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cid.costfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cid.filter(c)
	return (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cid.filter(chkc) end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingTarget(cid.costfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
		else return false end
	end
	e:SetLabel(0)
	local rt=Duel.GetTargetCount(cid.cfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,cid.fragment,tp,LOCATION_REMOVED,0,nil,rt-1,nil)
	local ct=cg:GetCount()
	if ct>0 and Duel.RemoveCards then
		Duel.RemoveCards(cg,nil,REASON_EFFECT+REASON_RULE)
		Duel.Remove(cg,POS_FACEUP,REASON_COST+REASON_RULE) end
			if cg and not Duel.RemoveCards then 
			Duel.Exile(cg,REASON_COST+REASON_RULE)
			end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectTarget(tp,cid.cfilter,tp,LOCATION_MZONE,0,ct+1,ct+1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
				while tc do
		 Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(cid.retop)
			Duel.RegisterEffect(e1,tp)
		    tc=sg:GetNext()
end
end














function cid.dodgetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)  end
	if chk==0 then return Duel.IsExistingTarget(cid.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cid.cfilter,tp,LOCATION_MZONE,0,1,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function cid.sgfilter(c,p)
	return c:IsLocation(LOCATION_REMOVED) and c:IsControler(p)
end
function cid.dodgeop(e,c,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetMatchingGroupCount(cid.fragment,tp,LOCATION_REMOVED,0,c)
	if sg:GetCount()==0  then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft+1,nil)
	end
	 		local tc=sg:GetFirst()
				while tc do
		 Duel.Remove(tc,tc:GetPosition(),REASON_EFFECT+REASON_TEMPORARY)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetOperation(cid.retop)
			Duel.RegisterEffect(e1,tp)
		    tc=sg:GetNext()
	if sg:GetCount()==0 or Duel.Remove(sg,REASON_EFFECT)==0 then return end
	local oc=Duel.GetOperatedGroup():FilterCount(cid.sgfilter,nil,tp)
	if oc==0 then return end
	local og=Duel.SelectMatchingCard(tp,cid.fragment,tp,LOCATION_REMOVED,0,oc,oc,nil)
	 Duel.Exile(og,REASON_EFFECT+REASON_RULE) 
--	local cost=:sg()-1
	Duel.SetLP(tp,Duel.GetLP(tp)-sg*1000)
	
end
end












function cid.retop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ReturnToField(e:GetLabelObject())
	e:Reset()
end