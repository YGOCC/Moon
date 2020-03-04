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
	e1:SetCountLimit(1,id)
	e1:SetCondition(cid.condition)
	e1:SetTarget(cid.destg)
	e1:SetOperation(cid.desop)
	c:RegisterEffect(e1)
	--Fragment creation
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1000)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cid.fragop)
	c:RegisterEffect(e2)
end
function cid.fragop(e,tp,eg,ep,ev,re,r,rp,chk)		
	--	local sc=Duel.CreateToken(tp,104242585)
	--	sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
	--	Duel.SendtoExtraP(sc,tp,REASON_RULE)
		local sc=Duel.CreateToken(tp,104242585)
		sc:SetCardData(CARDDATA_TYPE,sc:GetType()-TYPE_TOKEN)
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk)
if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	
end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_MONSTER)>0
	local b2=Duel.GetMatchingGroupCount(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)>0
	if chk==0 then return b1 or b2 end
	local s=0
	if b1 and not b2 then
		s=Duel.SelectOption(tp,aux.Stringid(id,0))
	end
	if not b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if b1 and b2 then
		s=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	end
	e:SetLabel(s)
	local g=nil
	if s==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_MONSTER)
	end
	if s==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,c,TYPE_SPELL+TYPE_TRAP)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	if e:GetLabel()==0 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_MONSTER)
	end
	if e:GetLabel()==1 then
		g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e),TYPE_SPELL+TYPE_TRAP)
	end
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
