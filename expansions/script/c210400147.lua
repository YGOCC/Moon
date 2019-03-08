--created & coded by Lyris, art by Ali Rauf
--襲雷渦動
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()
function cid.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetCondition(cid.discon)
	e2:SetTarget(cid.distg)
	e2:SetOperation(cid.disop)
	c:RegisterEffect(e2)
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function cid.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7c4) and c:IsDestructable()
end
function cid.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.dfilter,tp,LOCATION_ONFIELD,0,1,aux.ExceptThisCard(e)) and not re:GetHandler():IsStatus(STATUS_DISABLED) end
	local g=Duel.GetMatchingGroup(cid.dfilter,tp,LOCATION_ONFIELD,0,aux.ExceptThisCard(e))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.dfilter,tp,LOCATION_ONFIELD,0,1,1,aux.ExceptThisCard(e))
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		Duel.NegateEffect(ev)
	end
end
